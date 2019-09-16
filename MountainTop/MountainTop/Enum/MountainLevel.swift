//
//  MountainLevel.swift
//  MountainTop
//
//  Created by CHANGGUEN YU on 15/09/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import Foundation

enum LevelOfMountain: Int {
  case none
  case row
  case midle
  case high
  
  func getColor() -> UIColor {
    switch self {
    case .row:
      return #colorLiteral(red: 0.04028440267, green: 0.4529570937, blue: 0.822104454, alpha: 1)
    case .midle:
      return #colorLiteral(red: 1, green: 0.8011913896, blue: 0.2809977531, alpha: 1)
    case .high:
      return #colorLiteral(red: 0.8880512118, green: 0.1870868802, blue: 0.1195671186, alpha: 1)
    default:
      return UIColor.white
    }
  }
}
