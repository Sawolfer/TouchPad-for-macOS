//
//  MainScreenView.swift
//  tap&sendTests
//
//  Created by Савва Пономарев on 03.09.2025.
//

import SwiftUI

// MARK: - Views
struct MainScreenView: View {
    @ObservedObject var viewModel: MainScreenViewModel
    @State private var pairingCodeInput = ""

    var body: some View {
        VStack {
            welcomeLabel
            Spacer()
            VStack {
                connectionStack
                settingsButton
            }
            .frame(width: 300)
            Spacer()

            if !viewModel.connectedDevice {
                VStack {
                    Text("Your Pairing Code:")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(viewModel.currentPairingCode)
                        .font(.system(size: 24, weight: .bold, design: .monospaced))
                        .foregroundColor(.yellow)
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(8)
                }
                .padding()
            }
        }
        .dotsBackground()
        .sheet(isPresented: $viewModel.showConnectionSheet) {
            ConnectionSheetView(viewModel: viewModel)
                .presentationDetents([.medium])
        }
        .alert("Pairing Required", isPresented: $viewModel.showPairingAlert) {
            TextField("Enter pairing code", text: $pairingCodeInput)
                .keyboardType(.numberPad)

            Button("Pair") {
                viewModel.confirmPairing(with: pairingCodeInput)
                pairingCodeInput = ""
            }

            Button("Cancel", role: .cancel) {
                viewModel.cancelPairing()
                pairingCodeInput = ""
            }
        } message: {
            Text(viewModel.pairingStatus)
        }
    }

    var welcomeLabel: some View {
        Text("Welcome to Cursor app")
            .foregroundStyle(.white)
            .font(.system(size: 60))
            .fontWeight(.black)
            .multilineTextAlignment(.center)
    }

    var connectionStack: some View {
        HStack {
            connectButton
            if viewModel.connectedDevice {
                startButton
            }
        }
    }

    var startButton: some View {
        Button {
            print("bebe")
        } label: {
            Text("Start")
                .frame(maxWidth: .infinity)
                .foregroundStyle(.yellow)
                .padding()
                .glass(cornerRadius: 20)
        }
        .buttonStyle(.plain)
    }

    var connectButton: some View {
        Button {
            withAnimation(.smooth(duration: 0.3) ) {
                viewModel.toggleConnection()
            }
        } label: {
            HStack {
                Image(systemName: viewModel.connectedDevice ? "laptopcomputer.slash" : "laptopcomputer")
//                Text(!viewModel.connectedDevice ? "Connect" : "Disconnect")
                if !viewModel.connectedDevice {
                    Text("Connect")
                        .frame(maxWidth: .infinity)
                }
            }
            .foregroundStyle(.yellow)
            .padding()
            .glass(cornerRadius: 20)
        }
        .buttonStyle(.plain)
    }

    var settingsButton: some View {
        Button {
            print("Settings")
        } label: {
            HStack {
                Image(systemName: "gearshape.circle.fill")
                Text("Settings")
            }
            .frame(maxWidth: .infinity)
            .foregroundStyle(.yellow)
            .padding()
            .glass(cornerRadius: 20)
        }
    }
}

// MARK: - Preview Provider
struct MainScreenPreview: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @StateObject var viewModel = MainScreenViewModel()

        var body: some View {
            MainScreenView(
                viewModel: viewModel
            )
        }
    }
}
