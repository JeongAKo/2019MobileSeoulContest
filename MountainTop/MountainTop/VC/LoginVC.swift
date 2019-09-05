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
  
  private lazy var loginButton: UIButton = {
    let btn = UIButton(type: .custom)
    btn.setImage(UIImage(named: "KakaoLogin"), for: .normal)
    btn.layer.cornerRadius = 10
    btn.layer.masksToBounds = true
    btn.addTarget(self, action: #selector(kakaoLogin(_:)), for: .touchUpInside)
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
  
  // MARK: - kakao login button touch
  @objc private func kakaoLogin(_ sender: UIButton) {
    print("kakaoLogin is touched")
    guard let session = KOSession.shared() else {
      UIAlertController.showMessage("KOSession is nil")
      return
    }
    
    if session.isOpen() {
      session.close()
    }
    
    session.open(completionHandler: { (error) -> Void in
      
      if !session.isOpen() {
        if let error = error as NSError? {
          switch error.code {
          case Int(KOErrorCancelled.rawValue):
            break
          default:
            UIAlertController.showMessage(error.description)
          }
        }
      }
      
      /// 사용자 정보 요청하기
      KOSessionTask.userMeTask { (error, me) in
        
        if let error = error as NSError? {
          UIAlertController.showMessage(error.description)
          
        } else if let me = me as KOUserMe? {
          
          guard let id = me.id else { return }
          
          var userInfo = LoginUserInfo()
          userInfo.id = id
          
          if let account = me.account {
            if let email = account.email {
              userInfo.email = email
            }
          }
          if let properties = me.properties {
            userInfo.name = properties["nickname"] ?? ""
            userInfo.profile = properties["thumbnail_image"] ?? ""
          }
        }
        
      }
    })
    
  }
}


