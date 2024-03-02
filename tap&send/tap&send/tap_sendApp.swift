//
//  tap_sendApp.swift
//  tap&send
//
//  Created by Савва Пономарев on 01.03.2024.
//

import SwiftUI

@main
struct tap_sendApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
