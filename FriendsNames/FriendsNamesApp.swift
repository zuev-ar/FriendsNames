//
//  FriendsNamesApp.swift
//  FriendsNames
//
//  Created by Arkasha Zuev on 03.08.2021.
//

import SwiftUI

@main
struct FriendsNamesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
