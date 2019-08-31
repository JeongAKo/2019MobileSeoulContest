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
    
    // Kakao
    initializeKakao()
    
    window = UIWindow(frame: UIScreen.main.bounds)
    
    window?.backgroundColor = .white
    window?.makeKeyAndVisible()
    window?.rootViewController = LoginVC()
    
    return true
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    KOSession.handleDidEnterBackground() // Kakao 서버에 상태 전달
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    KOSession.handleDidBecomeActive() // Kakao 서버에 상태 전달
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    <#code#>
  }
  
  func initializeKakao() {
    
  }
}

