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
//  let moutainDB = MountainDatabase()
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

  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
  }

  // MARK: - Button Action Function
  @objc private func touchDismissVC(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc private func touchStartButton(_ sender: UIButton) {

    let vc = FinishClimbingVC()

    present(vc, animated: true)
//    vc.setRecordingInfomation(record, image)
    
//    var rankerInfo: [RankerInfo] = [
//      RankerInfo(user: "창근1", record: 101, profileUrl: "profile1", image: "image1"),
//      RankerInfo(user: "창근2", record: 102, profileUrl: "profile2", image: "image2"),
//      RankerInfo(user: "창근3", record: 103, profileUrl: "profile3", image: "image3"),
//    ]
//    firebase.postMountainRecordRank(index: 0, rankersInfo: rankerInfo)
//    startTime = UserInfo.def.startChallengeMountain()
  }
  
  @objc private func touchEndButton(_ sender: UIButton) {

    let rankerInfo = RankerInfo(user: UserInfo.def.login.name,
                                record: 50.0,
                                profileUrl: UserInfo.def.login.profile,
                                image: "")
    
    
//    if let newRanking = UserInfo.def.compareMountainRanks(mountainID: 0, nowRecord: rankerInfo) {
//      firebase.postMountainRecordRank(index: 0, rankersInfo: newRanking)
//    }
  }
  
  @objc private func touchGetMoutain(_ sender:UIButton) {
    testFirebase()
//    testDB()
  }
  
  private func testFirebase() {
  }
  
  private func testDB() {
    let data = UserInfo.def.mountainList
    
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

