//
//  UserInfomatoin.swift
//  MountainTop
//
//  Created by CHANGGUEN YU on 16/09/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import Foundation
import CoreLocation

final class UserInfo {
  
  static public let def = UserInfo()
  
  public var recordDB = ClibmingDatabase()
  
  public var login = LoginUserInfo()
  
  public let mountainDB = MountainDatabase()
  
  private let firebase = FDataBaseManager()
  
  public var mountainList: [MountainInfo] = [] {
    didSet {
      guard !mountainList.isEmpty else { return }
      
      var start = [CLLocation]()
      var finish = [CLLocation]()
      for mountain in mountainList {
        
        start.append(CLLocation(latitude: mountain.infoLat, longitude: mountain.infoLong))
        finish.append(CLLocation(latitude: mountain.mtLat, longitude: mountain.mtLong))
      }
      
      mountainStartLocations = start
      mountainFinishLocations = finish
    }
  }
  
  public var climbingRankers: [[RankerInfo]] = [] {
    didSet {
      guard !climbingRankers.isEmpty else { return print("climbingRankers is empty")}
      
      
    }
  }
  
  private var mountainStartLocations: [CLLocation] = []
  private var mountainFinishLocations: [CLLocation] = []
  
  // app의 현재 기록중인지 아닌지 결정하는 변수
  public var recordingID: Int? {
    didSet {
      guard let id = recordingID else {
        self.recordDB?.updateID(0)
        self.startRecordTime = nil
        return print("recordingID is nil")
      }
      
      self.recordDB?.updateID(id)
      
      if let record = self.recordDB?.getRecordID(id: id).first {
        self.startRecordTime = record.start
        print("didSet startRecordTime is \(startRecordTime)")
      }
      print("didSet recordingID is \(id)")
    }
  }
  
  public var startRecordTime: Date?
  
  public var nearMountainID: Int?
  
