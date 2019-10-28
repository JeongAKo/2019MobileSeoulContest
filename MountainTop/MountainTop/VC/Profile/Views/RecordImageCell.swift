//
//  RecordImageCell.swift
//  MountainTop
//
//  Created by CHANGGUEN YU on 16/09/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import UIKit

class RecordImageCell: UITableViewCell {

  static var identifier: String = "RecordImageCell"
  
  private lazy var backgroundImageView: UIImageView = {
    let iv = UIImageView(image: UIImage(named: "active"))
    iv.contentMode = .scaleAspectFit
    self.contentView.addSubview(iv)
    return iv
  }()
  
  private lazy var dateLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.text = "0000.00.00"
    label.textColor = .darkGray
    label.font = UIFont.systemFont(ofSize: FontSize.small, weight: .medium)
    self.contentView.addSubview(label)
    return label
  }()
  
  private lazy var mountainLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.text = "북한산"
    label.font = UIFont.systemFont(ofSize: FontSize.big, weight: .semibold)
    self.contentView.addSubview(label)
    return label
  }()
  
  private lazy var timeLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.text = "00:00:00"
    label.font = UIFont.systemFont(ofSize: FontSize.midle, weight: .medium)
    self.contentView.addSubview(label)
    return label
  }()
  
  private lazy var distanceLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.text = "0.00km"
    label.font = UIFont.systemFont(ofSize: FontSize.midle, weight: .medium)
    self.contentView.addSubview(label)
    return label
  }()
  
  private lazy var levelMarkView: UIView = {
    let v = UIView(frame: .zero)
    v.backgroundColor = .white
    self.contentView.addSubview(v)
    return v
  }()
  
//  private lazy var lineView: UIView = {
//    let view = UIView(frame: CGRect.zero)
//    view.layer.borderWidth = 1
//    view.layer.borderColor = UIColor.darkGray.cgColor
//    view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//    view.layer.addBorder([.top, .left], color: .black, width: 0.5)
//    self.contentView.addSubview(view)
//    return view
//  }()
  
  private lazy var recordMarkImageView: UIImageView = {
    let iv = UIImageView(image: UIImage(named: "group"))
    self.contentView.addSubview(iv)
    return iv
  }()
  
  private lazy var distanceMarkImageView: UIImageView = {
    let iv = UIImageView(image: UIImage(named: "distance"))
    self.contentView.addSubview(iv)
    return iv
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.contentView.backgroundColor = UIColor(named: "profileBackground")
    backgroundImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    autolayout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func autolayout() {
    
    dateLabel.snp.makeConstraints {
      $0.top.leading.equalToSuperview().inset(Metric.margin*1.3)
    }
    levelMarkView.snp.makeConstraints {
      $0.top.equalTo(dateLabel.snp.bottom).offset(Metric.margin/3)
      $0.leading.equalToSuperview().inset(Metric.margin*1.3)
      $0.height.equalTo(mountainLabel)
      $0.width.equalTo(levelMarkView.snp.height)
    }
    mountainLabel.snp.makeConstraints {
      $0.top.equalTo(levelMarkView)
      $0.leading.equalTo(levelMarkView)
    }
    
//    lineView.snp.makeConstraints {
//      $0.top.equalTo(mountainLabel.snp.bottom).offset(Metric.margin/3)
//      $0.leading.trailing.equalToSuperview()
//      $0.height.equalTo(1)
//    }
    
    recordMarkImageView.snp.makeConstraints {
      $0.top.equalTo(mountainLabel.snp.bottom).offset(Metric.margin*1.3)
      $0.leading.equalToSuperview().inset(Metric.margin*1.3)
      $0.height.equalTo(mountainLabel).multipliedBy(0.5)
      $0.width.equalTo(recordMarkImageView.snp.height)
    }
    timeLabel.snp.makeConstraints {
      $0.centerY.equalTo(recordMarkImageView)
      $0.leading.equalTo(recordMarkImageView.snp.trailing)
    }
    distanceLabel.snp.makeConstraints {
      $0.leading.equalTo(self.contentView.snp.centerX)
      $0.centerY.equalTo(timeLabel)
    }
    distanceMarkImageView.snp.makeConstraints {
      $0.centerY.equalTo(distanceLabel)
      $0.trailing.equalTo(distanceLabel.snp.leading)
      $0.height.equalTo(mountainLabel).multipliedBy(0.5)
      $0.width.equalTo(recordMarkImageView.snp.height)
    }
  }
}
