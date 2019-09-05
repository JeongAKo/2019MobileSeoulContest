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
  var loginViewController: UIViewController?
  var mainViewController: UIViewController?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.backgroundColor = .white
    
    // Firebase 등록
    FirebaseApp.configure()
    
    setupEntryController()
    
    // Kakao
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(AppDelegate.kakaoSessionDidChangeWithNotification),
                                           name: NSNotification.Name.KOSessionDidChange,
                                           object: nil)
    
    reloadRootViewController()
    
    return true
  }

  fileprivate func setupEntryController() {
    let navigationController = UINavigationController(rootViewController: LoginVC())
//    let navigationController2 = UINavigationController(rootViewController: LogoutVC())
    
    let tapBarController = UITabBarController()
    let mountainVC = MountainVC()
    let nMapVC = NMapVC()
    let userSettingVC = UINavigationController(rootViewController: LogoutVC())//UserSettingVC())
    
    mountainVC.title = "Mountain"
    nMapVC.title = "Map"
    userSettingVC.title = "Profile"
    
    tapBarController.viewControllers = [mountainVC, nMapVC, userSettingVC]
    
    mountainVC.tabBarItem.image = UIImage(named: "top")
    nMapVC.tabBarItem.image = UIImage(named: "placeholder")
    userSettingVC.tabBarItem.image = UIImage(named: "profile")
    
//    window?.rootViewController = tapBarController
    UITabBar.appearance().tintColor = UIColor.darkGray // 틴트컬러 변경
    
    self.loginViewController = navigationController
    self.mainViewController = tapBarController//navigationController2
  }
  
  fileprivate func reloadRootViewController() {
    guard let isOpened = KOSession.shared()?.isOpen() else {
      print("isOpened is nil")
      return
    }
    if !isOpened {
//      let mainViewController = self.mainViewController as! UINavigationController
//      mainViewController.popToRootViewController(animated: true)
    }
    
    self.window?.rootViewController = isOpened ? self.mainViewController : self.loginViewController
    self.window?.makeKeyAndVisible()
  }
  
  @objc func kakaoSessionDidChangeWithNotification() {
    reloadRootViewController()
  }
  
  func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    if KOSession.handleOpen(url) {
      return true
    }
    return false
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
    if KOSession.handleOpen(url) {
      return true
    }
    return false
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    KOSession.handleDidEnterBackground()
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    KOSession.handleDidBecomeActive()
  }
}


