//
//  TimeInterval.swift
//  MountainTop
//
//  Created by Daisy on 17/09/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import Foundation

extension TimeInterval {
  func asTimeString() -> String {
    
    let hours = Int(self) / 3600
    let minutes = Int(self) / 60 % 60
    let seconds = Int(self) % 60
    
    return String(format: "%02i : %02i : %02i", hours, minutes, seconds  )
  }
}
