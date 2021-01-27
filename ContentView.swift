//
//  ContentView.swift
//  DOA Timeline Entry Formatting Sync
//
//  Created by Joshua Botts on 1/23/21.
//

import SwiftUI

struct ContentView: View {
    let utility = DOATimelineEntryUpdater()
    
    var body: some View {
        Button("Load formatted entries from local file", action: {
            utility.loadLocalJSON()
        })
        Button("Load existing DOA entries", action: {
            utility.getDOABaseline()
        })
        Button("Sync locally", action: {
            utility.updateLocalDOA()
        })
        Button("Sync with Airtable", action: {
            utility.syncDOAtoAirtable()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
