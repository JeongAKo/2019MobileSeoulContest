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
}

class CustomInfoWindowDataSource: NSObject, NMFOverlayImageDataSource {
  var rootView: CustomInfoWindowView!
  
  func view(with overlay: NMFOverlay) -> UIView {
    guard let infoWindow = overlay as? NMFInfoWindow else { return rootView }
    if rootView == nil {
      rootView = Bundle.main.loadNibNamed("CustomInfoWindowView", owner: nil, options: nil)?.first as? CustomInfoWindowView
    }
    
    if infoWindow.marker != nil {
//      rootView.iconView.image = UIImage(named: "baseline_room_black_24pt")
      rootView.mountainNameLabel.text = infoWindow.marker?.userInfo["title"] as? String
    } else {
//      rootView.iconView.image = UIImage(named: "baseline_gps_fixed_black_24pt")
      rootView.mountainNameLabel.text = "\(infoWindow.position.lat), \(infoWindow.position.lng)"
    }
    rootView.mountainNameLabel.sizeToFit()
    let width = rootView.mountainNameLabel.frame.size.width + 80
    rootView.frame = CGRect(x: 0, y: 0, width: width, height: 88)
    rootView.layoutIfNeeded()
    
    
    return rootView
  }
}
