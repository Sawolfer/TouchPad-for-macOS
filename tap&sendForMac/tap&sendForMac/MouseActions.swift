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
        case .some(.right_mouce_click):
            self.clickRight()
            break
        case .some(.long_touchpad_touch):
            
            break
        case .some(.two_fingers_down):
            
            break
        case .some(.two_fingers_up):
            
            break
        case .some(.three_fingers_swipe_left):
            
            break
        case .some(.three_fingers_swipe_right):
            
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
        var mousePos = NSEvent.mouseLocation
        mousePos.y = NSHeight(NSScreen.screens[0].frame) - mousePos.y
        let point = CGPoint(x: mousePos.x, y: mousePos.y)
        let mouseDown = CGEvent(mouseEventSource: nil, mouseType: .leftMouseDragged, mouseCursorPosition: point, mouseButton: .right)
        let mouseUp = CGEvent(mouseEventSource: nil, mouseType: .leftMouseUp, mouseCursorPosition: point, mouseButton: .right)
        mouseDown?.post(tap: .cghidEventTap)
        usleep(500)
        mouseUp?.post(tap: .cghidEventTap)
    }
    func scrollDown(){
        
    }
    func scrollUp(){
        
    }
    func rightScreen(){
        
    }
    func leftScreen(){
        
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
