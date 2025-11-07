//
//  MainScreenViewModel.swift
//  tap&send
//
//  Created by Савва Пономарев on 03.09.2025.
//

#if os(iOS)
import SwiftUI
import MultipeerConnectivity
import Combine

// MARK: - ViewModel
protocol TouchpadViewModelDelegate: AnyObject {
    func connectionStateChanged(_ state: MCSessionState)
    func receivedMessage(_ message: String)
}

final class MainScreenViewModelIOS: NSObject, ObservableObject {
    // MARK: - Published Properties
    @Published var connectedDevice = false
    @Published var connectionState: ConnectionState = .notConnected
    @Published var availablePeers: [PeerDevice] = []
    @Published var showConnectionSheet = false
    @Published var showPairingAlert = false
    @Published var currentPairingCode = ""
    @Published var selectedPeer: PeerDevice?
    @Published var pairingStatus: String = ""

    // MARK: - Multipeer Connectivity Properties
    private let serviceType = "mcursor"
    private var peerID: MCPeerID
    private var session: MCSession?
    private var browser: MCNearbyServiceBrowser?
    private var advertiser: MCNearbyServiceAdvertiser?

    weak var delegate: TouchpadViewModelDelegate?

    // MARK: - Initialization
    override init() {
        self.peerID = MCPeerID(displayName: UIDevice.current.name)
        super.init()
        generatePairingCode()
        setupSession()
        startServices()
    }

    // MARK: - Pairing Code Management
    private func generatePairingCode() {
        currentPairingCode = String(Int.random(in: 100000...999999))
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
        let discoveryInfo = ["pairingCode": currentPairingCode]
        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: discoveryInfo, serviceType: serviceType)
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
        generatePairingCode()
    }

    private func stopServices() {
        browser?.stopBrowsingForPeers()
        advertiser?.stopAdvertisingPeer()
        session?.disconnect()
    }

    // MARK: - Peer Management
    func invitePeer(_ peer: PeerDevice) {
        guard let session = session else { return }

        selectedPeer = peer
        showPairingAlert = true
        pairingStatus = "Enter the pairing code for \(peer.peerID.displayName)"
    }

    func confirmPairing(with code: String) {
        guard let peer = selectedPeer, let session = session else { return }

        if code == peer.pairingCode {
            browser?.invitePeer(peer.peerID, to: session, withContext: nil, timeout: 30)
            connectionState = .connecting
            pairingStatus = "Connecting..."
        } else {
            pairingStatus = "Incorrect pairing code. Please try again."
        }
    }

    func cancelPairing() {
        selectedPeer = nil
        showPairingAlert = false
        pairingStatus = ""
    }

    // MARK: - Message Handling
    func send(message: String) {
        guard let session = session,
              !session.connectedPeers.isEmpty,
              let messageData = try? JSONEncoder().encode(message) else {
            return
        }

        do {
            try session.send(messageData, toPeers: session.connectedPeers, with: .unreliable)
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

    func handlePeerSelection(_ peer: PeerDevice) {
        invitePeer(peer)
    }
}

// MARK: - Data Models
struct PeerDevice: Identifiable, Equatable {
    let id = UUID()
    let peerID: MCPeerID
    let pairingCode: String

    static func == (lhs: PeerDevice, rhs: PeerDevice) -> Bool {
        lhs.peerID == rhs.peerID
    }
}

// MARK: - MCSessionDelegate
extension MainScreenViewModelIOS: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async {
            switch state {
            case .connected:
                self.connectedDevice = true
                self.connectionState = .connected
                self.showPairingAlert = false
                self.pairingStatus = ""
            case .connecting:
                self.connectionState = .connecting
            case .notConnected:
                self.connectedDevice = false
                self.connectionState = .notConnected
                self.generatePairingCode()
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
extension MainScreenViewModelIOS: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        // Always accept invitations (pairing code verification happens on browser side)
        invitationHandler(true, session)
    }
}

// MARK: - MCNearbyServiceBrowserDelegate
extension MainScreenViewModelIOS: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        DispatchQueue.main.async {
            // Extract pairing code from discovery info
            let pairingCode = info?["pairingCode"] ?? "Unknown"
            let peerDevice = PeerDevice(peerID: peerID, pairingCode: pairingCode)

            if !self.availablePeers.contains(where: { $0.peerID == peerID }) {
                self.availablePeers.append(peerDevice)
            }
        }
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            self.availablePeers.removeAll { $0.peerID == peerID }
            // If the lost peer was the selected one, cancel pairing
            if self.selectedPeer?.peerID == peerID {
                self.cancelPairing()
            }
        }
    }
}

// MARK: - Stream
extension MainScreenViewModelIOS {
    func sendViaStream(message: String) {
        guard let session = session, let connectedPeer = session.connectedPeers.first else { return }

        do {
            let outputStream = try session.startStream(withName: "CommandStream", toPeer: connectedPeer)
            outputStream.delegate = self
            outputStream.schedule(in: .main, forMode: .default)
            outputStream.open()

//            outputStreams[connectedPeer] = outputStream

            sendMessageViaStream(message, outputStream: outputStream)

        } catch {
            print("Error creating stream: \(error)")
        }
    }

    private func sendMessageViaStream(_ message: String, outputStream: OutputStream) {
        guard outputStream.hasSpaceAvailable else {
            print("No space available in stream")
            return
        }

        // Convert string to data
        guard let data = message.data(using: .utf8) else { return }

        // Write data to stream
        let bytesWritten = data.withUnsafeBytes { buffer in
            outputStream.write(buffer.bindMemory(to: UInt8.self).baseAddress!, maxLength: data.count)
        }

        if bytesWritten > 0 {
            print("Sent \(bytesWritten) bytes via stream")
        } else {
            print("Failed to write to stream")
        }
    }
}

extension MainScreenViewModelIOS: StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
            case .openCompleted:
                print("Stream opened successfully")
            case .hasSpaceAvailable:
                print("Stream has space available")
            case .errorOccurred:
                print("Stream error occurred")
            case .endEncountered:
                print("Stream ended")
                aStream.close()
                aStream.remove(from: .main, forMode: .default)
            default:
                break
        }
    }
}
#endif
