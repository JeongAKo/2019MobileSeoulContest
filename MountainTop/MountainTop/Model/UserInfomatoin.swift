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
  
  private var recordDB = ClibmingDatabase()
  
  public var login = LoginUserInfo()
  
  public var moutainList: [MountainInfo] = [] {
    didSet {
      guard !moutainList.isEmpty else { return }
      
      var start = [CLLocation]()
      var finish = [CLLocation]()
      for mountain in moutainList {
        
        start.append(CLLocation(latitude: mountain.infoLat, longitude: mountain.infoLong))
        finish.append(CLLocation(latitude: mountain.mtLat, longitude: mountain.mtLong))
      }
      
      mountainStartLocations = start
      mountainFinishLocations = finish
    }
  }
  
  private var mountainStartLocations: [CLLocation] = []
  private var mountainFinishLocations: [CLLocation] = []
  
  // app의 현재 기록중인지 아닌지 결정하는 변수
  public var recordingID: Int? {
    didSet {
      guard let id = recordingID else {
        recordDB?.updateID(0)
        return print("recordingID is nil")
      }
      
      recordDB?.updateID(id)
      print("didSet recordingID is \(id)")
    }
  }
  
  private init() {}
  
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
  }
  
  public func backgroundApp() {
    
  }
  
  // MARK: - Start mountain challenge
  public func startChallengeMountain(mountainId: Int) -> Date? {
    guard let record = self.recordDB else { return nil }
    guard self.recordingID == nil else { return nil }
    let startDate = Date()
    
    self.recordingID = record.insertRecode(start: startDate.timeIntervalSinceReferenceDate,
                        finish: nil,
                        recode: "",
                        mountainID: mountainId)
    return startDate
  }
  
  public func finishChallengeMountain() -> Double? {
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
    
    let finishDate = Date()
    let startInfo = record.getRecordID(id: challengingID)
    
    
    
//    record.updateRecode(updateID: challengingID,
//                        finish: finishDate.timeIntervalSinceReferenceDate,
//                        record: <#T##String#>)
    
    return nil
  }
  
  public func cancelRecord(id: Int) -> Bool {
    guard let record = self.recordDB else { return false }
    
    record.deleteRecode(delete: id)
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
    guard !mountainStartLocations.isEmpty else { return false }
    
    for location in mountainStartLocations {
      if userLocation.distance(from: location) > 500 { // 500m 이내 의경우 true 반환
        return true
      }
    }
    
    return false
  }
  
  public func nearFinishLocationCheck(userLocation: CLLocation) -> Bool {
    guard !mountainFinishLocations.isEmpty else { return false }
    
    for location in mountainFinishLocations {
      if userLocation.distance(from: location) > 100 { // 100m 이내 의경우 true 반환
        return true
      }
    }
    
    return false
  }
  
}
