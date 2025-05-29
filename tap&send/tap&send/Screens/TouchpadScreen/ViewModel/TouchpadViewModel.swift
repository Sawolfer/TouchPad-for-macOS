//
//  TouchpadViewModel.swift
//  tap&send
//
//  Created by Савва Пономарев on 29.05.2025.
//

import MultipeerConnectivity
import UIKit

protocol TouchpadViewModelDelegate: AnyObject {
    func connectionStateChanged(_ state: MCSessionState)
    func receivedMessage(_ message: String)
}

final class TouchpadViewModel: NSObject {
    // MARK: - Properties
    private let serviceType = "mctest"
    private var peerID: MCPeerID
    private var session: MCSession?
    private var browser: MCNearbyServiceBrowser?
    private var advertiser: MCNearbyServiceAdvertiser?
    
    // Store discovered peers
    private var _availablePeers: [MCPeerID] = []
    
    // Public property to access available peers
    var availablePeers: [MCPeerID] {
        return _availablePeers
    }

    weak var delegate: TouchpadViewModelDelegate?

    // MARK: - Initialization
    override init() {
        self.peerID = MCPeerID(displayName: UIDevice.current.name)
        super.init()
        setupSession()
    }

    // MARK: - Session Management
    private func setupSession() {
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
        session?.delegate = self
    }

    func startBrowsing() {
        stopServices()
        _availablePeers.removeAll()
        browser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        browser?.delegate = self
        browser?.startBrowsingForPeers()
    }

    func startAdvertising() {
        stopServices()
        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
        advertiser?.delegate = self
        advertiser?.startAdvertisingPeer()
    }

    func disconnect() {
        session?.connectedPeers.forEach {
            session?.cancelConnectPeer($0)
        }
        stopServices()
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

    // MARK: - Gesture Handlers
    func handleOneFingerTap() {
        send(message: "left_mouse_click")
        Vibration.medium.vibrate()
    }

    func handleTwoFingerTap() {
        send(message: "right_mouse_click")
        Vibration.medium.vibrate()
    }

    func handleLongPress() {
        send(message: "long_touchpad_touch")
        Vibration.heavy.vibrate()
    }

    func handleOneFingerPan(velocity: CGPoint) {
        let msg = String(format: "%.5f", velocity.x) + " " + String(format: "%.5f", velocity.y)
        send(message: msg)
    }

    func handleTwoFingerPan(velocity: CGPoint) {
        let msg = "two_fingers " + String(format: "%.5f", velocity.x) + " " + String(format: "%.5f", velocity.y)
        send(message: msg)
    }

    func handleThreeFingerPan(translation: CGPoint) {
        let angle = atan2(translation.y, translation.x)

        if angle > -0.5 && angle <= 0.5 {
            send(message: "three_fingers_swipe_right")
        } else if angle > -2 && angle <= -1 {
            send(message: "three_fingers_swipe_up")
        } else if abs(angle) >= 2.5 {
            send(message: "three_fingers_swipe_left")
        }

        usleep(500)
    }
}

// MARK: - MCSessionDelegate
extension TouchpadViewModel: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        delegate?.connectionStateChanged(state)
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let message = try? JSONDecoder().decode(String.self, from: data) {
            delegate?.receivedMessage(message)
        }
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
}

// MARK: - MCNearbyServiceAdvertiserDelegate
extension TouchpadViewModel: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }
}

// MARK: - MCNearbyServiceBrowserDelegate
extension TouchpadViewModel: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        if !_availablePeers.contains(peerID) {
            _availablePeers.append(peerID)
        }
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        if let index = _availablePeers.firstIndex(of: peerID) {
            _availablePeers.remove(at: index)
        }
    }
}
