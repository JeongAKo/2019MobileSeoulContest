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
  
  private var storage = Storage.storage().reference()
  
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
      guard let values = snapshot.value as? [[[String: Any]]] else { return print("values is nil")}
      var moutainRecord = [[RankerInfo]]()
      
      for infoArray in values {
        print("infoArray: \(infoArray)")
        var recordRank = [RankerInfo]()
        for info in infoArray {
          if let userName = info["user"] as? String,
            let profile = info["profileURL"] as? String,
            let record = info["record"] as? Double,
            let image = info["image"] as? String {
  
            recordRank.append(RankerInfo(user: userName,
                                            record: record,
                                            profileUrl: profile,
                                            image: image))
          }
        }
        moutainRecord.append(recordRank)
        recordRank.removeAll()
      }
      
      NotificationCenter.default.post(name: .reload, object: nil, userInfo: ["moutainRecords": moutainRecord])
      print("moutainRecord: \(moutainRecord)")
    }) { (error) in
      print("error: \(error.localizedDescription)")
    }
  }
  
  public func postMountainRecordRank(index: Int, rankersInfo: [RankerInfo]) {
    
    var rank: [AnyHashable: Any] = [:]
    
    for index in 0..<rankersInfo.count {
      rank["/\(index)/user"] = rankersInfo[index].user
      rank["/\(index)/record"] = rankersInfo[index].record
      rank["/\(index)/profileURL"] = rankersInfo[index].profileUrl
      rank["/\(index)/image"] = rankersInfo[index].image
    }

    ref.child("Ranker").child("\(index)").updateChildValues(rank)//updateChildValues(rankInfo)
  }
  
  public func uploadRankerImage(index: Int, rankIndex: Int, image: UIImage) {
    guard let imageData = image.jpegData(compressionQuality: 0.7) else { return print("")}
    let upload = storage.child("Ranker").child("/images").child("\(index)").child("\(rankIndex).jpg")
    
    upload.putData(imageData, metadata: nil) { (metaData, error) in
      guard let error = error else { return  }
      if let meta = metaData {
        print("upload Date: \(String(describing: meta.updated))")
      } else {
        print("error: \(error.localizedDescription)")
      }
    }
  }
  
  public func downloadRankerImage(index: Int, rankIndex: Int, completionHandler: @escaping ((Data) -> Void)) {
    let download = storage.child("Ranker").child("/images").child("\(index)").child("\(rankIndex).jpg")
    
    download.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
      guard error != nil else {
        print("error: \(String(describing: error?.localizedDescription))")
        return
      }
      
      guard let data = data else {
        print("downloadRankerImage: is nil ")
        return
      }
      
      completionHandler(data)
    }
  }
  
}
