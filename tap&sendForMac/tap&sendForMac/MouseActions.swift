//
//  MouseActions.swift
//  tap&sendForMac
//
//  Created by BrainPumpkin on 30.03.2024.
//

import Cocoa
import CoreGraphics

class MouseActions : NSViewController{
    
    
    func MouseActions(){}
    
    func SignalMan(type : String){
        let components = type.split(separator: " ")
        let action = ActionTypes(rawValue: String(components[0]))
        switch action{
        case .some(.double_click):
            
            break
        case .some(.left_mouse_click):
            self.clickLeft()
            break
        case .some(.right_mouse_click):
            self.clickRight()
            break
        case .some(.long_touchpad_touch):
            
            break
        case .some(.two_fingers):
            let velX: Int32 = Int32((String(components[1]) as NSString).floatValue * 0.01)
            let velY: Int32 = Int32((String(components[2]) as NSString).floatValue * 0.01)
            self.scroll(velX: velX, velY: velY)
            break
        case .some(.three_fingers_swipe_left):
            self.rightScreen()
            break
        case .some(.three_fingers_swipe_right):
            self.leftScreen()
            break
        case .some(.three_fingers_swipe_up):
            self.missionControl()
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
    
    func move(velX: CGFloat!, velY: CGFloat!) {
        var currentLocation: NSPoint = NSEvent.mouseLocation
        currentLocation.y = NSHeight(NSScreen.screens[0].frame) - currentLocation.y
        let newX = currentLocation.x + velX * 0.05
        let newY = currentLocation.y + velY * 0.05
        let newLocation = CGPoint(x: newX, y: newY)
        
        for screen in NSScreen.screens {
            let screenHeight = NSHeight(screen.frame)
            let screenWidth = NSWidth(screen.frame)
            
            if newLocation.x >= 0 && newLocation.x <= screenWidth && newLocation.y >= 0 && newLocation.y <= screenHeight {
                let mouseEvent = CGEvent(mouseEventSource: nil, mouseType: .mouseMoved, mouseCursorPosition: newLocation, mouseButton: .left)
                mouseEvent?.post(tap: .cghidEventTap)
            }
        }
        
        if newY >= NSHeight(NSScreen.screens[0].frame) - 10 {
            NSApp.mainMenu?.performActionForItem(at: 0)
        }
        
        if newY <= 10 {
            NSApp.dockTile.perform(#selector(NSDockTile.display))
        }
        
        usleep(100)
    }
    func doubleClick(){
        var mousePos = NSEvent.mouseLocation
        mousePos.y = NSHeight(NSScreen.screens[0].frame) - mousePos.y
        let point = CGPoint(x: mousePos.x, y: mousePos.y)
        let mouseDown = CGEvent(mouseEventSource: nil, mouseType: .leftMouseDragged, mouseCursorPosition: point, mouseButton: .left)
        let mouseUp = CGEvent(mouseEventSource: nil, mouseType: .leftMouseUp, mouseCursorPosition: point, mouseButton: .left)
        mouseDown?.post(tap: .cghidEventTap)
        usleep(500)
        mouseUp?.post(tap: .cghidEventTap)
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
        
    }
    
    func scroll(velX: Int32, velY: Int32){
//        print(velX , velY)
        
        if #available(OSX 10.13, *) {
            guard let scrollEvent = CGEvent(scrollWheelEvent2Source: nil, units: CGScrollEventUnit.line, wheelCount: 2, wheel1: Int32(velY), wheel2: Int32(velX), wheel3: 1) else {
                return
            }
            scrollEvent.setIntegerValueField(CGEventField.eventSourceUserData, value: 1)
            scrollEvent.post(tap: CGEventTapLocation.cghidEventTap)
        } else {
            // scroll event is not supported for macOS older than 10.13
        }
    }
    
    func rightScreen() {
        screens(keyCode: 0x7C)
    }
    
    
    func leftScreen(){
        screens(keyCode: 0x7B)
    }
    
    func missionControl(){
        screens(keyCode: 0x7E)
    }
    
    func screens(keyCode: CGKeyCode){
        guard let controlDown = CGEvent(keyboardEventSource: nil, virtualKey: 0x3B, keyDown: true) else {
            return
        }
        controlDown.flags = .maskControl
        
        guard let keyDown = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: true) else {
            return
        }
        keyDown.flags = [.maskControl, .maskSecondaryFn]
        
        guard let keyUp = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: false) else {
            return
        }
        keyUp.flags = [.maskControl, .maskSecondaryFn]

        guard let controlUp = CGEvent(keyboardEventSource: nil, virtualKey: 0x3B, keyDown: false) else {
            return
        }
        
        controlDown.post(tap: .cghidEventTap)
        keyDown.post(tap: .cghidEventTap)
        keyUp.post(tap: .cghidEventTap)
        controlUp.post(tap: .cghidEventTap)
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
