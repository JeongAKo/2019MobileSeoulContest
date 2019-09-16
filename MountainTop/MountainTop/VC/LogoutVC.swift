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
  
  private lazy var add: UIButton = {
    let btn = UIButton(type: .custom)
    btn.setTitle("Add", for: .normal)
    btn.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
    btn.addTarget(self, action: #selector(testTouchUpButton(_:)), for: .touchUpInside)
    view.addSubview(btn)
    return btn
  }()
  
  private lazy var update: UIButton = {
    let btn = UIButton(type: .custom)
    btn.setTitle("Update", for: .normal)
    btn.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
    btn.addTarget(self, action: #selector(testTouchUpButton(_:)), for: .touchUpInside)
    view.addSubview(btn)
    return btn
  }()
  
  private lazy var delete: UIButton = {
    let btn = UIButton(type: .custom)
    btn.setTitle("Delete", for: .normal)
    btn.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
    btn.addTarget(self, action: #selector(testTouchUpButton(_:)), for: .touchUpInside)
    view.addSubview(btn)
    return btn
  }()
  
  private var db: UserHistoryModel? = nil

  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureView()
    autolayout()
    
    db = UserHistoryModel()
    if db == nil {
      print("db is nil")
    } else {
      print("create is success")
    }
    
    print("uuid: \(String(describing: UIDevice.current.identifierForVendor?.uuidString))")
//    import AdSupport
//    print("uuid: \(String(describing: ASIdentifierManager.shared().advertisingIdentifier.uuidString))") // 광고 식별자
  }
  
  private func autolayout() {
    logoutButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(Metric.margin*5)
      $0.leading.trailing.equalToSuperview().inset(Metric.margin*2)
      $0.height.equalTo(Metric.margin*5)
    }
    
    add.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(Metric.margin)
      $0.leading.trailing.equalToSuperview().inset(Metric.margin)
      $0.height.equalTo(Metric.margin*3)
    }
    
    update.snp.makeConstraints {
      $0.top.equalTo(add.snp.bottom).offset(Metric.margin)
      $0.leading.trailing.equalToSuperview().inset(Metric.margin)
      $0.height.equalTo(Metric.margin*3)
    }
    
    delete.snp.makeConstraints {
      $0.top.equalTo(update.snp.bottom).offset(Metric.margin)
      $0.leading.trailing.equalToSuperview().inset(Metric.margin)
      $0.height.equalTo(Metric.margin*3)
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
  
  @objc private func testTouchUpButton(_ sender: UIButton) {
    
    switch sender {
    case add:
      db?.insertRecode(start: Date().timeIntervalSinceNow, finish: nil, recode: "0", mountainID: 1)
      let _ = db?.getTotal()
    case update:
      let now = Date()
      let format = DateFormatter()
      format.dateFormat = "MM.dd."
      db?.updateRecode(updateID: 1, finish: now.timeIntervalSinceNow, record: "updateRecord")
      let _ = db?.getTotal()
      getRecordID()
    case delete:
      db?.deleteRecode(delete: 1)
      let _ = db?.getTotal()
    default:
      
      break
    }
    
  }
  
  private func getAllRecord() {
    db?.getAllRecode(complete: { (records) in
      print("records.count: \(records.count)")
    })
  }
  
  private func getRecordID() {
    db?.getRecordID(id: db?.getTotal() ?? 1, complete: { (record) in
      print("record: \(record)")
    })
  }
}
