//
//  MainScreenView.swift
//  tap&sendTests
//
//  Created by Савва Пономарев on 03.09.2025.
//

import SwiftUI

struct MainScreenView: View {
    @State var connectedDevice = true
    @State var showConnectionSheet = false

    @StateObject private var viewModel = MainScreenViewModel()

    var body: some View {
        VStack {
            welcomeLabel
            Spacer()
            connectButton
            settingsButton
            Spacer()
        }
        .dotsBackground()
        .sheet(isPresented: $viewModel.showConnectionSheet) {
            ConnectionSheetView(viewModel: viewModel)
                .presentationDetents([.medium])
        }
    }

    var welcomeLabel: some View {
        Text("Welcome to Cursor app")
            .foregroundStyle(.white)
            .font(.system(size: 60))
            .fontWeight(.black)
            .multilineTextAlignment(.center)
    }

    var connectButton: some View {
        Button {
            viewModel.toggleConnection()
        } label: {
            HStack {
                Image(systemName: viewModel.connectedDevice ? "laptopcomputer.slash" : "laptopcomputer")
                Text(viewModel.connectedDevice ? "Disconnect" : "Connect")
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
            .foregroundStyle(.yellow)
            .padding()
            .glass(cornerRadius: 20)
        }
    }
}

// MARK: - Preview Provider
struct MainScreenPreview: PreviewProvider {
    static var previews: some View {
        MainScreenView()
    }
}
