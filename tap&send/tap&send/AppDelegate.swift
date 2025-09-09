//
//  AppDelegate.swift
//  tap&send
//
//  Created by BrainPumpkin on 27.03.2024.
//

import SwiftUI

@main
struct TouchpadApp: App {
    @StateObject var viewModel = MainScreenViewModel()
    var body: some Scene {
        WindowGroup {
            MainScreenView(
                viewModel: viewModel
            )
            .preferredColorScheme(.dark)
        }
    }
}
