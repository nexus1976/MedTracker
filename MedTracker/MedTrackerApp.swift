//
//  MedTrackerApp.swift
//  MedTracker
//
//  Created by Daniel Graham on 1/29/23.
//

import SwiftUI

@main
struct MedTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
