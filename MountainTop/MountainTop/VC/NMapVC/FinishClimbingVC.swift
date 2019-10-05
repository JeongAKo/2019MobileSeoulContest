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
      view.layer.masksToBounds = true
      view.layer.cornerRadius = 5
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
      iv.layer.masksToBounds = true
      iv.layer.cornerRadius = 5
      return iv
    }()
    
    private lazy var dissmissButton: UIButton = {
      let btn = UIButton(type: .custom)
      btn.setTitle("X", for: .normal)
      btn.addTarget(self, action: #selector(touchUpDissmiss(_:)), for: .touchUpInside)
      btn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .thin)
      btn.backgroundColor = .clear
      btn.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
      btn.layer.borderWidth = 1
      btn.layer.masksToBounds = true
      self.view.addSubview(btn)
      return btn
    }()
    
    override func viewDidLoad() {
      super.viewDidLoad()

      settupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      dissmissButton.layer.cornerRadius = 60 / 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      
    }

    private func settupViews() {
      self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
      
      self.mainView.snp.makeConstraints {
        $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(Metric.margin*3)
        $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(Metric.margin)
        $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(Metric.margin*10)
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
        $0.top.equalTo(mainView.snp.bottom).offset(Metric.margin)
        $0.centerX.equalToSuperview()
        $0.width.height.equalTo(60)
      }
      
    }
    
    public func setRecordingInfomation(_ record: String, _ image: UIImage) {
  //    self.recordLabel.text = record
      self.recordLabel.text = "기록: \(record)"
//      print(" self.recordLabel.text!!!!!: \( self.recordLabel.text)")
      self.imageView.image = image
    }
    
    @objc private func touchUpDissmiss(_ sender: UIButton) {
      self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
