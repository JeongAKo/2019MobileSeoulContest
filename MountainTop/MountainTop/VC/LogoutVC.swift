//
//  ViewController.swift
//  MountainTop
//
//  Created by CHANGGUEN YU on 02/09/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import UIKit

class LogoutVC: UIViewController {
  
  private lazy var logoutButton: UIButton = {
    let btn = UIButton(type: .custom)
    btn.setTitleColor(.black, for: .normal)
    btn.setTitle("logout", for: .normal)
    btn.backgroundColor = .yellow
    btn.addTarget(self, action: #selector(kakaoLogout(_:)), for: .touchUpInside)
    view.addSubview(btn)
    return btn
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureView()
    autolayout()
  }
  
  private func autolayout() {
    logoutButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(Metric.margin*5)
      $0.leading.trailing.equalToSuperview().inset(Metric.margin*2)
      $0.height.equalTo(Metric.margin*5)
    }
  }
  
  private func configureView() {
    view.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
  }
  
  @objc private func kakaoLogout(_ sender: UIButton) {
    KOSession.shared()?.logoutAndClose { [weak self] (success, error) -> Void in
      _ = self?.navigationController?.popViewController(animated: true)
    }
  }

}
