////
////  test.swift
////  TouchpadDemo
////
////  Created by Савва Пономарев on 09.02.2024.
////
//
//import Cocoa
//import MultipeerConnectivity
//
//class ViewController: NSViewController, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate {
//    var session: MCSession!
//    var advertiser: MCNearbyServiceAdvertiser!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Создание сессии
//        let peerID = MCPeerID(displayName: Host.current().localizedName ?? "")
//        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
//        session.delegate = self
//        
//        // Запуск рекламы
//        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "my-service")
//        advertiser.delegate = self
//        advertiser.startAdvertisingPeer()
//    }
//    
//    // Обработка полученных данных
//    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
//        if let command = String(data: data, encoding: .utf8) {
//            // Выполнение команды на Mac
//            executeCommand(command)
//        }
//    }
//    
//    // Выполнение команды на Mac
//    func executeCommand(_ command: String) {
//        let appleScript = NSAppleScript(source: command)
//        var error: NSDictionary?
//        appleScript?.executeAndReturnError(&error)
//        
//        if let error = error {
//            print("Ошибка при выполнении команды: \(error)")
//        }
//    }
//    
//    // Обработка запроса на подключение от iPhone
//    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
//        invitationHandler(true, session)
//    }
//    
//    // Обработка изменения состояния подключения
//    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
//        // Обработка изменения состояния подключения на Mac (если необходимо)
//    }
//    
//    // Обработка ошибки при подключении
//    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
//        print("Ошибка при запуске рекламы: \(error.localizedDescription)")
//    }
//}
