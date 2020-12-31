//
//  AppDelegate.swift
//  TwitchApp
//
//  Created by Aleksandr Smorodov on 07.11.2020.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController")
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppUtility.shared.orientationLock
    }
}

