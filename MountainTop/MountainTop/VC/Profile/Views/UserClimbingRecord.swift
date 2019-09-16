//
//  UserClimbingRecord.swift
//  MountainTop
//
//  Created by CHANGGUEN YU on 11/09/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import UIKit

class UserClimbingRecordCell: UITableViewCell {
  
  // MARK: - Property
  static var identifier: String = "UserClimbingRecordCell"
  
  private lazy var recordLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.text = "나의 등반 기록"
    label.font = UIFont.systemFont(ofSize: FontSize.big, weight: .semibold)
    self.contentView.addSubview(label)
    return label
  }()
  
  private lazy var timeLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.text = "등반 횟수"
    label.font = UIFont.systemFont(ofSize: FontSize.midle)
    label.textColor = .darkGray
    self.contentView.addSubview(label)
    return label
  }()
  
  private lazy var hourLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.text = "등반 시간"
    label.font = UIFont.systemFont(ofSize: FontSize.midle)
    label.textColor = .darkGray
    self.contentView.addSubview(label)
    return label
  }()
  
  private lazy var distanceLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.text = "등반 거리"
    label.font = UIFont.systemFont(ofSize: FontSize.midle)
    label.textColor = .darkGray
    self.contentView.addSubview(label)
    return label
  }()
  
  private lazy var totalTimes: UILabel = {
    let label = UILabel(frame: .zero)
    label.text = "0번"
    label.font = UIFont.systemFont(ofSize: FontSize.midle, weight: .semibold)
    self.contentView.addSubview(label)
    return label
  }()
  
  private lazy var totalHour: UILabel = {
    let label = UILabel(frame: .zero)
    label.text = "00:00:00"
    label.font = UIFont.systemFont(ofSize: FontSize.midle, weight: .semibold)
    self.contentView.addSubview(label)
    return label
  }()
  
  private lazy var totalDistance: UILabel = {
    let label = UILabel(frame: .zero)
    label.text = "0.0Km"
    label.font = UIFont.systemFont(ofSize: FontSize.midle, weight: .semibold)
    self.contentView.addSubview(label)
    return label
  }()
  
  // MARK: - View life cycle
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    recordLabel.snp.makeConstraints {
      $0.top.leading.equalToSuperview().inset(Metric.margin)
    }
    timeLabel.snp.makeConstraints {
      $0.top.equalTo(recordLabel.snp.bottom).offset(Metric.margin)
      $0.leading.equalToSuperview().offset(Metric.margin)
    }
    hourLabel.snp.makeConstraints {
      $0.top.equalTo(timeLabel.snp.bottom).offset(Metric.margin/3)
      $0.leading.equalToSuperview().offset(Metric.margin)
    }
    distanceLabel.snp.makeConstraints {
      $0.top.equalTo(hourLabel.snp.bottom).offset(Metric.margin/3)
      $0.leading.equalToSuperview().offset(Metric.margin)
    }
    
    // MARK: - User Showing Infomation labels
    totalTimes.snp.makeConstraints {
      $0.top.equalTo(timeLabel)
      $0.leading.equalTo(timeLabel.snp.trailing).offset(Metric.margin)
    }
    totalHour.snp.makeConstraints {
      $0.top.equalTo(hourLabel)
      $0.leading.equalTo(hourLabel.snp.trailing).offset(Metric.margin)
    }
    totalDistance.snp.makeConstraints {
      $0.top.equalTo(distanceLabel)
      $0.leading.equalTo(distanceLabel.snp.trailing).offset(Metric.margin)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    fatalError("init(coder:) has not been implemented")
  }
  
  public func setupCell(times: String, hour: String, distance: String) {
    totalTimes.text = "\(times)번"
    totalHour.text = "\(hour)"
    totalDistance.text = "\(distance)km"
  }
}
