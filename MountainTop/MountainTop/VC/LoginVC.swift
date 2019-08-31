//
//  ViewController.swift
//  MountainTop
//
//  Created by CHANGGUEN YU on 28/08/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import UIKit
import SnapKit

final class LoginVC: UIViewController {
  
  enum Metric {
    static let margin = 15
  }
  
  private lazy var loginButton: UIButton = {
    let btn = UIButton(type: .custom)
    btn.setTitle("Login with Kakao", for: .normal)
    btn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    btn.setTitleColor(.black, for: .normal)
    btn.backgroundColor = .yellow
    btn.layer.cornerRadius = 10
    btn.layer.masksToBounds = true
    view.addSubview(btn)
    return btn
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureView()
    autolayout()
  }
  
  private func autolayout() {
    loginButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(Metric.margin*5)
      $0.leading.trailing.equalToSuperview().inset(Metric.margin*2)
      $0.height.equalTo(Metric.margin*5)
    }
  }
  
  private func configureView() {
    view.backgroundColor = #colorLiteral(red: 0, green: 0.9826139808, blue: 0.7283453941, alpha: 1)
  }
  
}

