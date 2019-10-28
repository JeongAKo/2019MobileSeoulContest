//
//  voidCell.swift
//  MountainTop
//
//  Created by CHANGGUEN YU on 15/09/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import UIKit

class VoidCell: UITableViewCell {
  
  static var identifier: String = "voidCell"

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none
    self.contentView.backgroundColor = UIColor(named: "profileBackground")
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
