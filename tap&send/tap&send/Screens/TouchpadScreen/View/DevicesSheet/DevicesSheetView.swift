//
//  DevicesSheetView.swift
//  tap&send
//
//  Created by Савва Пономарев on 29.05.2025.
//

import Foundation
import MultipeerConnectivity

protocol DevicesSheetDelegate: AnyObject {
    func didSelectPeer(_ peer: MCPeerID)
}

final class DevicesSheet: UIViewController {
    // MARK: - Properties
    private let tableView = UITableView()
    private var peers: [MCPeerID] = []
    weak var delegate: DevicesSheetDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 10

        // Setup TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DeviceCell.self, forCellReuseIdentifier: "DeviceCell")
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Public Methods
   func updatePeers(_ peers: [MCPeerID]) {
       self.peers = peers
       tableView.reloadData()
   }
}

// MARK: - UITableViewDataSource & Delegate
extension DevicesSheet: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath) as! DeviceCell
        cell.configure(with: peers[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didSelectPeer(peers[indexPath.row])
    }
}
