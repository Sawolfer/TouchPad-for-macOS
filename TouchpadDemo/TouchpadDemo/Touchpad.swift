//
//  Touchpad.swift
//  TouchpadDemo
//
//  Created by Савва Пономарев on 05.02.2024.
//

import UIKit
import MultipeerConnectivity


class Touchpad: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate{
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        <#code#>
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        <#code#>
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        <#code#>
    }
    

    var session: MCSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let peerID = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var Recogniser: UILabel!
    
    @IBAction func TapOneFinger(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.view)
        
        Recogniser.text = "One finger at \(location)"
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           // Проверяем, есть ли подключенные пиры
           if session.connectedPeers.count > 0 {
               // Отправляем команду нажатия на левую кнопку мыши
               let command = "tell application \"System Events\" to click at {0, 0} as current application"
               sendCommand(command)
           }
       }
       
       // Отправка команды на Mac
       func sendCommand(_ command: String) {
           if let data = command.data(using: .utf8) {
               do {
                   try session.send(data, toPeers: session.connectedPeers, with: .reliable)
               } catch {
                   print("Ошибка при отправке команды: \(error.localizedDescription)")
               }
           }
       }
       
       // Обработка полученных данных
       func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
           // Обработка полученных данных на iPhone (если необходимо)
       }
       
       // Обработка изменения состояния подключения
       func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
           // Обработка изменения состояния подключения на iPhone (если необходимо)
       }
       
       // Показ браузера для подключения к Mac
       @IBAction func showBrowser(_ sender: UIButton) {
           let browser = MCBrowserViewController(serviceType: "my-service", session: session)
           browser.delegate = self
           present(browser, animated: true, completion: nil)
       }
       
       // Обработка закрытия браузера
       func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
           dismiss(animated: true, completion: nil)
       }
       
       // Обработка отмены поиска в браузере
       func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
           dismiss(animated: true, completion: nil)
       }


}
