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
    button.addTarget(self, action: #selector(didTapCameraButton(_:)), for: .touchUpInside)
    addSubview(button)
    return button
  }()
  
  private lazy var winnerRecordLabel: UILabel = {
    let label = UILabel(frame: CGRect.zero)
    label.text = "1위 기록"
    label.font = UIFont.systemFont(ofSize: 13)
    label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    addSubview(label)
    return label
  }()

  private lazy var challengerRecordLabel: UILabel = {
    let label = UILabel(frame: CGRect.zero)
    label.text = "나의 기록"
    label.font = UIFont.systemFont(ofSize: 13)
    label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
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
  
  var timeStamp: Double!
  
  @objc func didTapCameraButton(_ sender: UIButton) {
    timeStamp = Date().timeIntervalSince1970
    winnerRecordLabel.text = "\(timeStamp)"
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
