//
//  Configuration.swift
//  DOA Timeline Entry Formatting Sync
//
//  Created by Joshua Botts on 1/27/21.
//

import Foundation

struct DOA {
    static let baseURL = URL(string: "https://api.airtable.com/v0/*******BASE ID*******/********Table Name*********")!
    static let apiKey = "*********API Key***********"
}

struct LocalFiles {
    static let markdownJSON = URL(fileURLWithPath: "***************** File Path *******************")
    static let existingDOAJSON = URL(fileURLWithPath: "***************** File Path *******************")
}
