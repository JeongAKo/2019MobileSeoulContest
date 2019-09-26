//
//  RankingTableViewCell.swift
//  MountainTop
//
//  Created by Daisy on 24/09/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import UIKit

class RankingTableViewCell: UITableViewCell {
  
  // MARK: - Property
  private lazy var userImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "user"))
    imageView.contentMode = .scaleAspectFill
    addSubview(imageView)
    return imageView
  }()
  
  private lazy var medalImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "1"))
    imageView.contentMode = .scaleAspectFill
    addSubview(imageView)
    return imageView
  }()
  
  private lazy var userNameLabel: UILabel = {
    let label = UILabel(frame: CGRect.zero)
    label.text = "사냥꾼 쩡🌹"
    label.font = UIFont.boldSystemFont(ofSize: 16)
    label.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
    addSubview(label)
    return label
  }()
  
  private lazy var dateLabel: UILabel = {
    let label = UILabel(frame: CGRect.zero)
    label.text = "2019. 06 .15"
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = .lightGray
    addSubview(label)
    return label
  }()
  
  private lazy var climbingRecordLabel: UILabel = {
    let label = UILabel(frame: CGRect.zero)
    label.text = "01 : 34 : 15"
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = .lightGray
    addSubview(label)
    return label
  }()
  
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    backgroundColor = .white
    makeConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Action Methods
  
  
  // MARK: - AutoLayout
  private func makeConstraints() {
    
    userImageView.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(20)
      $0.top.trailing.equalToSuperview().inset(10)
      $0.width.equalToSuperview().multipliedBy(0.25)
      $0.height.equalTo(userImageView.snp.width)
    }
    
    medalImageView.snp.makeConstraints {
      $0.centerX.equalTo(userImageView.snp.leading)
      $0.centerY.equalTo(userImageView.snp.top)
      $0.width.height.equalTo(20) // FIXME: - 임시
    }
    
    userNameLabel.snp.makeConstraints {
      $0.top.equalTo(userImageView.snp.top)
      $0.leading.equalTo(userImageView.snp.trailing).offset(10)
    }
    
    dateLabel.snp.makeConstraints {
      $0.top.equalTo(userNameLabel.snp.bottom).offset(5)
      $0.leading.equalTo(userImageView.snp.trailing).offset(10)
    }
    
    climbingRecordLabel.snp.makeConstraints {
      $0.top.equalTo(dateLabel.snp.bottom).offset(5)
      $0.leading.equalTo(userImageView.snp.trailing).offset(10)
      $0.bottom.equalTo(userImageView.snp.bottom)
    }
    
  }
  
}
