//
//  TeamxApp.swift
//  Teamx
//
//  Created by Gurbir Bains on 2023-11-08.
//

import SwiftUI

@main
struct TeamxApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
