//
//  MedTrackerApp.swift
//  MedTracker
//
//  Created by Daniel Graham on 1/29/23.
//

import SwiftUI

@main
struct MedTrackerApp: App {
    @StateObject var persistenceController = PersistenceController()

    /*
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
     */
    var body: some Scene {
        WindowGroup {
            ContentView(viewContext: persistenceController.container.viewContext)
        }
    }
}
