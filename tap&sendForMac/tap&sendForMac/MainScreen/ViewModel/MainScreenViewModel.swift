import SwiftUI
import MultipeerConnectivity
import CryptoKit

// MARK: - ViewModel
class MultipeerViewModel: NSObject, ObservableObject {
    @Published var status: String = "Not connected"
    @Published var isConnected: Bool = false
    @Published var isConnecting: Bool = false
    @Published var pairingCode: String = ""
    @Published var showPairingAlert: Bool = false
    @Published var foundPeerName: String = ""
    @Published var foundPeerCode: String = ""

    let mouse = MouseActions()

    // MARK: - Multipeer Properties
    private let serviceType = "mcursor"
    private var multipeerSession: MCSession?
    private let peerID = MCPeerID(displayName: Host.current().localizedName ?? "Unknown")
    private var browser: MCNearbyServiceBrowser?
    private var advertiser: MCNearbyServiceAdvertiser?

    override init() {
        super.init()
        generatePairingCode()
        setupSession()
        startAdvertiser()
    }

    // MARK: - Public Methods
    func connect() {
        stopBrowsingAdvertising()
        startBrowser()
    }

    func disconnect() {
        multipeerSession?.connectedPeers.forEach {
            multipeerSession?.cancelConnectPeer($0)
        }
        stopBrowsingAdvertising()
        generatePairingCode()
        startAdvertiser()
        updateStatus("Not connected")
    }

    func sendMessage() {
        send(message: "\(peerID.displayName)")
    }

    func confirmPairing() {
        showPairingAlert = false
    }

    func cancelPairing() {
        showPairingAlert = false
    }

    // MARK: - Private Methods
    private func generatePairingCode() {
        let code = String(Int.random(in: 100000...999999))
        pairingCode = code
    }

    private func setupSession() {
        multipeerSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
        multipeerSession?.delegate = self
    }

    private func startAdvertiser() {
        let discoveryInfo = ["pairingCode": pairingCode]
        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: discoveryInfo, serviceType: serviceType)
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
        multipeerSession?.disconnect()
    }

    private func send(message: String) {
        guard let connectedPeers = multipeerSession?.connectedPeers,
              let messageData = try? JSONEncoder().encode(message) else { return }
        do {
            try multipeerSession?.send(messageData, toPeers: connectedPeers, with: .reliable)
        } catch {
            print("Error sending message: \(error)")
        }
    }

    private func updateStatus(_ newStatus: String) {
        DispatchQueue.main.async {
            self.status = newStatus
            self.isConnected = newStatus == "Connected"
            self.isConnecting = newStatus == "Connecting"
        }
    }

    private func showPairingRequest(peerName: String, code: String) {
        DispatchQueue.main.async {
            self.foundPeerName = peerName
            self.foundPeerCode = code
            self.showPairingAlert = true
        }
    }
}

// MARK: - MCSessionDelegate
extension MultipeerViewModel: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
            case .connecting:
                updateStatus("Connecting")
            case .connected:
                updateStatus("Connected")
                DispatchQueue.main.async{
                    self.showPairingAlert = false
                }
            case .notConnected:
                updateStatus("Not connected")
            @unknown default:
                updateStatus("Unknown state")
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            guard let message = try? JSONDecoder().decode(String.self, from: data) else { return }
            self.mouse.SignalMan(type: message)
        }
    }

//    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
}

// MARK: - MCNearbyServiceAdvertiserDelegate
extension MultipeerViewModel: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, multipeerSession)
    }
}

// MARK: - MCNearbyServiceBrowserDelegate
extension MultipeerViewModel: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        guard let multipeerSession = multipeerSession else { return }

        if let peerCode = info?["pairingCode"] {
            showPairingRequest(peerName: peerID.displayName, code: peerCode)
            browser.invitePeer(peerID, to: multipeerSession, withContext: nil, timeout: 30.0)
        }
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        if self.foundPeerName == peerID.displayName {
            showPairingAlert = false
        }
    }
}

// MARK: - TestView
struct TestView: View {
    @ObservedObject var viewModel: MultipeerViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("MultiPeer Connection")
                .font(.title2)
                .padding(.top)
            VStack {
                Text("Your Pairing Code:")
                    .font(.headline)
                Text(viewModel.pairingCode)
                    .font(.system(size: 24, weight: .bold, design: .monospaced))
                    .foregroundColor(.blue)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
            .padding()

            Text("Status: \(viewModel.status)")
                .font(.headline)
                .foregroundColor(viewModel.isConnected ? .green : .red)
                .padding()

            HStack(spacing: 20) {
                Button("Discover Devices") {
                    viewModel.connect()
                }
                .disabled(viewModel.isConnecting || viewModel.isConnected)
                .buttonStyle(.borderedProminent)

                Button("Disconnect") {
                    viewModel.disconnect()
                }
                .disabled(!viewModel.isConnected)
                .buttonStyle(.bordered)
            }
            .padding()
        }
        .frame(width: 400, height: 300)
        .alert("Pairing Request", isPresented: $viewModel.showPairingAlert) {
            Button("Pair", role: .none) {
                viewModel.confirmPairing()
            }
            Button("Cancel", role: .cancel) {
                viewModel.cancelPairing()
            }
        } message: {
            Text("Pair with '\(viewModel.foundPeerName)'?\nTheir code: \(viewModel.foundPeerCode)\nYour code: \(viewModel.pairingCode)")
        }
    }
}

// MARK: - Stream Handling
extension MultipeerViewModel: StreamDelegate {
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("Received stream: \(streamName) from \(peerID.displayName)")

        if streamName == "CommandStream" {
            // Set up the input stream
            stream.delegate = self
            stream.schedule(in: .main, forMode: .default)
            stream.open()

            // Store the stream
//            inputStreams[peerID] = stream
        }
    }

    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        guard let inputStream = aStream as? InputStream else { return }

        switch eventCode {
        case .openCompleted:
            print("Input stream opened")

        case .hasBytesAvailable:
            print("Bytes available in stream")
            readFromStream(inputStream)

        case .errorOccurred:
            print("Stream error occurred")

        case .endEncountered:
            print("Stream ended")
            inputStream.close()
            inputStream.remove(from: .main, forMode: .default)

        default:
            break
        }
    }

    private func readFromStream(_ inputStream: InputStream) {
        let bufferSize = 1024
        var buffer = [UInt8](repeating: 0, count: bufferSize)

        while inputStream.hasBytesAvailable {
            let bytesRead = inputStream.read(&buffer, maxLength: bufferSize)

            if bytesRead > 0 {
                if let message = String(bytes: buffer, encoding: .utf8)?.trimmingCharacters(in: .controlCharacters) {
                    print("Received via stream: \(message)")
                    DispatchQueue.main.async {
                        self.mouse.SignalMan(type: message)
                    }
                }
            } else if bytesRead == 0 {
                print("End of stream reached")
            } else {
                print("Stream read error")
            }
        }
    }
}
