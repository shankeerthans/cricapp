//
//  CricappApp.swift
//  Cricapp
//
//  Created by Shankeerthan on 2024-11-08.
//

import SwiftUI

@main
struct CricappApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
