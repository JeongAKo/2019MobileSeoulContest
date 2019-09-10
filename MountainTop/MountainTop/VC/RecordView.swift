//
//  RecordView.swift
//  MountainTop
//
//  Created by Daisy on 03/09/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import UIKit

class RecordView: UIView {
  
  var timer = Timer()
  var startTime = TimeInterval()
  var (hours, minutes, seconds) = (0, 0, 0 )
  
  private lazy var cameraButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("사진찍기", for: .normal)
    button.backgroundColor = .blue
    button.addTarget(self, action: #selector(didTapCameraButton(_:)), for: .touchUpInside)
    addSubview(button)
    return button
  }()
  
  private lazy var winnerTitleLabel: UILabel = {
    let label = UILabel(frame: CGRect.zero)
    label.text = "1위 기록"
    label.font = UIFont.systemFont(ofSize: 13)
    label.textColor = .darkGray
    label.textAlignment = .center
    label.backgroundColor = .lightGray
    addSubview(label)
    return label
  }()

  private lazy var challengerTitleLabel: UILabel = {
    let label = UILabel(frame: CGRect.zero)
    label.text = "나의 기록"
    label.font = UIFont.systemFont(ofSize: 13)
    label.textColor = .lightGray
    label.textAlignment = .center
    label.backgroundColor = .yellow

    addSubview(label)
    return label
  }()
  
  private lazy var winnerRecordTimeLabel: UILabel = {
    let label = UILabel(frame: CGRect.zero)
    label.text = "00 : 00 : 00"
    label.font = UIFont(name: "Courier", size: 20)
    label.textColor = .darkGray
    label.textAlignment = .center
    label.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
    addSubview(label)
    return label
  }()
  
  private lazy var challengerRecordTimeLabel: UILabel = {
    let label = UILabel(frame: CGRect.zero)
    label.text = "00 : 00 : 00"
    label.font = UIFont(name: "Courier", size: 20)
    label.textColor = .lightGray
    label.textAlignment = .center
    label.backgroundColor = .green
    
    addSubview(label)
    return label
  }()
  
  
  // MARK: - Action Method
  @objc func didTapCameraButton(_ sender: UIButton) {
    print("📌눌러써여📌")
    
    timer = Timer.scheduledTimer(timeInterval: 1, target:  self , selector: #selector(keepTimer), userInfo: nil, repeats: true)
   
  }
  
  @objc private func keepTimer() {
    
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
    cameraButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(safeAreaLayoutGuide).inset(10)
      $0.width.equalToSuperview().multipliedBy(0.6)
      $0.height.equalTo(cameraButton.snp.width).multipliedBy(0.2)
    }
    
    winnerTitleLabel.snp.makeConstraints {
      $0.top.equalTo(cameraButton.snp.bottom).offset(10)
      $0.width.equalToSuperview().multipliedBy(0.5)
      $0.leading.equalToSuperview()
    }
    
    challengerTitleLabel.snp.makeConstraints {
      $0.top.equalTo(cameraButton.snp.bottom).offset(10)
      $0.width.equalToSuperview().multipliedBy(0.5)
      $0.trailing.equalToSuperview()
      
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
