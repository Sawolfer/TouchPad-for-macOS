//
//  ViewController.swift
//  tap&send
//
//  Created by Савва Пономарев on 27.03.2024.
//  source : https://www.youtube.com/watch?v=YWRMQg6XUsI

import MultipeerConnectivity
import UIKit

class Touchpad: UIViewController{

    @IBOutlet var statusLabel : UILabel!
    @IBOutlet var connectButton: UIButton!
    @IBOutlet var disconnectButton: UIButton!
    
    @IBOutlet weak var Recogniser: UILabel!
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
//        super.viewDidLoad()
        multipeersession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
        multipeersession?.delegate = self
        startBrowser()
        
        let oneTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.oneFingerTap(_:)))
        oneTapGestureRecognizer.numberOfTapsRequired = 1
        oneTapGestureRecognizer.numberOfTouchesRequired = 1
        view.addGestureRecognizer(oneTapGestureRecognizer)
        
        let twoTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.twoFingersTap(_:)))
        twoTapGestureRecognizer.numberOfTouchesRequired = 2
        view.addGestureRecognizer(twoTapGestureRecognizer)
    }
    
    // MARK: - TouchRecogniser
    
    @objc func oneFingerTap(_ sender: UITapGestureRecognizer){
        Recogniser.text = "One finger"
        send(message: "left_mouse_click")
    }
    @objc func twoFingersTap(_ sender: UITapGestureRecognizer){
        Recogniser.text = "Two fingers"
        send(message: "right_mouse_click")
    }
    
    @IBAction func LongTouchFinger(_ sender: UILongPressGestureRecognizer) {
        Recogniser.text = "Long Touch"
        send(message: "long_touchpad_touch")
    }
    @IBAction func PinchFingers(_ sender: UIPinchGestureRecognizer) {
//        Recogniser.text = "Pinch"
//        send(message: "pinch")
    }
    
    @IBAction func onePanRecognizer(_ sender: UIPanGestureRecognizer) {
        if sender.numberOfTouches == 3 {
            let translation = sender.translation(in: view)
            let angle = atan2(translation.y, translation.x)
            print("swipe")
            if angle > -0.5 && angle <= 0.5 {
                Recogniser.text = "three-finger swipe right"
                send(message: "three_fingers_swipe_right")
            } else if angle > -2 && angle <= -1 {
                Recogniser.text = "three-finger swipe up"
                send(message: "three_fingers_up")
            } else if abs(angle) >= 3 {
                Recogniser.text = "three-finger swipe left"
                send(message: "three_fingers_swipe_left")
            }
            
        } else if sender.numberOfTouches == 2 {
            let translation = sender.translation(in: view)
            let angle = atan2(translation.y, translation.x)
            
            if angle > -0.5 && angle <= 0.5 {
//                Recogniser.text = "Two-finger swipe right"
//                send(message: "two_fingers_right")
            } else if angle > -2 && angle <= -1 {
                Recogniser.text = "Two-finger swipe up"
                send(message: "two_fingers_up")
            } else if abs(angle) >= 3{
//                Recogniser.text = "Two-finger swipe left"
//                send(message: "two_fingers_left")
            } else if angle > 1 && angle <= 2 {
                Recogniser.text = "Two-finger swipe down"
                send(message: "two_fingers_down")
            }
        } else if sender.numberOfTouches == 1 {
            let velocity = sender.velocity(in: view)
    
            let msg = String(format: "%.5f", velocity.x) + " " + String(format: "%.5f", velocity.y)
//            print(msg)
            send(message: msg)
        }
        
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
    

    // MARK: - Private constants
    
    private let serviceType = "mctest"
    
    // MARK: - Private
    
    private var multipeersession : MCSession?
    private var peerID = MCPeerID(displayName: UIDevice.current.name)
    private var browser : MCNearbyServiceBrowser?
    private var advertiser : MCNearbyServiceAdvertiser?
    
    
}

private extension Touchpad{
    
    func startAdvertiser(){
        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
        advertiser?.delegate = self
        advertiser?.startAdvertisingPeer()
    }
    
    func startBrowser(){
        browser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        browser?.delegate = self
        browser?.startBrowsingForPeers()
    }
    
    func stopBrowsingAdvertising(){
        if let browser = browser {
            browser.stopBrowsingForPeers()
        }
        if let advertiser = advertiser {
            advertiser.stopAdvertisingPeer()
        }
        multipeersession?.disconnect()
    }
    
    func send(message: String) {
        guard let connectedPeers = multipeersession?.connectedPeers,
              let messageData = try? JSONEncoder().encode(message) else {return}
        do {
            try multipeersession?.send(messageData, toPeers: connectedPeers, with: .reliable)
        } catch{}
    }
}

// MARK: - MCSessionDelegate
extension Touchpad : MCSessionDelegate{
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
            
        case .connecting :
            DispatchQueue.main.async{
                self.statusLabel.text = "Connecing"
            }
        case .connected :
                    DispatchQueue.main.async{
                    self.statusLabel.text = "Connected"
                }
        case .notConnected :
            DispatchQueue.main.async{
                self.statusLabel.text = "Not connected"
            }
        @unknown default :
            DispatchQueue.main.async{
                self.statusLabel.text = "Rofls"
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            guard let message = try? JSONDecoder().decode(String.self, from: data) else {return}
            let alert  = UIAlertController(title: message, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Oki", style: .cancel))
            self.present(alert, animated: true)
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID){
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
}

// MARK: - MCNearbyServiceAdvertiserDelegate
extension Touchpad : MCNearbyServiceAdvertiserDelegate{
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, multipeersession)
    }
}

// MARK: - MCNearbyServiceBrowserDelegate
extension Touchpad: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        guard let multipeersession = multipeersession else { return }
        browser.invitePeer(peerID, to: multipeersession, withContext: nil, timeout: 10.0)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
    }
    
    
}
