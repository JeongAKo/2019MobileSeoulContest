//
//  DBTestVC.swift
//  MountainTop
//
//  Created by CHANGGUEN YU on 16/09/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import UIKit

class DBTestVC: UIViewController {
  
  // MARK: - Property
  let moutainDB = MountainDatabase()
  let firebase = FDataBaseManager()
  
  private lazy var startButton: UIButton = {
    let btn = UIButton(type: .custom)
    btn.setTitle("start", for: .normal)
    btn.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
    btn.addTarget(self, action: #selector(touchStartButton(_:)), for: .touchUpInside)
    self.view.addSubview(btn)
    return btn
  }()
  
  private lazy var endButton: UIButton = {
    let btn = UIButton(type: .custom)
    btn.setTitle("end", for: .normal)
    btn.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
    btn.addTarget(self, action: #selector(touchEndButton(_:)), for: .touchUpInside)
    self.view.addSubview(btn)
    return btn
  }()
  
  private lazy var getMoutain: UIButton = {
    let btn = UIButton(type: .custom)
    btn.setTitle("getMoutains", for: .normal)
    btn.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
    btn.addTarget(self, action: #selector(touchGetMoutain(_:)), for: .touchUpInside)
    self.view.addSubview(btn)
    return btn
  }()
  
  private var startTime: Date?
  private var finishTime: Date?
  
  // MARK: - View life cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    
    startButton.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.width.equalToSuperview().inset(Metric.margin*2)
      $0.height.equalTo(70)
    }
    
    endButton.snp.makeConstraints {
      $0.top.equalTo(startButton.snp.bottom).offset(Metric.margin)
      $0.leading.width.height.equalTo(startButton)
    }
    
    getMoutain.snp.makeConstraints {
      $0.top.equalTo(endButton.snp.bottom).offset(Metric.margin)
      $0.leading.width.height.equalTo(startButton)
    }
    
    firebase.fetchMoutainData { (result) in
      switch result {
      case .success(let info):
        print(info)
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }

  // MARK: - Button Action Function
  @objc private func touchDismissVC(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc private func touchStartButton(_ sender: UIButton) {
    guard UserInfo.def.recordingID == nil else {
      print("UserInfo.def.recordingID isn't nil")
      return
    }
    
    guard startTime == nil else { return print("startTime is not nil")}
    
    startTime = UserInfo.def.startChallengeMountain(mountainId: 1)
    
//    if let record = UserInfo.def.record {
//      UserInfo.def.recordingID = record.insertRecode(start: Date().timeIntervalSinceNow,
//                                                     finish: nil,
//                                                     recode: "00:00:00",
//                                                     mountainID: 1)
//    }
  }
  
  @objc private func touchEndButton(_ sender: UIButton) {
    guard let id = UserInfo.def.recordingID else {
      print("UserInfo.def.recordingID is nil")
      return
    }
    guard let time = startTime else { return print("starttime is nil")}
    
    let finishTime = Date()
    
    let gapTimeInterval = finishTime.timeIntervalSinceReferenceDate - time.timeIntervalSinceReferenceDate
    
    print("gapTimeInterval: \(gapTimeInterval)")
    
//    UserInfo.def.finishChallengeMountain()
//    if let record = UserInfo.def.record {
//      record.updateRecode(updateID: id, finish: Date().timeIntervalSinceNow, record: "???")
//
//      // 초기화 update 후 초기화 필요
//      UserInfo.def.recordingID = nil
//    }
  }
  
  @objc private func touchGetMoutain(_ sender:UIButton) {
    testFirebase()
//    testDB()
  }
  
  private func testFirebase() {
//    let fire = FDataBaseManager()
//    fire.fetchMountainRankers {
//      print("fetchRankers")
//    }
    
    
  }
  
  private func testDB() {
    guard let db = moutainDB else {
      return print("moutainDB is nil")
    }
    
    let data = db.getMountainInfomations()
    
    print("data: \(data)")
    
    let encoder = JSONEncoder()
    
    encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
    
    let jsonData = try? encoder.encode(data)
    
    if let jsonData = jsonData,let jsonString = String(data: jsonData, encoding: .utf8){
      
      print(jsonString)
      
    }

    guard let moutain = try? JSONDecoder().decode([MountainInfo].self, from: mountainSampleData) else { return print("decoding fail")}
    
    print("moutain:\(moutain)")
  }
  
}

