//
//  Data Model.swift
//  Admin Timeline Exporter
//
//  Created by Joshua Botts on 1/19/21.
//

import Foundation
import AirtableKit

struct DOAUpdate: Codable {
    var data: DOARecords
}

struct DOARecords: Codable {
    var records: [DOATimelineEntry]
    
    enum CodingKeys: String, CodingKey {
        case records
    }
    
    init(records: [Record]) {
        self.records = [DOATimelineEntry]()
        for record in records {
            self.records.append(DOATimelineEntry(record: record))
        }
    }
    
    init(file: Data) {
        let decoder = JSONDecoder()
        let decodedRecords = try? decoder.decode(DOARecords.self, from: file)
        if decodedRecords == nil {
            print("Failed to decode file")
        }
        self.records = decodedRecords?.records ?? [DOATimelineEntry]()
    }
}

struct DOATimelineEntry: Codable {
    var id: String
    var createdTime: String?
    var fields: Fields
    
    struct Fields: Codable {
        var date: String?
        var startDate: String?
        var endDate: String?
        var notBeforeDate: String?
        var notAfterDate: String?
        var description: String?
        var naturalLanguageDate: String?
        var event: [String]?
        var dateType: String?
        var entryID: Int?
        var status: [String]?
        var provenance: String?
        var id: String?
        var sortDate: String?
        var xmlElement: String?
        var didNotes: [String]?
        var didPersonXR: [String]?
        var didCountryXR: [String]?
        var hsgXR: String?
        var lastSnapshotAttempt: String?
        var lastSnapshotSucceeded: Bool?
        var lastSynchronizationAttempt: String?
        var lastSynchronizationSucceeded: Bool?
        var importedFormattedDescription: String?
        
        enum CodingKeys: String, CodingKey {
            case date = "Date"
            case startDate = "Start Date"
            case endDate = "End Date"
            case notBeforeDate = "Not Before Date"
            case notAfterDate = "Not After Date"
            case description = "Description"
            case naturalLanguageDate = "Natural Language Date"
            case event = "Event"
            case dateType = "Date Type"
            case entryID = "Entry ID"
            case status = "Status"
            case provenance = "Provenance"
            case id = "ID"
            case sortDate = "Sort Date"
            case xmlElement = "XML Element"
            case didNotes = "DID Notes"
            case didPersonXR = "DID Person Cross-References"
            case didCountryXR = "DID Country Cross-References"
            case hsgXR = "HSG Cross-References"
            case lastSnapshotAttempt = "Last Snapshot Attempt"
            case lastSnapshotSucceeded = "Last Snapshot Succeeded"
            case lastSynchronizationAttempt = "Last Synchronization Attempt"
            case lastSynchronizationSucceeded = "Last Synchronization Succeeded"
            case importedFormattedDescription = "Imported Formatted Description"
        }
        
        init(record: Record) {
            self.date = record.fields["Date"] as? String ?? nil
            self.startDate = record.fields["Start Date"] as? String ?? nil
            self.endDate = record.fields["End Date"] as? String ?? nil
            self.notBeforeDate = record.fields["Not Before Date"] as? String ?? nil
            self.notAfterDate = record.fields["Not After Date"] as? String ?? nil
            self.description = record.fields["Description"] as? String ?? nil
            self.naturalLanguageDate = record.fields["Natural Language Date"] as? String ?? nil
            self.event = record.fields["Event"] as? [String] ?? nil
            self.dateType = record.fields["Date Type"] as? String ?? nil
            self.entryID = record.fields["Entry ID"] as? Int ?? nil
            self.status = record.fields["Status"] as? [String] ?? nil
            self.provenance = record.fields["Provenance"] as? String ?? nil
            self.id = record.fields["ID"] as? String ?? nil
            self.sortDate = record.fields["Sort Date"] as? String ?? nil
            self.xmlElement = record.fields["XML Element"] as? String ?? nil
            self.didNotes = record.fields["DID Notes"] as? [String] ?? nil
            self.didPersonXR = record.fields["DID Person Cross-References"] as? [String] ?? nil
            self.didCountryXR = record.fields["DID Country Cross-References"] as? [String] ?? nil
            self.hsgXR = record.fields["HSG Cross-References"] as? String ?? nil
            self.lastSnapshotAttempt = record.fields["Last Snapshot Attempt"] as? String ?? nil
            self.lastSnapshotSucceeded = record.fields["Last Snapshot Succeeded"] as? Bool ?? nil
            self.lastSynchronizationAttempt = record.fields["Last Synchronization Attempt"] as? String ?? nil
            self.lastSynchronizationSucceeded = record.fields["Last Synchronization Succeeded"] as? Bool ?? nil
            self.importedFormattedDescription = record.fields["Imported Formatted Description"] as? String ?? nil
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdTime
        case fields
    }
    
