//
//  TabBarVC.swift
//  MountainTop
//
//  Created by Daisy on 03/09/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {
  
  private let mountainVC = MountainVC()
  private let nMapVC = NMapVC()
  private let userSettingVC = UINavigationController(rootViewController: UserSettingVC())
  
  
  // ViewLifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tabBar.backgroundColor = .white
    setupTabBarItems()

  }
  
  // tabbarItem Image설정
   private func setupTabBarItems() {
  
  mountainVC.tabBarItem.image = UIImage(named: "top")
  nMapVC.tabBarItem.image = UIImage(named: "placeholder")
  userSettingVC.tabBarItem.image = UIImage(named: "profile")
  
//  viewControllers = [homeVC, storeVC, expertVC, myPageVC, addUserActivityVC]
//
//  if let items = tabBar.items {
//  for tabBarItem in items {
//  tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
//  }
//  }
//  self.tabBar.unselectedItemTintColor = UIColor.lightGray
  }

  
}
