//
//  CustomInfoWindow.swift
//  MountainTop
//
//  Created by Daisy on 19/09/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import UIKit
import NMapsMap

class CustomInfoWindowView: UIView {
  
  @IBOutlet var mountainNameLabel: UILabel!
  @IBOutlet var phoneNumber: UILabel!
  
  @IBOutlet weak var iconView: UIImageView!
  
}

class CustomInfoWindowDataSource: NSObject, NMFOverlayImageDataSource {
  var rootView: CustomInfoWindowView!
  
  func view(with overlay: NMFOverlay) -> UIView {
    guard let infoWindow = overlay as? NMFInfoWindow else { return rootView }
    if rootView == nil {
      rootView = Bundle.main.loadNibNamed("CustomInfoWindowView", owner: nil, options: nil)?.first as? CustomInfoWindowView
    }
    
    if infoWindow.marker != nil {
      rootView.iconView.image = UIImage(named: "information")
      rootView.mountainNameLabel.text = infoWindow.marker?.userInfo["title"] as? String
    } else {
      rootView.iconView.image = UIImage(named: "information")
      rootView.mountainNameLabel.text = "\(infoWindow.position.lat), \(infoWindow.position.lng)"
    }
    rootView.layoutIfNeeded()
    
    
    return rootView
  }
}
