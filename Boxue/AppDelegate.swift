//
//  AppDelegate.swift
//  Boxue
//
//  Created by archerLj on 2019/4/3.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import UIKit
import Boxue_iOS

// carthage update --platform iOS --no-use-binaries

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let diContainer = BoxueAppDepedencyContainer()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let mainVC = diContainer.makeMainViewController()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = mainVC
        window?.makeKeyAndVisible()
        return true
    }
}

