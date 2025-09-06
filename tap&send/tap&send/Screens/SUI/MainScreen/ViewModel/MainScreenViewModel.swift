//
//  MainScreenViewModel.swift
//  tap&send
//
//  Created by Савва Пономарев on 03.09.2025.
//

import SwiftUI
import MultipeerConnectivity

// MARK: - ViewModel
protocol TouchpadViewModelDelegate: AnyObject {
    func connectionStateChanged(_ state: MCSessionState)
    func receivedMessage(_ message: String)
}

final class MainScreenViewModel: NSObject, ObservableObject {
    // MARK: - Published Properties
    @Published var connectedDevice = false
    @Published var connectionState: ConnectionState = .notConnected
    @Published var availablePeers: [MCPeerID] = []
    @Published var showConnectionSheet = false

    // MARK: - Multipeer Connectivity Properties
    private let serviceType = "mctest"
    private var peerID: MCPeerID
    private var session: MCSession?
    private var browser: MCNearbyServiceBrowser?
    private var advertiser: MCNearbyServiceAdvertiser?

    weak var delegate: TouchpadViewModelDelegate?

    // MARK: - Initialization
    override init() {
        self.peerID = MCPeerID(displayName: UIDevice.current.name)
        super.init()
        setupSession()
        startServices()
    }

    // MARK: - Session Management
    private func setupSession() {
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
        session?.delegate = self
    }

    func startServices() {
        startBrowsing()
        startAdvertising()
    }

    private func startBrowsing() {
        browser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        browser?.delegate = self
        browser?.startBrowsingForPeers()
    }

    private func startAdvertising() {
        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
        advertiser?.delegate = self
        advertiser?.startAdvertisingPeer()
    }

    func disconnect() {
        session?.connectedPeers.forEach {
            session?.cancelConnectPeer($0)
        }
        stopServices()
        connectedDevice = false
        connectionState = .notConnected
    }

    private func stopServices() {
        browser?.stopBrowsingForPeers()
        advertiser?.stopAdvertisingPeer()
        session?.disconnect()
    }

    // MARK: - Peer Management
    func invitePeer(_ peer: MCPeerID) {
        guard let session = session else { return }
        browser?.invitePeer(peer, to: session, withContext: nil, timeout: 10)
        connectionState = .connecting
    }

    // MARK: - Message Handling
    func send(message: String) {
        guard let session = session,
              !session.connectedPeers.isEmpty,
              let messageData = try? JSONEncoder().encode(message) else {
            return
        }

        do {
            try session.send(messageData, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            print("Error sending message: \(error)")
        }
    }

    // MARK: - UI Actions
    func toggleConnection() {
        if connectedDevice {
            disconnect()
        } else {
            showConnectionSheet = true
        }
    }

    func handlePeerSelection(_ peer: MCPeerID) {
        invitePeer(peer)
        showConnectionSheet = false
    }
}

// MARK: - MCSessionDelegate
extension MainScreenViewModel: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async {
            switch state {
            case .connected:
                self.connectedDevice = true
                self.connectionState = .connected
            case .connecting:
                self.connectionState = .connecting
            case .notConnected:
                self.connectedDevice = false
                self.connectionState = .notConnected
            @unknown default:
                break
            }
            self.delegate?.connectionStateChanged(state)
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let message = try? JSONDecoder().decode(String.self, from: data) {
            DispatchQueue.main.async {
                self.delegate?.receivedMessage(message)
            }
        }
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
}

// MARK: - MCNearbyServiceAdvertiserDelegate
extension MainScreenViewModel: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }
}

// MARK: - MCNearbyServiceBrowserDelegate
extension MainScreenViewModel: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        DispatchQueue.main.async {
            if !self.availablePeers.contains(peerID) {
                self.availablePeers.append(peerID)
            }
        }
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            if let index = self.availablePeers.firstIndex(of: peerID) {
                self.availablePeers.remove(at: index)
            }
        }
    }
}
