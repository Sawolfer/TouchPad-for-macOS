//
//  Touchpad.swift
//  TouchpadDemo
//
//  Created by Савва Пономарев on 05.02.2024.
//

import UIKit
import Starscream


class Touchpad: UIViewController{
    
    @IBOutlet weak var Recogniser: UILabel!
    
    @IBAction func TapOneFinger(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.view)
        
        Recogniser.text = "One finger at \(location)"
        
    }
  
}
