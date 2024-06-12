import MultipeerConnectivity
import Cocoa

class ViewController: NSViewController {
    

    @IBOutlet var statusLabel: NSTextField!
    @IBOutlet var connectButton: NSButton!
    @IBOutlet var disconnectButton: NSButton!
    @IBOutlet var sendButton: NSButton!
    
    let mouse : MouseActions = MouseActions()
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        multipeersession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
        multipeersession?.delegate = self
        startBrowser()
        
    }
    
    // MARK: - Actions
    
    @IBAction func didTapConnectButton(_ sender: Any) {
        stopBrowsingAdvertising()
        startAdvertiser()
    }
    @IBAction func didTapDisconnectButton(_ sender: Any) {
        multipeersession?.connectedPeers.forEach({
            multipeersession?.cancelConnectPeer($0)
        })
        stopBrowsingAdvertising()
        startBrowser()
    }
    
    @IBAction func didTapSendButton(_ sender: Any) {
        send(message: "леее здарова я \(peerID.displayName)")
    }
    
    // MARK: - Private constants
    
    private let serviceType = "mctest"
    
    // MARK: - Private
    
    private var multipeersession: MCSession?
    private var peerID = MCPeerID(displayName: Host.current().localizedName ?? "Unknown")
    private var browser: MCNearbyServiceBrowser?
    private var advertiser: MCNearbyServiceAdvertiser?
    
    // MARK: - Private Methods
    
    private func startAdvertiser() {
        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
        advertiser?.delegate = self
        advertiser?.startAdvertisingPeer()
    }
    
    private func startBrowser() {
        browser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        browser?.delegate = self
        browser?.startBrowsingForPeers()
    }
    
    private func stopBrowsingAdvertising() {
        browser?.stopBrowsingForPeers()
        advertiser?.stopAdvertisingPeer()
        multipeersession?.disconnect()
    }
    
    private func send(message: String) {
        guard let connectedPeers = multipeersession?.connectedPeers,
              let messageData = try? JSONEncoder().encode(message) else { return }
        do {
            try multipeersession?.send(messageData, toPeers: connectedPeers, with: .reliable)
        } catch {}
    }
}

// MARK: - MCSessionDelegate
extension ViewController: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async {
            switch state {
            case .connecting:
                self.statusLabel.stringValue = "Connecting"
            case .connected:
                self.statusLabel.stringValue = "Connected"
            case .notConnected:
                self.statusLabel.stringValue = "Not connected"
            @unknown default:
                self.statusLabel.stringValue = "Unknown state"
            }
            
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            guard let message = try? JSONDecoder().decode(String.self, from: data) else { return }
            let mouseAction = MouseActions()
            mouseAction.SignalMan(type: message)
        }
        
    }
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID){
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
    
    // Other delegate methods remain the same
}

// MARK: - MCNearbyServiceAdvertiserDelegate
extension ViewController: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, multipeersession)
    }
    
    // Delegate methods remain the same
}

// MARK: - MCNearbyServiceBrowserDelegate
extension ViewController: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        guard let multipeersession = multipeersession else { return }
        browser.invitePeer(peerID, to: multipeersession, withContext: nil, timeout: 10.0)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
    }
    
    // Delegate methods remain the same
}