  private init() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(getMountainList(_:)),
                                           name: .fetchMountainList,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(getClimbingRankerList(_:)),
                                           name: .reload,
                                           object: nil)
    print("UserInfo init")
  }
  
  // MARK: - init MountainList
  @objc public func getMountainList(_ sender: Notification) {
    guard let list = mountainDB?.getMountainInfomations() else {
      return print("getMountainInfomations is nil")
    }
    
    mountainList = list
  }
  
  @objc private func getClimbingRankerList(_ sender: Notification) {
    guard let dict = sender.userInfo as? [String: [[RankerInfo]]],
      let list = dict["moutainRecords"] else { return }
    
    self.climbingRankers = list
  }
  
  // MARK: - checking challenge status
  public func getChallengeRecord() -> Bool {
    return self.recordingID != nil
  }
  
  public func getUserInfomation() {
    /// 사용자 정보 요청하기
    KOSessionTask.userMeTask { (error, me) in
      
      if let error = error as NSError? {
        UIAlertController.showMessage(error.description)
        
      } else if let me = me as KOUserMe? {
        
        guard let id = me.id else { return }
        
        UserInfo.def.login.id = id
        
        if let account = me.account {
          if let email = account.email {
            UserInfo.def.login.email = email
          }
        }
        if let properties = me.properties {
          UserInfo.def.login.name = properties["nickname"] ?? ""
          UserInfo.def.login.profile = properties["thumbnail_image"] ?? ""
        }
      }
    }
  }
  
  public func activeApp() {
    self.recordingID = recordDB?.getUsingID()
    
    if let id = self.recordingID,
      let record = recordDB?.getRecordID(id: id).first{
      self.startRecordTime = record.start
    } else {
      self.startRecordTime = nil
    }
  }
  
  public func backgroundApp() {
    
  }
  
  // MARK: - Start mountain challenge
  public func startChallengeMountain() -> Date? {
    guard let record = self.recordDB else { return nil }
    guard self.recordingID == nil else { return nil }
    guard let moutainID = self.nearMountainID else { return nil}
    let startDate = Date()
    
    self.recordingID = record.insertRecode(start: startDate.timeIntervalSinceReferenceDate,
                        finish: nil,
                        recode: "",
                        mountainID: moutainID)
    
    self.startRecordTime = startDate
    return startDate
  }
  
  // MARK: - finish record
  public func finishChallengeMountain(image: UIImage) -> String? {
    guard let record = self.recordDB
      else {
        print("record is nil")
        return nil
    }
    guard let challengingID = self.recordingID
      else {
        print("finishChallengeMountain: recordingID is nil")
        return nil
    }
    guard let moutainID = self.nearMountainID else { print("self.nearMountainID is nil"); return nil }
    
    let finishDate = Date()
    guard let startInfo = record.getRecordID(id: challengingID).first
      else { print("finishChallengeMountain: getRecord fail"); return nil }
    
    
    let startTime = startInfo.start
    let finishTime = Date()
    
    let gapTimeInterval = finishTime.timeIntervalSinceReferenceDate - startTime.timeIntervalSinceReferenceDate
    let recordTimeString = gapTimeInterval.asTimeString()
    print("gapTimeInterval: \(gapTimeInterval), \(recordTimeString)")
    
    record.updateRecode(updateID: challengingID,
                        finish: finishDate.timeIntervalSinceReferenceDate,
                        record: recordTimeString)
    
    let rankerInfo = RankerInfo(user: UserInfo.def.login.name,
                                record: gapTimeInterval,
                                profileUrl: UserInfo.def.login.profile,
                                image: "")
    
    
    if let newRanking = compareMountainRanks(mountainID: moutainID, nowRecord: rankerInfo, image: image) {
      firebase.postMountainRecordRank(index: moutainID, rankersInfo: newRanking)
    }
    
    // complete
    self.recordingID = nil
    
    return recordTimeString
  }
  
  public func compareMountainRanks(mountainID: Int, nowRecord: RankerInfo, image: UIImage) -> [RankerInfo]? {
    var rankers = climbingRankers[mountainID]
    
    for index in 0..<rankers.count {
      if rankers[index].record < 0 {
        rankers.insert(nowRecord, at: index)
        rankers.remove(at: 3)
        firebase.uploadRankerImage(index: mountainID, rankIndex: index, image: image)
        return rankers
      } else {
        if rankers[index].record > nowRecord.record {
          rankers.insert(nowRecord, at: index)
          rankers.remove(at: 3)
        firebase.uploadRankerImage(index: mountainID, rankIndex: index, image: image)
          return rankers
        }
      }
    }
    return nil
  }
  
  // MARK: - challenge cancel
  public func cancelRecord(id: Int) -> Bool {
    guard let record = self.recordDB else { return false }
    
    record.deleteRecode(delete: id)
    record.updateID(0)
    self.recordingID = nil
    return true
  }
  
  // MARK: - location check functions
  private func locationWithBearing(bearing: Double, distanceMeters: Double, origin: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
    let distRadians = distanceMeters / (6372797.6) // earth radius in meters
    
    let lat1 = origin.latitude * Double.pi / 180.0
    let lon1 = origin.longitude * Double.pi / 180.0
    
    let lat2 = asin(sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(bearing))
    let lon2 = lon1 + atan2(sin(bearing) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2))
    
    return CLLocationCoordinate2D(latitude: lat2 * 180.0 / Double.pi, longitude: lon2 * 180.0 / Double.pi)
  }
  
  public func nearStartLocationCheck(userLocation: CLLocation) -> Bool {
    guard !self.mountainStartLocations.isEmpty else { return false }
    
    for index in 0..<self.mountainStartLocations.count {
      if userLocation.distance(from: self.mountainStartLocations[index]) < 50 { // 50m 이내 의경우 true 반환
        self.nearMountainID = index
        return true
      }
    }
    self.nearMountainID = nil
    return false
  }
  
  public func nearFinishLocationCheck(userLocation: CLLocation) -> Bool {
    guard !self.mountainFinishLocations.isEmpty else { return false }
    
    for index in 0..<self.mountainFinishLocations.count {
      if userLocation.distance(from: self.mountainFinishLocations[index]) < 50 { // 50m 이내 의경우 true 반환
        self.nearMountainID = index
        return true
      }
    }
    self.nearMountainID = nil
    return false
  }
}
