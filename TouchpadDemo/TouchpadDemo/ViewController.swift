//
//  ViewController.swift
//  TouchpadDemo
//
//  Created by Савва Пономарев on 04.02.2024.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func Start(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Touchpad", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Touchpad")
        self.present(nextViewController, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    

}

