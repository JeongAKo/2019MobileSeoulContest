//
//  UIAlertController.swift
//  MountainTop
//
//  Created by CHANGGUEN YU on 02/09/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import UIKit

extension UIAlertController {
  
  static func showMessage(_ message: String) {
    showAlert(title: "", message: message, actions: [UIAlertAction(title: "OK", style: .cancel, handler: nil)])
  }
  
  static func showAlert(title: String?, message: String?, actions: [UIAlertAction]) {
    DispatchQueue.main.async {
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
      for action in actions {
        alert.addAction(action)
      }
      if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController, let presenting = navigationController.topViewController {
        presenting.present(alert, animated: true, completion: nil)
      }
    }
  }
}
