//
//  iCursorApp.swift
//  iCursor
//
//  Created by Савва Пономарев on 05.11.2025.
//

import SwiftUI

@main
struct iCursorApp: App {
#if os(iOS)
    @StateObject var viewModelIOS = MainScreenViewModelIOS()
#else
    @StateObject var viewModelMACOS = MultipeerViewModelMACOS()
#endif

    var body: some Scene {
#if os(iOS)
        WindowGroup {
            MainScreenView(
                viewModel: viewModelIOS
            )
            .preferredColorScheme(.dark)
        }
#elseif os(macOS)
        WindowGroup {
            TestView(
                viewModel: viewModelMACOS
            )
        }
        MenuBarExtra {
            MainScreenView(
                viewModel: viewModelMACOS
            )
            .environment(\.colorScheme, .dark)
        } label: {
            Label("Curswor", systemImage: "cursorarrow.rays")
        }
#endif
    }
}
