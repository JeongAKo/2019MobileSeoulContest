//
//  RecordView.swift
//  MountainTop
//
//  Created by Daisy on 03/09/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import UIKit

class RecordTopView: UIView {
  
  //notification
  private let notiCenter = NotificationCenter.default
  
  
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
    label.text = "00 : 00 : 00"
    label.font = UIFont(name: "Courier", size: 20)
    label.textColor = .lightGray
    label.textAlignment = .center
    addSubview(label)
    return label
  }()
  
  private lazy var challengerRecordTimeLabel: UILabel = {
    let label = UILabel(frame: CGRect.zero)
    label.text = "00 : 00 : 00"
    label.font = UIFont(name: "Courier", size: 20)
    label.textColor = .lightGray
    label.textAlignment = .center
    addSubview(label)
    return label
  }()
  
  @objc func keepTimer() {
    
    seconds += 1
    
    if seconds == 60 {
      minutes += 1
      seconds = 0
    }
    
    if minutes == 60 {
      hours += 1
      minutes = 0
    }
    
    let secondsString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
    let minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
    let hoursString = hours > 9 ? "\(hours)" : "0\(hours)"
    
    challengerRecordTimeLabel.text =  "\(hoursString) : \(minutesString) : \(secondsString)"
    
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
      $0.top.leading.equalTo(safeAreaLayoutGuide).offset(10)
      $0.width.equalToSuperview().multipliedBy(0.5)
    }
    
    challengerTitleLabel.snp.makeConstraints {
      $0.top.trailing.equalTo(safeAreaLayoutGuide).offset(10)
      $0.width.equalToSuperview().multipliedBy(0.5)
      
    }
    
    winnerRecordTimeLabel.snp.makeConstraints {
      $0.top.equalTo(winnerTitleLabel.snp.bottom).offset(10)
      $0.centerX.equalTo(winnerTitleLabel.snp.centerX)
    }
    
    challengerRecordTimeLabel.snp.makeConstraints {
      $0.top.equalTo(challengerTitleLabel.snp.bottom).offset(10)
      $0.centerX.equalTo(challengerTitleLabel.snp.centerX)
    
    }
    
  }
  
}
