//
//  TouchpadViewController.swift
//  tap&send
//
//  Created by Савва Пономарев on 29.05.2025.
//

import UIKit
import MultipeerConnectivity

final class TouchpadViewController: UIViewController {
    
    // MARK: - UI Components
    private lazy var statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.text = "Not Connected"
        statusLabel.textAlignment = .center
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.textColor = .systemYellow
        statusLabel.font = UIFont.boldSystemFont(ofSize: 15)
        return statusLabel
    }()

    private lazy var connectionButton: UIButton = {
        let connectButton = UIButton()
        connectButton.setTitle("Connect", for: .normal)
        connectButton.addAction(UIAction { [weak self] _ in
            self?.connectionButtonTapped()
        }, for: .touchUpInside)
        connectButton.translatesAutoresizingMaskIntoConstraints = false
        connectButton.tintColor = .clear
        connectButton.backgroundColor = .systemYellow
        connectButton.layer.cornerRadius = 10
        connectButton.layer.masksToBounds = true
        return connectButton
    }()

    private var isConnected = false {
        didSet {
            updateConnectionUI()
        }
    }

    private weak var devicesSheet: DevicesSheet!
    private var sheetHeightConstraint: NSLayoutConstraint!

    // MARK: - Properties
    private let viewModel: TouchpadViewModel


    // MARK: - Initialization
    init() {
        self.viewModel = TouchpadViewModel()
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGestures()
        viewModel.delegate = self
        viewModel.startBrowsing()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemGray

        // Status Label
        view.addSubview(statusLabel)
        
        // Connect Button
        view.addSubview(connectionButton)

        // Disconnect Button
        
        // Layout Constraints
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            connectionButton.widthAnchor.constraint(equalToConstant: 150),
            connectionButton.heightAnchor.constraint(equalToConstant: 44),
            connectionButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 20),
            connectionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    // MARK: - Gesture Setup
    private func setupGestures() {
        // One-finger tap
        let oneTap = UITapGestureRecognizer(target: self, action: #selector(handleOneFingerTap))
        oneTap.numberOfTapsRequired = 1
        oneTap.numberOfTouchesRequired = 1
        view.addGestureRecognizer(oneTap)
        
        // Two-finger tap
        let twoTap = UITapGestureRecognizer(target: self, action: #selector(handleTwoFingerTap))
        twoTap.numberOfTouchesRequired = 2
        view.addGestureRecognizer(twoTap)
        
        // Long press
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPress.minimumPressDuration = 1
        longPress.numberOfTouchesRequired = 1
        view.addGestureRecognizer(longPress)
        
        // One-finger pan
        let onePan = UIPanGestureRecognizer(target: self, action: #selector(handleOneFingerPan))
        onePan.minimumNumberOfTouches = 1
        onePan.maximumNumberOfTouches = 1
        view.addGestureRecognizer(onePan)
        
        // Two-finger pan
        let twoPan = UIPanGestureRecognizer(target: self, action: #selector(handleTwoFingerPan))
        twoPan.minimumNumberOfTouches = 2
        twoPan.maximumNumberOfTouches = 2
        view.addGestureRecognizer(twoPan)
        
        // Three-finger pan
        let threePan = UIPanGestureRecognizer(target: self, action: #selector(handleThreeFingerPan))
        threePan.minimumNumberOfTouches = 3
        view.addGestureRecognizer(threePan)
    }
    
    // MARK: - Button Actions
    private func connectionButtonTapped() {
        if isConnected {
            viewModel.disconnect()
            viewModel.startBrowsing()
        } else {
            showDevicesSheet()
        }
    }

    private func disconnectButtonTapped() {
        viewModel.disconnect()
        viewModel.startBrowsing()
    }

    // Add this property to the class
    private var bottomConstraint: NSLayoutConstraint!
    
    // MARK: - Sheet Animation
    private func showDevicesSheet() {
        let deviceSheet = DevicesSheet()
        deviceSheet.delegate = self
        deviceSheet.updatePeers(viewModel.availablePeers)
        if let sheet = deviceSheet.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        deviceSheet.modalPresentationStyle = .pageSheet
        present(deviceSheet, animated: true)
    }
    
    private func hideDevicesSheet() {
        devicesSheet?.dismiss(animated: true)
        devicesSheet = nil
    }

    private func updateConnectionUI() {
        DispatchQueue.main.async {
            if self.isConnected {
                self.connectionButton.setTitle("Disconnect", for: .normal)
                self.statusLabel.text = "Connected"
            } else {
                self.connectionButton.setTitle("Connect", for: .normal)
                self.statusLabel.text = "Not Connected"
            }
        }
    }

    // MARK: - Gesture Handlers
    @objc private func handleOneFingerTap() {
        viewModel.handleOneFingerTap()
    }
    
    @objc private func handleTwoFingerTap() {
        viewModel.handleTwoFingerTap()
    }
    
    @objc private func handleLongPress() {
        viewModel.handleLongPress()
    }
    
    @objc private func handleOneFingerPan(_ sender: UIPanGestureRecognizer) {
        let velocity = sender.velocity(in: view)
        viewModel.handleOneFingerPan(velocity: velocity)
    }
    
    @objc private func handleTwoFingerPan(_ sender: UIPanGestureRecognizer) {
        let velocity = sender.velocity(in: view)
        viewModel.handleTwoFingerPan(velocity: velocity)
    }
    
    @objc private func handleThreeFingerPan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .ended:
            let translation = sender.translation(in: view)
            viewModel.handleThreeFingerPan(translation: translation)
        default:
            break
        }
    }
}

extension TouchpadViewController: DevicesSheetDelegate {
    func didSelectPeer(_ peer: MCPeerID) {
        hideDevicesSheet()
        viewModel.invitePeer(peer)
    }
}

// MARK: - TouchpadViewModelDelegate
extension TouchpadViewController: TouchpadViewModelDelegate {
    func connectionStateChanged(_ state: MCSessionState) {
        switch state {
        case .connected:
            isConnected = true
        case .notConnected, .connecting:
            isConnected = false
        @unknown default:
            isConnected = false
        }
    }

    func receivedMessage(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        }
    }
}

#Preview{
    TouchpadViewController()
}
