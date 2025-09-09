//
//  MainScreenView.swift
//  tap&sendForMac
//
//  Created by Савва Пономарев on 06.09.2025.
//

import SwiftUI

struct MainScreenView: View {
    @ObservedObject var viewModel: MultipeerViewModel

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
            Text(viewModel.pairingCode)
                .font(.system(size: 24, weight: .bold, design: .monospaced))
                .foregroundColor(.blue)
                .padding()
//                .background(
//                    RoundedRectangle(cornerRadius: 20)
//                        .fill(.gray)
//                )
                .cornerRadius(8)
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
