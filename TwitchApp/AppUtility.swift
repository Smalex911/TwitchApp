//
//  AppUtility.swift
//  TwitchApp
//
//  Created by Aleksandr Smorodov on 08.11.2020.
//

import UIKit

struct AppUtility {
    
    static var shared = AppUtility()
    
    var orientationLock: UIInterfaceOrientationMask = .all
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        shared.orientationLock = orientation
    }

    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation: UIInterfaceOrientation?) {
        self.lockOrientation(orientation)
        
        if let orientation = rotateOrientation?.rawValue {
            UIDevice.current.setValue(orientation, forKey: "orientation")
            UINavigationController.attemptRotationToDeviceOrientation()
        }
    }
    
    static func lockCurrentOrientation() {
        switch UIApplication.shared.statusBarOrientation {
        case .portraitUpsideDown:
            shared.orientationLock = .portraitUpsideDown
            break
        case .landscapeLeft:
            shared.orientationLock = .landscapeLeft
            break
        case .landscapeRight:
            shared.orientationLock = .landscapeRight
            break
        default:
            shared.orientationLock = .portrait
            break
        }
    }
}
