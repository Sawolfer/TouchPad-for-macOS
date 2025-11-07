//
//  MainScreenView.swift
//  tap&sendForMac
//
//  Created by Савва Пономарев on 06.09.2025.
//

import SwiftUI
#if os(macOS)
struct MainScreenView: View {
    @ObservedObject var viewModel: MultipeerViewModelMACOS

    var body: some View {
        VStack {
            connectionLabel
            pairingCode
            if viewModel.isConnected {
                disconnectButton
            }
            quitButotn
        }
    }

    var pairingCode: some View {
        VStack {
            Text("Your Pairing Code:")
                .font(.headline)
            Button {

            } label: {
                Text(viewModel.pairingCode)
                    .font(.system(size: 24, weight: .bold, design: .monospaced))
                    .foregroundColor(.yellow)
                    .padding()
                    .cornerRadius(8)
            }
            .buttonStyle(.plain)
        }
        .padding()
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
#endif
