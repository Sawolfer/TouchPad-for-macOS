//
//  TouchpadViewController.swift
//  tap&send
//
//  Created by Савва Пономарев on 29.05.2025.
//

#if os(iOS)
import UIKit
import MultipeerConnectivity

import SwiftUI

// MARK: - UIViewRepresentable Wrapper
struct GesturesViewRepresentable: UIViewControllerRepresentable {
    var viewModel: TouchpadScreenViewModel

    func makeUIViewController(context: Context) -> GesturesView {
        return GesturesView(viewModel: viewModel)
    }

    func updateUIViewController(_ uiViewController: GesturesView, context: Context) {
    }
}

final class GesturesView: UIViewController {
    // MARK: - Properties
    private let viewModel: TouchpadScreenViewModel


    // MARK: - Initialization
    init(viewModel: TouchpadScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestures()
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
#endif
