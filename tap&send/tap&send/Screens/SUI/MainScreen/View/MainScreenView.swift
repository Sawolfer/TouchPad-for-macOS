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

    @State var forTest = false

    var body: some View {
        NavigationStack {
            VStack {
                welcomeLabel
                Spacer()
                VStack {
                    connectionStack
//                    settingsButton
                    aboutAppButton
                }
                .frame(width: 300)
                Spacer()

#if DEBUG
                Toggle("For Test", isOn: $forTest)
                    .frame(width: 150)
                    .padding()
                    .foregroundStyle(.yellow)
                    .glass(cornerRadius: 20)
#endif
//            pairingCode
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
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .trailing).combined(with: .opacity)
                    ))
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewModel.connectedDevice)
    }

    var startButton: some View {
        NavigationLink {
            TouchpadScreenBuilder.build(viewModel: viewModel)
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
#if DEBUG
            if forTest{
                viewModel.connectedDevice.toggle()
            } else {
                withAnimation() {
                    viewModel.toggleConnection()
                }
            }
#else
            withAnimation() {
                viewModel.toggleConnection()
            }
#endif
        } label: {
            HStack {
                Image(systemName: viewModel.connectedDevice ? "laptopcomputer.slash" : "laptopcomputer")
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

    var aboutAppButton: some View {
        Button {
            print("About App")
        } label: {
            HStack {
                Image(systemName: "exclamationmark.circle.fill")
                Text("About App")
            }
            .frame(maxWidth: .infinity)
            .foregroundStyle(.yellow)
            .padding()
            .glass(cornerRadius: 20)
        }
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

    @ViewBuilder
    var pairingCode: some View {
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
