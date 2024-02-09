import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
    var session: MCSession!
    var advertiser: MCAdvertiserAssistant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Создание сессии
        let peerID = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        
        // Запуск рекламы
        advertiser = MCAdvertiserAssistant(serviceType: "my-service", discoveryInfo: nil, session: session)
        advertiser.start()
    }
    
    // Обработка нажатия на экран
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
