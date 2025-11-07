//
//  AppDelegate.swift
//  tap&sendForMac
//
//  Created by BrainPumpkin on 29.03.2024.
//

import Cocoa
import AppKit
import SwiftUI

@main
struct SimpleBrowserApp: App {
    @StateObject private var viewModel = MultipeerViewModel()
    var body: some Scene {
//        WindowGroup {
//            TestView(
//                viewModel: viewModel
//            )
//        }
        MenuBarExtra {
            MainScreenView(
                viewModel: viewModel
            )
            .environment(\.colorScheme, .dark)
        } label: {
            Label("Cursor", systemImage: "cursorarrow.rays")
        }
    }
}
