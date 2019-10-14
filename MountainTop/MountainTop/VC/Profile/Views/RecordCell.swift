//
//  RecordCell.swift
//  MountainTop
//
//  Created by CHANGGUEN YU on 15/09/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import UIKit

class RecordCell: UITableViewCell {
  
  static var identifier: String = "RecordCell"
  
  private lazy var containerView: UIView = {
    let view = UIView(frame: .zero)
    view.backgroundColor = .clear
    view.layer.shadowOpacity = 1
    view.layer.shadowRadius = 2
    view.layer.shadowColor = UIColor.lightGray.cgColor
    view.layer.shadowOffset = CGSize(width: 0, height: 0)
    self.contentView.addSubview(view)
    return view
  }()
  
  private lazy var clipView: UIView = {
    let view = UIView(frame: .zero)
    view.backgroundColor = .white
    view.layer.cornerRadius = 10
    view.layer.masksToBounds = true
    self.containerView.addSubview(view)
    return view
  }()
  
  private lazy var dateLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.text = "0000.00.00"
    label.textColor = .darkGray
    label.font = UIFont.systemFont(ofSize: FontSize.small, weight: .medium)
    self.clipView.addSubview(label)
    return label
  }()
  
  private lazy var mountainLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.text = "북한산"
    label.font = UIFont.systemFont(ofSize: FontSize.big, weight: .semibold)
    self.clipView.addSubview(label)
    return label
  }()
  
  private lazy var timeLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.text = "00:00:00"
    label.font = UIFont.systemFont(ofSize: FontSize.midle, weight: .medium)
    self.clipView.addSubview(label)
    return label
  }()
  
  private lazy var distanceLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.text = "0.00km"
    label.font = UIFont.systemFont(ofSize: FontSize.midle, weight: .medium)
    self.clipView.addSubview(label)
    return label
  }()
  
  private lazy var levelMarkView: UIView = {
    let v = UIView(frame: .zero)
    v.layer.masksToBounds = true
    v.backgroundColor = .white
    self.clipView.addSubview(v)
    return v
  }()
  
  private lazy var lineView: UIView = {
    let view = UIView(frame: CGRect.zero)
    view.layer.borderWidth = 1
    view.layer.borderColor = UIColor.lightGray.cgColor
    view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    view.layer.addBorder([.top, .left], color: .black, width: 0.5)
    self.clipView.addSubview(view)
    return view
  }()
  
  private lazy var recordMarkImageView: UIImageView = {
    let iv = UIImageView(image: UIImage(named: "group"))
    self.clipView.addSubview(iv)
    return iv
  }()
  
  private lazy var distanceMarkImageView: UIImageView = {
    let iv = UIImageView(image: UIImage(named: "distance"))
    self.clipView.addSubview(iv)
    return iv
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none
    self.autolayout()
    self.contentView.layoutIfNeeded()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setupViews()
  }
  
  private func autolayout() {
    
    containerView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    clipView.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(10)
    }
    
    dateLabel.snp.makeConstraints {
      $0.top.leading.equalToSuperview().inset(Metric.margin/3)
    }
    levelMarkView.snp.makeConstraints {
      $0.top.equalTo(dateLabel.snp.bottom).offset(Metric.margin/3)
      $0.leading.equalToSuperview().inset(Metric.margin/3)
      $0.height.equalTo(mountainLabel)
      $0.width.equalTo(levelMarkView.snp.height)
    }
    mountainLabel.snp.makeConstraints {
      $0.top.equalTo(levelMarkView)
      $0.leading.equalTo(levelMarkView.snp.trailing).offset(Metric.margin/3)
    }
    
    lineView.snp.makeConstraints {
      $0.top.equalTo(mountainLabel.snp.bottom).offset(Metric.margin/3)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(1)
    }
    
    recordMarkImageView.snp.makeConstraints {
      $0.top.equalTo(lineView.snp.bottom).offset(Metric.margin)
      $0.leading.equalToSuperview().inset(Metric.margin)
    }
    timeLabel.snp.makeConstraints {
      $0.centerY.equalTo(recordMarkImageView)
      $0.leading.equalTo(recordMarkImageView.snp.trailing).offset(Metric.margin)
    }
    distanceLabel.snp.makeConstraints {
      $0.leading.equalTo(distanceMarkImageView.snp.trailing).offset(Metric.margin/3)
      $0.centerY.equalTo(timeLabel)
    }
    distanceMarkImageView.snp.makeConstraints {
      $0.centerY.equalTo(distanceLabel)
      $0.leading.equalTo(self.contentView.snp.centerX).offset(Metric.margin)
    }
  }
  
  private func setupViews() {
    levelMarkView.layer.cornerRadius = levelMarkView.frame.height/2
  }
  
  public func setupCell(date: String, level: LevelOfMountain, name: String, record: String, distance: String) {
    dateLabel.text = date
    levelMarkView.backgroundColor = level.getColor()
    mountainLabel.text = name
    timeLabel.text = record
    distanceLabel.text = distance
  }
}
