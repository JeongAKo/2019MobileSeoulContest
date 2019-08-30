//
//  AppDelegate.swift
//  MountainTop
//
//  Created by CHANGGUEN YU on 28/08/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    // Firebase 등록
    FirebaseApp.configure()
    
    window = UIWindow(frame: UIScreen.main.bounds)
    
    window?.backgroundColor = .white
    window?.makeKeyAndVisible()
    window?.rootViewController = ViewController()
    
    return true
  }
}