    init(record: Record) {
        self.id = record.id!
        self.fields = DOATimelineEntry.Fields(record: record)
    }
    
    func convertToAirtableRecord() -> Record {
        var fields = [String: Any]()
//        if self.fields.date != nil {
//            fields["Date"] = self.fields.date!
//        }
//        if self.fields.startDate != nil {
//            fields["Start Date"] = self.fields.startDate!
//        }
//        if self.fields.endDate != nil {
//            fields["End Date"] = self.fields.endDate!
//        }
//        if self.fields.notBeforeDate != nil {
//            fields["Not Before Date"] = self.fields.notBeforeDate!
//        }
//        if self.fields.notAfterDate != nil {
//            fields["Not After Date"] = self.fields.notAfterDate!
//        }
        if self.fields.importedFormattedDescription != nil {
//            fields["Description"] = self.fields.importedFormattedDescription!
            fields["Imported Formatted Description"] = self.fields.importedFormattedDescription!
        }
//        } else if self.fields.description != nil {
//            fields["Description"] = self.fields.description!
//        }
//        if self.fields.naturalLanguageDate != nil {
//            fields["Natural Language Date"] = self.fields.naturalLanguageDate!
//        }
//        if self.fields.event != nil {
//            fields["Event"] = self.fields.event!
//        }
//        if self.fields.dateType != nil {
//            fields["Date Type"] = self.fields.dateType!
//        }
//        if self.fields.entryID != nil {
//            fields["Entry ID"] = self.fields.entryID!
//        }
//        if self.fields.status != nil {
//            fields["Status"] = self.fields.status!
//        }
//        if self.fields.provenance != nil {
//            fields["Provenance"] = self.fields.provenance!
//        }
//        if self.fields.id != nil {
//            fields["ID"] = self.fields.id!
//        }
//        if self.fields.sortDate != nil {
//            fields["Sort Date"] = self.fields.sortDate!
//        }
//        if self.fields.xmlElement != nil {
//            fields["XML Element"] = self.fields.xmlElement!
//        }
//        if self.fields.didNotes != nil {
//            fields["DID Notes"] = self.fields.didNotes!
//        }
//        if self.fields.didPersonXR != nil {
//            fields["DID Person Cross-References"] = self.fields.didPersonXR!
//        }
//        if self.fields.didCountryXR != nil {
//            fields["DID Country Cross-References"] = self.fields.didCountryXR!
//        }
//        if self.fields.hsgXR != nil {
//            fields["HSG Cross-References"] = self.fields.hsgXR!
//        }
//        if self.fields.lastSnapshotAttempt != nil {
//            fields["Last Snapshot Attempt"] = self.fields.lastSnapshotAttempt!
//        }
//        if self.fields.lastSnapshotSucceeded != nil {
//            fields["Last Snapshot Succeeded"] = self.fields.lastSnapshotSucceeded!
//        }
//        if self.fields.lastSynchronizationAttempt != nil {
//            fields["Last Synchronization Attempt"] = self.fields.lastSynchronizationAttempt!
//        }
//        if self.fields.lastSynchronizationSucceeded != nil {
//            fields["Last Synchronization Succeeded"] = self.fields.lastSynchronizationSucceeded!
//        }
        return Record(fields: fields, id: self.id)
    }
}

struct EntriesWrapper: Decodable {
    var entries: Entries
}

struct Entries: Codable {
    var entry: [Entry]
}

struct Entry: Codable {
    var xmlIndex: Int
    var nld: String
    var dateType: String
    var date: String?
    var text: Text
    var people, startDate, endDate, links: String?
    var estimatedStartDate, estimatedEndDate, countries: String?
}

struct Text: Codable {
    var xmlSpace: XMLSpace
    var text: String

    enum CodingKeys: String, CodingKey {
        case xmlSpace = "xml:space"
        case text = "#text"
    }
}

enum XMLSpace: String, Codable {
    case preserve = "preserve"
}
