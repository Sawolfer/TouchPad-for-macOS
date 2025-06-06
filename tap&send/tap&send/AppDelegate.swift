//
//  AppDelegate.swift
//  tap&send
//
//  Created by BrainPumpkin on 27.03.2024.
//

import UIKit

@main 
class AppDelegate: UIResponder, UIApplicationDelegate { 

    var window: UIWindow? 

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool { 
        let frame = UIScreen.main.bounds
        window = UIWindow(frame: frame)
        
        let viewController = TouchpadViewController()
        viewController.modalPresentationStyle = .fullScreen
        
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
        return true 
    } 
}

