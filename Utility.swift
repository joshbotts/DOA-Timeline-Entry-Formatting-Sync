//
//  Utility.swift
//  Admin Timeline Exporter
//
//  Created by Joshua Botts on 1/19/21.
//

import Foundation
import AirtableKit
import Combine

class DOATimelineEntryUpdater {
    var json: [Entry]
    var doa: [DOATimelineEntry]
    var records: [AirtableKit.Record]
    var test: [AirtableKit.Record]
    var subscriber: Subscription?
    var status: Status
    
    enum Status: String {
        case initialStartUp = "Initial Start Up"
        case localJSONLoaded = "Local JSON Entries Loaded and Initialized"
        case doaLoaded = "Local DOA Entries Downloaded and Initialized"
        case localSync = "DOA and XML Entries Synced"
        case doaUpdated = "Airtable DOA Entries Updated from XML Values"
    }
    
    init() {
        self.json = [Entry]()
        self.doa = [DOATimelineEntry]()
        self.records = [AirtableKit.Record]()
        self.test = [AirtableKit.Record]()
        self.status = DOATimelineEntryUpdater.Status.initialStartUp
    }
    
    func loadLocalJSON() {
        let jsonURL = LocalFiles.markdownJSON
        let decoder = JSONDecoder()
        let decodedEntries = try! decoder.decode(EntriesWrapper.self, from: Data(contentsOf: jsonURL))
        self.json = decodedEntries.entries.entry
        self.status = DOATimelineEntryUpdater.Status.localJSONLoaded
        print("\(self.json.count) entries with formatted text loaded from local JSON")
    }
    
    func getDOABaseline() {
        if self.status == DOATimelineEntryUpdater.Status.localJSONLoaded {
            let localDOAURL = LocalFiles.existingDOAJSON
            let decoder = JSONDecoder()
            let decodedRecords = try! decoder.decode(DOARecords.self, from: Data(contentsOf: localDOAURL))
            self.doa = decodedRecords.records
            self.status = DOATimelineEntryUpdater.Status.doaLoaded
            print("\(self.doa.count) DOA entries without formatted text loaded from local file")
        } else {
            print("Did not attempt to load DOA entries from local file - local JSON with formatted text was not loaded")
        }
    }
    
    func updateLocalDOA() {
        var unmatched = [DOATimelineEntry]()
        if self.status == DOATimelineEntryUpdater.Status.doaLoaded {
            var jsonLookup = [String: Entry]()
            for entry in self.json {
                let id = String(entry.xmlIndex)
                jsonLookup[id] = entry
            }
            for record in self.doa {
                if record.fields.entryID != nil {
                    let id = String(record.fields.entryID!)
                    if let jsonEntry = jsonLookup[id] {
                            print("""
                                Timeline Entry \(id) matched.
                                Old text: \(record.fields.description!)
                                New text: \(jsonEntry.text.text)
                            """)
                            var newRecord = record
                            newRecord.fields.importedFormattedDescription = jsonEntry.text.text
                            self.records.append(newRecord.convertToAirtableRecord())
                            print("Entry text for record \(newRecord.fields.entryID!) updated to formatted version and added to sync queue:")
                    } else {
                        print("😬😬 Record \(record.fields.entryID!) not matched")
                        unmatched.append(record)
                    }
                }
            }
            self.status = DOATimelineEntryUpdater.Status.localSync
            for record in unmatched {
                print("😬😬 DOA record \(record.fields.entryID!) not matched - change local json record with \(record.fields.dateType!): \(record.fields.naturalLanguageDate!) to match value")
            }
            print("Formatted entry text synced locally and ready to upload for \(self.records.count) records")
        } else {
            print("Did not complete task - DOA entries were not downloaded")
        }
    }
    
    func syncDOAtoAirtable() {
        var tasks = [URLRequest]()
        let session = URLSession.shared
        let baseURL = DOA.baseURL
        let method = "PATCH"
        let apiKey = DOA.apiKey
        let encoder = JSONEncoder()
        var batches = [DOARecords]()
        var throttler = Date()
        var updates = [URLSessionDataTask]()
        
        if self.status == DOATimelineEntryUpdater.Status.localSync {
            // for loop over records to create batches of 10
            let recordsBatched = self.records.chunked(by: 10)
            for recordsBatch in recordsBatched {
                let batch = DOARecords(records: recordsBatch)
                batches.append(batch)
            }
            
//            // for loop [self.records] create batched URL task to deliver entry updates and append to tasks array, print request url to console
            for batch in batches {
            var ids = [String]()
            for record in batch.records {
                    ids.append(record.id)
                }
            let joinedIDs = ids.joined(separator: ", ")
            var request = URLRequest(url: baseURL)
            request.httpMethod = method
            request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            let json = try? encoder.encode(DOARecords(records: batch.records.map { $0.convertToAirtableRecord() }))
                request.httpBody = json
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                print("\(joinedIDs): \(request) using \(request.httpMethod) with headers \(request.allHTTPHeaderFields) with \(String(data: request.httpBody!, encoding: .utf8))")
            tasks.append(request)
            }
            
            // for loop [tasks] to iterate over tasks, print completion response to console
            for task in tasks {
                let update = session.dataTask(with: task) { data, response, error in
                    if let error = error {
                                print(error)
                            }
                    guard let httpResponse = response as? HTTPURLResponse else {
                        throttler = Date()
                        print(response as Any)
                                return
                            }
                    if let data = data,
                                let string = String(data: data, encoding: .utf8) {
                                DispatchQueue.main.async {
                                    throttler = Date()
                                    print("Result for \(task): \(string)")
                                }
                    } else {
                        print(response)
                    }
                }
                update.resume()
            }
            
        } else {
            print("Did not complete task - DOA entries have not been updated with local JSON values")
        }
    }
}

// extension from AirtableKit used to batch patch requests

extension Array {
    
    /// Groups the elements of the receiver by forming arrays of max size `chunkSize`.
    ///
    /// Example:
    ///
    ///     [1, 2, 3, 4, 5].chunked(by: 2) == [[1, 2], [3, 4], [5]]
    ///
    /// Reference: https://www.hackingwithswift.com/example-code/language/how-to-split-an-array-into-chunks
    ///
    /// - Precondition: `chunkSize > 0`
    /// - Parameter chunkSize: Maximum size of each chunk.
    /// - Returns: The same elements of the receiver, grouped into chunks of at most `chunkSize` elements.
    func chunked(by chunkSize: Int) -> [[Element]] {
        precondition(chunkSize > 0)
        
        return stride(from: startIndex, to: endIndex, by: chunkSize).map {
            Array(self[$0 ..< Swift.min(index($0, offsetBy: chunkSize), endIndex)])
        }
    }
}

