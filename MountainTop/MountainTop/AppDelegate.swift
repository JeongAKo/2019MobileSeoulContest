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
 
  let notiCenter = NotificationCenter.default
  
  var window: UIWindow?
  var loginViewController: UIViewController?
  var mainViewController: UIViewController?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.backgroundColor = UIColor(named: "profileBackground")
    
    // Firebase 등록
    FirebaseApp.configure()
    setupEntryController()
    
    // Kakao
    notiCenter.addObserver(self,
                           selector: #selector(AppDelegate.kakaoSessionDidChangeWithNotification),
                           name: NSNotification.Name.KOSessionDidChange,
                           object: nil)
    
    reloadRootViewController()
    
    
    notiCenter.addObserver(self,
                           selector: #selector(AppDelegate.moveSecondTab),
                           name: .tabbarIndex,
                           object: nil)
    
    return true
  }
  
  let tapBarController = UITabBarController()
  
  deinit {
     notiCenter.removeObserver(self, name: .tabbarIndex, object: nil)
    //오빠는 안해주나?
  }

  fileprivate func setupEntryController() {
    let navigationController = UINavigationController(rootViewController: LoginVC())
    let mountainVC = MountainVC()
    let nMapVC = NMapVC()
    let userSettingVC = UINavigationController(rootViewController: ProfileVC())
    
    mountainVC.title = "Mountain"
    nMapVC.title = "Map"
    userSettingVC.title = "Profile"
    
    tapBarController.viewControllers = [mountainVC, nMapVC, userSettingVC]
    
    mountainVC.tabBarItem.image = UIImage(named: "top")
    nMapVC.tabBarItem.image = UIImage(named: "placeholder")
    userSettingVC.tabBarItem.image = UIImage(named: "profile")
    
    if #available(iOS 13, *) {
      let appearance = UITabBarAppearance()
      appearance.stackedLayoutAppearance.normal.iconColor = UIColor(named: "tabbarTextColorNormal")
      appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "tabbarTextColorNormal") ?? .black]
      appearance.stackedLayoutAppearance.selected.iconColor = UIColor(named: "tabbarTextColorSelected")
      appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "tabbarTextColorSelected") ?? .white]
      
      self.tapBarController.tabBar.standardAppearance = appearance
    } else {
      UITabBar.appearance().tintColor = UIColor.darkGray // 틴트컬러 변경
    }
    
    self.loginViewController = navigationController
    self.mainViewController = tapBarController
  }
  
  fileprivate func reloadRootViewController() {
    guard let isOpened = KOSession.shared()?.isOpen() else {
      print("isOpened is nil")
      return
    }
    if !isOpened {
        print("login: \(isOpened), isOpened false")
    }
    else {
        print("isOpened true")
        UserInfo.def.getUserInfomation()
    }
    
    
    self.window?.rootViewController = isOpened ? self.mainViewController : self.loginViewController
    self.window?.makeKeyAndVisible()
  }
  
  @objc func moveSecondTab(_ nofi: Notification) {
    guard let dict = nofi.userInfo as? [String: Int] else { return }
    if let vc = tapBarController.viewControllers?[1] as? NMapVC {
      vc.buttonTag = dict["buttonTag"] ?? 0
      vc.directTab = true
      print(vc.buttonTag)
    }
    
    tapBarController.selectedIndex = 1
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
    
    UserInfo.def.activeApp()
  }
}


