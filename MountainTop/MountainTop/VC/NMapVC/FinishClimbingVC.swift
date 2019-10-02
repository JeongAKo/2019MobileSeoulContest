//
//  FinishClimbingVC.swift
//  MountainTop
//
//  Created by CHANGGUEN YU on 29/09/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import UIKit

class FinishClimbingVC: UIViewController {

  // MARK: - Property
  private lazy var mainView: UIView = {
    let view = UIView(frame: .zero)
    view.backgroundColor = .white
    self.view.addSubview(view)
    return view
  }()
  
  public lazy var startLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
    label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    self.mainView.addSubview(label)
    return label
  }()
  
  public lazy var FinishLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
    label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    self.mainView.addSubview(label)
    return label
  }()
  
  public lazy var recordLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
    label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
//    label.backgroundColor = .red
    label.textAlignment = .center
    label.text = "등산 완료"
    self.view.addSubview(label)
    return label
  }()
  
  private lazy var imageView: UIImageView = {
    let iv = UIImageView(frame: .zero)
    iv.contentMode = .scaleAspectFit
    iv.backgroundColor = .black
    self.mainView.addSubview(iv)
    return iv
  }()
  
  private lazy var dissmissButton: UIButton = {
    let btn = UIButton(type: .custom)
    btn.setTitle("확인", for: .normal)
    btn.addTarget(self, action: #selector(touchUpDissmiss(_:)), for: .touchUpInside)
    btn.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
    self.mainView.addSubview(btn)
    return btn
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    settupViews()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    print(" self.recordLabel.text viewDidAppear: \( self.recordLabel.text)")
  }

  private func settupViews() {
    self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
    
    self.mainView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(Metric.margin*3)
      $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(Metric.margin)
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(Metric.margin*5)
    }
    
    self.recordLabel.snp.makeConstraints {
//      $0.top.leading.trailing.equalTo(self.mainView).inset(Metric.margin)
      $0.top.equalTo(mainView).offset(Metric.margin)
      $0.leading.trailing.equalTo(mainView)
      $0.bottom.equalTo(imageView.snp.top)
    }
    
    self.imageView.snp.makeConstraints {
      $0.top.equalTo(self.mainView).offset(Metric.margin*4)
      $0.leading.trailing.equalToSuperview().inset(Metric.margin)
    }
    
    self.dissmissButton.snp.makeConstraints {
      $0.top.equalTo(imageView.snp.bottom).offset(Metric.margin)
      $0.leading.trailing.bottom.equalTo(self.mainView)
      $0.height.equalTo(40)
    }
    
    print(" self.recordLabel.text: \( self.recordLabel.text)")
  }
  
  public func setRecordingInfomation(_ record: String, _ image: UIImage) {
//    self.recordLabel.text = record
    self.recordLabel.text = "등산기록: \(record)"
    print(" self.recordLabel.text!!!!!: \( self.recordLabel.text)")
    self.imageView.image = image
  }
  
  @objc private func touchUpDissmiss(_ sender: UIButton) {
    self.presentingViewController?.dismiss(animated: true, completion: nil)
  }
}
