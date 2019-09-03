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
    
//    window?.rootViewController = LoginVC()
//    window?.rootViewController = NMapVC()
    
    let tapBarController = UITabBarController()
    let mountainVC = MountainVC()
    let nMapVC = NMapVC()
    let userSettingVC = UINavigationController(rootViewController: UserSettingVC())
    
    mountainVC.title = "Mountain"
    nMapVC.title = "Map"
    userSettingVC.title = "Profile"
    
    tapBarController.viewControllers = [mountainVC, nMapVC, userSettingVC]
    
    mountainVC.tabBarItem.image = UIImage(named: "top")
    nMapVC.tabBarItem.image = UIImage(named: "placeholder")
    userSettingVC.tabBarItem.image = UIImage(named: "profile")
    
    window?.rootViewController = tapBarController
    UITabBar.appearance().tintColor = UIColor.darkGray // 틴트컬러 변경
    
    return true
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    KOSession.handleDidEnterBackground() // Kakao 서버에 상태 전달
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    KOSession.handleDidBecomeActive() // Kakao 서버에 상태 전달
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    
    return false
  }
  
  func initializeKakao() {
    
  }
}

