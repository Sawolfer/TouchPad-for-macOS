//
//  TouchpadScreenViewModel.swift
//  tap&send
//
//  Created by Савва Пономарев on 08.09.2025.
//

import SwiftUI

final class TouchpadScreenViewModel: ObservableObject {
    @ObservedObject var mvViewModel: MainScreenViewModel

    init(mvViewModel: MainScreenViewModel) {
        self.mvViewModel = mvViewModel
    }

    func handleOneFingerTap() {
        mvViewModel.send(message: "left_mouse_click")
        Vibration.medium.vibrate()
    }

    func handleTwoFingerTap() {
        mvViewModel.send(message: "right_mouse_click")
        Vibration.medium.vibrate()
    }

    func handleLongPress() {
        mvViewModel.send(message: "long_touchpad_touch")
        Vibration.heavy.vibrate()
    }

    func handleOneFingerPan(velocity: CGPoint) {
        let msg = String(format: "%.5f", velocity.x) + " " + String(format: "%.5f", velocity.y)
        mvViewModel.send(message: msg)
    }

    func handleTwoFingerPan(velocity: CGPoint) {
        let msg = "two_fingers " + String(format: "%.5f", velocity.x) + " " + String(format: "%.5f", velocity.y)
        mvViewModel.send(message: msg)
    }

    func handleThreeFingerPan(translation: CGPoint) {
        let angle = atan2(translation.y, translation.x)

        if angle > -0.5 && angle <= 0.5 {
            mvViewModel.send(message: "three_fingers_swipe_right")
        } else if angle > -2 && angle <= -1 {
            mvViewModel.send(message: "three_fingers_swipe_up")
        } else if abs(angle) >= 2.5 {
            mvViewModel.send(message: "three_fingers_swipe_left")
        }

        usleep(500)
    }

    func handleOneFingerPan(velocity: CGSize) {
        let msg = String(format: "%.5f", velocity.width) + " " + String(format: "%.5f", velocity.height)
        mvViewModel.send(message: msg)
    }

    func handleTwoFingerPan(velocity: CGSize) {
        let msg = "two_fingers " + String(format: "%.5f", velocity.width) + " " + String(format: "%.5f", velocity.height)
        mvViewModel.send(message: msg)
    }

    func handleThreeFingerPan(translation: CGSize) {
        let angle = atan2(translation.height, translation.width)

        if angle > -0.5 && angle <= 0.5 {
            mvViewModel.send(message: "three_fingers_swipe_right")
        } else if angle > -2 && angle <= -1 {
            mvViewModel.send(message: "three_fingers_swipe_up")
        } else if abs(angle) >= 2.5 {
            mvViewModel.send(message: "three_fingers_swipe_left")
        }

        usleep(500)
    }
}
