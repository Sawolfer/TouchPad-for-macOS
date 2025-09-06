//
//  MainScreenView.swift
//  tap&sendForMac
//
//  Created by Савва Пономарев on 06.09.2025.
//

import SwiftUI

struct MainScreenView: View {
    @StateObject private var viewModel = MultipeerViewModel()

    var body: some View {
        VStack {
            connectionLabel
            if viewModel.isConnected {
                disconnectButton
            }
            quitButotn
        }
    }

    var connectionLabel: some View {
        Text(viewModel.status)
    }

    var disconnectButton: some View {
        Button {
            viewModel.disconnect()
        } label: {
            Text("Disconnect")
        }
    }

    var quitButotn: some View {
        Button {
            viewModel.disconnect()
            NSApplication.shared.terminate(self)
        } label: {
            Text("Quit")
        }
    }
}
