//
//  ConnectionSheetView.swift
//  tap&send
//
//  Created by Савва Пономарев on 03.09.2025.
//

#if os(iOS)
import SwiftUI
import MultipeerConnectivity

struct ConnectionSheetView: View {
    @ObservedObject var viewModel: MainScreenViewModelIOS

    var body: some View {
        VStack {
            Text("Available Devices")
                .font(.title2)
                .fontWeight(.bold)
                .padding()

//            Text("Your code: \(viewModel.currentPairingCode)")
//                .font(.subheadline)
//                .foregroundColor(.gray)
//                .padding(.bottom)

            Spacer()

            if viewModel.availablePeers.isEmpty {
                Text("Searching for devices...")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(viewModel.availablePeers) { peer in
                    Button(action: {
                        viewModel.handlePeerSelection(peer)
                    }) {
                        HStack {
                            Image(systemName: "laptopcomputer")
                            VStack(alignment: .leading) {
                                Text(peer.peerID.displayName)
//                                Text("Code: \(peer.pairingCode)")
//                                    .font(.caption)
//                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            if viewModel.connectionState == .connecting && viewModel.selectedPeer?.peerID == peer.peerID {
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
#endif
