//
//  TouchpadForMacAlsoApp.swift
//  TouchpadForMacAlso
//
//  Created by Савва Пономарев on 09.02.2024.
//

import SwiftUI

@main
struct TouchpadForMacAlsoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
