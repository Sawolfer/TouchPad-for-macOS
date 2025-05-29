//
//  DeviceCell.swift
//  tap&send
//
//  Created by Савва Пономарев on 29.05.2025.
//

import UIKit
import MultipeerConnectivity

// MARK: - Custom Cell
final class DeviceCell: UITableViewCell {
    private let nameLabel = UILabel()
    private let deviceIcon = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        // Configure name label
        nameLabel.font = .systemFont(ofSize: 18, weight: .medium)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure icon
        deviceIcon.image = UIImage(systemName: "laptopcomputer")
        deviceIcon.tintColor = .systemBlue
        deviceIcon.translatesAutoresizingMaskIntoConstraints = false
        
        // Stack View
        let stackView = UIStackView(arrangedSubviews: [deviceIcon, nameLabel])
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            deviceIcon.widthAnchor.constraint(equalToConstant: 24),
            deviceIcon.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configure(with peer: MCPeerID) {
        nameLabel.text = peer.displayName
    }
}
