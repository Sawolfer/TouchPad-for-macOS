//
//  MouseActions.swift
//  tap&sendForMac
//
//  Created by Савва Пономарев on 30.03.2024.
//

import Cocoa

class MouseActions : NSViewController{
    
    
    func MouseActions(){}
    
    func SignalMan(type : String){
        let components = type.split(separator: " ")
        let action = ActionTypes(rawValue: String(components[0]))
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
        default:
            let tmpX: String = String(components[0])
            let tmpY: String = String(components[1])

            move(velX: tmpX.CGFloatValue(), velY: tmpY.CGFloatValue())
        }
    }
    
    func move(velX: CGFloat!, velY: CGFloat!){
        
        var currentLocation: NSPoint = NSEvent.mouseLocation
        currentLocation.y = NSHeight(NSScreen.screens[0].frame) - currentLocation.y
        
        let newX = currentLocation.x + velX * 0.05
        let newY = currentLocation.y + velY * 0.05
        
        let newLocation = CGPoint(x: newX, y: newY)
        
        CGWarpMouseCursorPosition(newLocation)
        usleep(100)
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
    func scrollDown() {
        if #available(OSX 10.13, *) {
            let scrollAmount: Int32 = 2
            let numEvents: Int = 1
            let delay: TimeInterval = 0.01
            
            for _ in 0..<numEvents {
                guard let scrollEvent = CGEvent(scrollWheelEvent2Source: nil, units: CGScrollEventUnit.line, wheelCount: 2, wheel1: Int32(-scrollAmount), wheel2: Int32(-scrollAmount), wheel3: 0) else {
                    return
                }
                scrollEvent.setIntegerValueField(CGEventField.eventSourceUserData, value: 1)
                scrollEvent.post(tap: CGEventTapLocation.cghidEventTap)
                usleep(UInt32(delay * 1_000_000)) // wait for a short delay
            }
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
        let arrowD = CGEvent(keyboardEventSource: nil, virtualKey: 123, keyDown: true)
        let arrowU = CGEvent(keyboardEventSource: nil, virtualKey: 123, keyDown: false)
        
        arrowD?.flags = CGEventFlags.maskControl
        
        
        arrowD?.post(tap: .cghidEventTap)
        arrowU?.post(tap: .cghidEventTap)
    }
    func leftScreen(){
        let arrow = CGEvent(keyboardEventSource: nil, virtualKey: 124, keyDown: true)
        arrow?.flags = .maskControl
        
        arrow?.post(tap: CGEventTapLocation.cghidEventTap)
    }
    func screens(){
        
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

extension String {

  func CGFloatValue() -> CGFloat? {
    guard let doubleValue = Double(self) else {
      return nil
    }

    return CGFloat(doubleValue)
  }
}
