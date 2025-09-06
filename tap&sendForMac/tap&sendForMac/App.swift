//
//  AppDelegate.swift
//  tap&sendForMac
//
//  Created by BrainPumpkin on 29.03.2024.
//

import Cocoa
import AppKit
import SwiftUI

//@main
//class AppDelegate: NSObject, NSApplicationDelegate {
//    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        // Insert code here to initialize your application
//    }
//
//    func applicationWillTerminate(_ aNotification: Notification) {
//        // Insert code here to tear down your application
//    }
//
//    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
//        return true
//    }
//}


@main
struct SimpleBrowserApp: App {
    @StateObject private var viewModel = MultipeerViewModel()
    var body: some Scene {
//        WindowGroup {
//            MainScreenView()
//        }
        MenuBarExtra {
            MainScreenView()
        } label: {
            Label("Cursor", systemImage: "cursorarrow.rays")
        }
    }
}
