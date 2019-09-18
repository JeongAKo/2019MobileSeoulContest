//
//  RecordView.swift
//  MountainTop
//
//  Created by Daisy on 03/09/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import UIKit

class RecordTopView: UIView {
  
  var startTime = TimeInterval()
  var (hours, minutes, seconds) = (0, 0, 0 )
  
  private lazy var winnerTitleLabel: UILabel = {
    let label = UILabel(frame: CGRect.zero)
    label.text = "1위 기록"
    label.font = UIFont.systemFont(ofSize: 13)
    label.textColor = .darkGray
    label.textAlignment = .center
    addSubview(label)
    return label
  }()

  private lazy var challengerTitleLabel: UILabel = {
    let label = UILabel(frame: CGRect.zero)
    label.text = "나의 기록"
    label.font = UIFont.systemFont(ofSize: 13)
    label.textColor = .darkGray
    label.textAlignment = .center
    addSubview(label)
    return label
  }()
  
  private lazy var winnerRecordTimeLabel: UILabel = {
    let label = UILabel(frame: CGRect.zero)
    label.text = "01 : 35 : 29"
    label.font = UIFont(name: "Helvetica Bold Oblique", size: 20)
    label.textColor = .lightGray
    label.textAlignment = .center
    addSubview(label)
    return label
  }()
  
  lazy var challengerRecordTimeLabel: UILabel = {
    let label = UILabel(frame: CGRect.zero)
    label.text = "00 : 00 : 00"
    label.font = UIFont(name: "Helvetica Bold Oblique", size: 20)
    label.textColor = .lightGray
    label.textAlignment = .center
    addSubview(label)
    return label
  }()
  
  @objc func keepTimer() {
    
//    seconds += 1
//
//    if seconds == 60 {
//      minutes += 1
//      seconds = 0
//    }
//
//    if minutes == 60 {
//      hours += 1
//      minutes = 0
//    }
//
//    let secondsString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
//    let minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
//    let hoursString = hours > 9 ? "\(hours)" : "0\(hours)"
    
//    challengerRecordTimeLabel.text =  "\(hoursString) : \(minutesString) : \(secondsString)"
    
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    makeConstraints()
    backgroundColor = .white
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - AutoLayout
  private func makeConstraints() {
    
    winnerTitleLabel.snp.makeConstraints {
      $0.bottom.equalTo(winnerRecordTimeLabel.snp.top).offset(-5)
      $0.centerX.equalToSuperview().multipliedBy(0.5)
      $0.width.equalToSuperview().multipliedBy(0.45)
    }
    
    challengerTitleLabel.snp.makeConstraints {
      $0.bottom.equalTo(winnerRecordTimeLabel.snp.top).offset(-5)
      $0.centerX.equalToSuperview().multipliedBy(1.5)
      $0.width.equalToSuperview().multipliedBy(0.45)
    }
    
    winnerRecordTimeLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview().offset(10)
      $0.centerX.equalTo(winnerTitleLabel.snp.centerX)
      $0.width.equalToSuperview().multipliedBy(0.45)
    }
    
    challengerRecordTimeLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview().offset(10)
      $0.centerX.equalTo(challengerTitleLabel.snp.centerX)
      $0.width.equalToSuperview().multipliedBy(0.45)
    
    }
    
  }
  
}
