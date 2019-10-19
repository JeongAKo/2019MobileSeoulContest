//
//  ProfileMainCell.swift
//  MountainTop
//
//  Created by CHANGGUEN YU on 11/09/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileMainCell: UITableViewCell {

  // MARK: - Property
  static var identifier: String = "ProfileMainCell"
  
  private lazy var profileLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.font = UIFont.systemFont(ofSize: FontSize.big, weight: .semibold)
    label.text = "프로필"
    self.contentView.addSubview(label)
    return label
  }()
  
  private lazy var userImageView: UIImageView = {
    let iv = UIImageView(frame: .zero)
    iv.contentMode = .scaleAspectFit
    iv.backgroundColor = .red
    self.contentView.addSubview(iv)
    return iv
  }()
  
  private lazy var userName: UILabel = {
    let label = UILabel(frame: .zero)
    label.text = "Guest"
    label.font = UIFont.systemFont(ofSize: FontSize.big, weight: .regular)
    self.contentView.addSubview(label)
    return label
  }()
  
  // MARK: - View life cycle
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none
    autolayout()
    setupViews()
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - setupViews
  private func autolayout() {
    profileLabel.snp.makeConstraints {
      $0.top.leading.equalTo(self.contentView).inset(Metric.margin)
    }
    userImageView.snp.makeConstraints {
      $0.top.equalTo(self.profileLabel.snp.bottom).offset(Metric.margin)
      $0.leading.equalTo(self.contentView).inset(Metric.margin)
      $0.width.height.equalTo(self.contentView.snp.width).multipliedBy(0.20)
    }
    userName.snp.makeConstraints {
      $0.centerY.equalTo(self.userImageView)
      $0.leading.equalTo(self.userImageView.snp.trailing).offset(Metric.margin)
    }
  }
  
  private func setupViews() {
    self.contentView.backgroundColor = UIColor(named: "profileBackground")
    userImageView.layer.masksToBounds = true
    userImageView.layer.cornerRadius = UIScreen.main.bounds.width/10
  }
  
  public func setupCell(url: String, name: String) {
    
    if let url = URL(string: url) {
      userImageView.kf.setImage(with: url,
                  placeholder: nil,
                  options: [.transition(.fade(0)), .loadDiskFileSynchronously],
                  progressBlock: nil) { (_) in
      }
    }
    
    userName.text = name
  }
  
}
