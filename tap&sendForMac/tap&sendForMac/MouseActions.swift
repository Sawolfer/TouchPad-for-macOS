//
//  MouseActions.swift
//  tap&sendForMac
//
//  Created by Савва Пономарев on 30.03.2024.
//

import Cocoa

class MouseActions{
    
    func MouseActions(){}
    
    func SignalMan(type : String){
        let action = ActionTypes(rawValue: type)
        switch action{
        case .some(.left_mouse_click):
            self.clickLeft()
            break
        case .some(.right_mouse_click):
            self.clickRight()
            break
        case .some(.long_touchpad_touch):
            
            break
        case .some(.two_fingers_down):
            self.scrollUp()
            break
        case .some(.two_fingers_up):
            self.scrollDown()
            break
        case .some(.three_fingers_swipe_left):
            self.rightScreen()
            break
        case .some(.three_fingers_swipe_right):
            self.leftScreen()
            break
        case .some(.three_fingers_swipe_up):
            
            break
        case .some(.four_fingers_pinch):
            
            break
        case .some(.four_fingers_spreading):
            
            break
        case .some(.pinch):
            
            break
        case .some(.spreadingString):
            
            break
        case .none:
            break
        }
    }
    
    func clickLeft(){
        var mousePos = NSEvent.mouseLocation
        mousePos.y = NSHeight(NSScreen.screens[0].frame) - mousePos.y
        let point = CGPoint(x: mousePos.x, y: mousePos.y)
        let mouseDown = CGEvent(mouseEventSource: nil, mouseType: .leftMouseDown, mouseCursorPosition: point, mouseButton: .left)
        let mouseUp = CGEvent(mouseEventSource: nil, mouseType: .leftMouseUp, mouseCursorPosition: point, mouseButton: .left)
        mouseDown?.post(tap: .cghidEventTap)
        usleep(500)
        mouseUp?.post(tap: .cghidEventTap)
    }
    func clickRight(){
        var mousePos = NSEvent.mouseLocation
        mousePos.y = NSHeight(NSScreen.screens[0].frame) - mousePos.y
        let point = CGPoint(x: mousePos.x, y: mousePos.y)
        let mouseDown = CGEvent(mouseEventSource: nil, mouseType: .rightMouseDown, mouseCursorPosition: point, mouseButton: .right)
        let mouseUp = CGEvent(mouseEventSource: nil, mouseType: .rightMouseUp, mouseCursorPosition: point, mouseButton: .right)
        mouseDown?.post(tap: .cghidEventTap)
        usleep(500)
        mouseUp?.post(tap: .cghidEventTap)
    }
    func longClick(){
        //No ideas
    }
    func scrollDown(){
        if #available(OSX 10.13, *) {
            guard let scrollEvent = CGEvent(scrollWheelEvent2Source: nil, units: CGScrollEventUnit.line, wheelCount: 2, wheel1: Int32(-2), wheel2: Int32(-2), wheel3: 0) else {
                return
            }
            scrollEvent.setIntegerValueField(CGEventField.eventSourceUserData, value: 1)
            scrollEvent.post(tap: CGEventTapLocation.cghidEventTap)
        } else {
            // scroll event is not supported for macOS older than 10.13
        }
    }
    func scrollUp(){
        if #available(OSX 10.13, *) {
            guard let scrollEvent = CGEvent(scrollWheelEvent2Source: nil, units: CGScrollEventUnit.line, wheelCount: 2, wheel1: Int32(2), wheel2: Int32(2), wheel3: 0) else {
                return
            }
            scrollEvent.setIntegerValueField(CGEventField.eventSourceUserData, value: 1)
            scrollEvent.post(tap: CGEventTapLocation.cghidEventTap)
        } else {
            // scroll event is not supported for macOS older than 10.13
        }
    }
    func rightScreen(){
        let src = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)
        let arrow = CGEvent(keyboardEventSource: src, virtualKey: 0x3E, keyDown: true)
        
        arrow?.flags = .maskControl
    
        arrow?.post(tap: CGEventTapLocation.cghidEventTap)
    }
    func leftScreen(){
        let src = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)
        let arrow = CGEvent(keyboardEventSource: src, virtualKey: 0x3D, keyDown: true)
        arrow?.flags = .maskControl
        
        arrow?.post(tap: CGEventTapLocation.cghidEventTap)
    }
    func launchScreen(){
        
    }
    func expose(){
        
    }
    func pinch(){
        
    }
    func spread(){
        
    }
    
}
