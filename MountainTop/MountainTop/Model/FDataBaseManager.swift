//
//  FDataBaseManager.swift
//  MountainTop
//
//  Created by CHANGGUEN YU on 20/09/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

extension Notification.Name {
  static let reload = Notification.Name("changeRecord")
}

final class FDataBaseManager {
  
  private var ref: DatabaseReference = {
    return Database.database().reference()
  }()
  
  private var remoteConfig: RemoteConfig = {
    let config = RemoteConfig.remoteConfig()
    let settings = RemoteConfigSettings()
    config.configSettings = settings
    return config
  }()
  
  private var obseverHandle: UInt?
  
  init() {
    self.fetchMountainRankers()
  }
  
  deinit {
    if let handle = obseverHandle {
      ref.child("Ranker").removeObserver(withHandle: handle)
    }
  }
  
  public func fetchMoutainData(completionHandler: @escaping ((Result<[MountainInfo],DbError>) -> Void)) {
      let expirationDuration = 0  // 캐쉬 data 사용 시간
      remoteConfig
        .fetch(withExpirationDuration: TimeInterval(expirationDuration)) { [weak self] (status, error) in
          if status == .success {
            self?.remoteConfig.activateFetched()
            print("success")
            print(self?.remoteConfig["MountainList"].stringValue)
            guard let jsonString = self?.remoteConfig["MountainList"].stringValue,
              let data = jsonString.data(using: .utf8) else { return print("remoteConfig fail")}
            
  //          print("jsonString: \(jsonString)")
  //          print("data: \(data)")
            
            guard let mountainList = try? JSONDecoder().decode([MountainInfo].self, from: data)
              else { return print("decode fail")}
            
            completionHandler(.success(mountainList))
            print("mountainList: \(mountainList))")
          } else {
            print("Config not fetched error: \(error?.localizedDescription ?? ""))")
            completionHandler(.failure(.firebase))
          }
      }
    }
  
  private func fetchMountainRankers()  {
    
    ref.child("Ranker").observe(.value, with: { (snapshot) in
      guard let values = snapshot.value as? [[String: Any]] else { return print("values is nil")}
      var moutainRecord = [RankerInfo]()
      
      for info in values {
        if let userName = info["user"] as? String,
          let profile = info["profileURL"] as? String,
          let record = info["record"] as? Double,
          let image = info["image"] as? String {
          
          moutainRecord.append(RankerInfo(user: userName,
                                          record: record,
                                          profileUrl: profile,
                                          image: image))
        }
      }
      
      NotificationCenter.default.post(name: .reload, object: nil, userInfo: ["moutainRecords": moutainRecord])
      print("moutainRecord: \(moutainRecord)")
    }) { (error) in
      print("error: \(error.localizedDescription)")
    }
//
//    ref.child("Ranker").observeSingleEvent(of: .value, with: { (snapshot) in
//
//      guard let values = snapshot.value as? [[String: Any]] else { return print("values is nil")}
//      var moutainRecord = [RankerInfo]()
//
//      for info in values {
//        if let userName = info["user"] as? String,
//          let profile = info["profileURL"] as? String,
//          let record = info["record"] as? Double,
//          let image = info["image"] as? String {
//
//          moutainRecord.append(RankerInfo(user: userName,
//                                          record: record,
//                                          profileUrl: profile,
//                                          image: image))
//        }
//      }
//    }) { (error) in
//      print(error.localizedDescription)
//    }
//
  }
  
}
