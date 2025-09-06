//
//  ConnectionSheetView.swift
//  tap&send
//
//  Created by Савва Пономарев on 03.09.2025.
//

import SwiftUI

struct ConnectionSheetView: View {
    @ObservedObject var viewModel: MainScreenViewModel

    var body: some View {
        VStack {
            Text("Choose your Device")
                .font(.title2)
                .fontWeight(.bold)
                .padding()
            Spacer()

            if viewModel.availablePeers.isEmpty {
                Text("No devices found")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(viewModel.availablePeers, id: \.displayName) { peer in
                    Button(action: {
                        viewModel.handlePeerSelection(peer)
                    }) {
                        HStack {
                            Image(systemName: "laptopcomputer")
                            Text(peer.displayName)
                            Spacer()
                            if viewModel.connectionState == .connecting && viewModel.availablePeers.first == peer {
                                ProgressView()
                            }
                        }
                    }
                }
            }
            Spacer()
        }
    }
}
