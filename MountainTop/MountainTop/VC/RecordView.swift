//
//  RecordView.swift
//  MountainTop
//
//  Created by Daisy on 03/09/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import UIKit

class RecordView: UIView {
  
  private lazy var cameraButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("사진찍기", for: .normal)
    button.backgroundColor = .blue
    button.addTarget(self, action: #selector(didTapCameraButton(_:)), for: .touchUpInside)
    addSubview(button)
    return button
  }()
  
  private lazy var winnerRecordLabel: UILabel = {
    let label = UILabel(frame: CGRect.zero)
    label.text = "1위 기록"
    label.font = UIFont.systemFont(ofSize: 13)
    label.textColor = .darkGray
    label.backgroundColor = .lightGray
    addSubview(label)
    return label
  }()

  private lazy var challengerRecordLabel: UILabel = {
    let label = UILabel(frame: CGRect.zero)
    label.text = "나의 기록"
    label.font = UIFont.systemFont(ofSize: 13)
    label.textColor = .darkGray
    label.backgroundColor = .lightGray

    addSubview(label)
    return label
  }()
  
  private lazy var gapValueLabel: UILabel = {
    let label = UILabel(frame: CGRect.zero)
    label.text = "01:32:47"
    label.font = UIFont.systemFont(ofSize: 13)
    label.backgroundColor = .blue
    label.textColor = .white
    label.layer.cornerRadius = 10
    label.clipsToBounds = true
    addSubview(label)
    return label
  }()
  
  var startTime = TimeInterval()
  
  @objc func didTapCameraButton(_ sender: UIButton) {
    print("버튼 눌러따🤩")
   
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    makeConstraints()
    backgroundColor = .white
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func makeConstraints() {
    
    cameraButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(safeAreaLayoutGuide).inset(10)
      $0.width.equalToSuperview().multipliedBy(0.6)
      $0.height.equalTo(cameraButton.snp.width).multipliedBy(0.2)
    }
    
    winnerRecordLabel.snp.makeConstraints {
      $0.top.equalTo(cameraButton.snp.bottom).inset(10)
      $0.leading.bottom.equalToSuperview()
    }
    
    challengerRecordLabel.snp.makeConstraints {
      $0.top.equalTo(cameraButton.snp.bottom).inset(10)
      $0.trailing.bottom.equalToSuperview()
    }
    
  }
  
}
