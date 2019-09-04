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
//    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let navigationController = UINavigationController(rootViewController: LoginVC())
    let navigationController2 = UINavigationController(rootViewController: LogoutVC())
    
//    let viewController = storyboard.instantiateViewController(withIdentifier: "login") as UIViewController
//    navigationController.pushViewController(viewController, animated: true)
    self.loginViewController = navigationController
    
//    let viewController2 = storyboard.instantiateViewController(withIdentifier: "main") as UIViewController
//    navigationController2.pushViewController(viewController2, animated: true)
    self.mainViewController = navigationController2
  }
  
  fileprivate func reloadRootViewController() {
    guard let isOpened = KOSession.shared()?.isOpen() else {
      print("isOpened is nil")
      return
    }
    if !isOpened {
      let mainViewController = self.mainViewController as! UINavigationController
      mainViewController.popToRootViewController(animated: true)
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
  
  func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
//    MapleBaconStorage.sharedStorage.clearMemoryStorage()
  }
}

