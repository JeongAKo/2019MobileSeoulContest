//
//  DefaultCell.swift
//  MountainTop
//
//  Created by CHANGGUEN YU on 11/09/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import UIKit

class DefaultCell: UITableViewCell {
  
  static var identifier: String = "DefaultCell"
  
  public lazy var mainLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.text = "main"
    label.font = UIFont.systemFont(ofSize: FontSize.big, weight: .semibold)
    self.contentView.addSubview(label)
    return label
  }()
  
  public lazy var markImageView: UIImageView = {
    let iv = UIImageView(image: UIImage(named: "back"))
    iv.contentMode = .scaleAspectFit
    self.contentView.addSubview(iv)
    return iv
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.selectionStyle = .none
    
    mainLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(Metric.margin)
      $0.centerY.equalToSuperview()
    }
    
    markImageView.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(Metric.margin)
      $0.centerY.equalToSuperview()
      $0.height.equalTo(mainLabel).multipliedBy(1.5)
      $0.width.equalTo(markImageView)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    fatalError("init(coder:) has not been implemented")
  }
  
  
}
