//
//  MauntainDatabase.swift
//  MountainTop
//
//  Created by CHANGGUEN YU on 18/09/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import Foundation
import SQLite

final class MauntainDatabase {
  
  // MARK: - Property
  private var DB: Connection!
  
  private let mountain = Table("Mountain")
  private let id = Expression<Int>("id")
  private let name = Expression<String>("MountainName")
  private let infoLat = Expression<Double>("infoLatiude")
  private let infoLong = Expression<Double>("infoLongitude")
  private let mtLat = Expression<Double>("MtLatitude")
  private let mtLong = Expression<Double>("MtLongitude")
  private let mtAltitude = Expression<Double>("MtAtitude")
  private let distance = Expression<Double>("distance")
  private let etc = Expression<String>("etc")
  
  private let firebase = FDataBaseManager()
  
  // MARK: - init
  init?() {
    do {
      let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
      
      // 사용자 등산기록 table
      let fileUrl = documentDirectory.appendingPathComponent("MountainInfomation").appendingPathExtension("sqlite3")
      let database = try Connection(fileUrl.path)
      self.DB = database
      
      // table 생성
      self.createTable()
    } catch {
      print("error: \(error)")
      return nil
    }
  }
  
  private func createTable() {
    let table = self.mountain.create { t in
      t.column(self.id, primaryKey: true)
      t.column(self.name)
      t.column(self.infoLat)
      t.column(self.infoLong)
      t.column(self.mtLat)
      t.column(self.mtLong)
      t.column(self.mtAltitude)
      t.column(self.distance)
      t.column(self.etc)
    }
    
    do {
      try self.DB.run(table)
      print("create success!!")
    } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
      print("constraint failed: \(message), in \(String(describing: statement)), code: \(code)")
    }catch {
      print("error createTable: \(error.localizedDescription)")
    }
    
    // test
    self.insertMountainData()
  }
  
  public func insertMountainInfomations(info: MountainInfo) -> Bool {
    
    let insert = self.mountain.insert(self.name <- info.name,
                         self.infoLat <- info.infoLat,
                         self.infoLong <- info.infoLong,
                         self.mtLat <- info.mtLat,
                         self.mtLong <- info.mtLong,
                         self.mtAltitude <- info.mtAtitude,
                         self.distance <- info.climbingDistance,
                         self.etc <- info.etc)
    
    do {
      let id = try self.DB.run(insert)
      print("insert success!! id: \(String(describing: id))")
      
      return true
    } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
      print("constraint failed: \(message), in \(String(describing: statement)), code: \(code)")
    } catch {
      print("insert error insertRecode: \(error.localizedDescription)")
    }
    
    return false
  }
  
  public func deleteAllMountainInfomations() {
    
    let delete = self.mountain.delete()
    
    do {
      try self.DB.run(delete)
      print("delete success!!")
    } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
      print("constraint failed: \(message), in \(String(describing: statement)), code: \(code)")
    } catch {
      print("insert error insertRecode: \(error.localizedDescription)")
    }
  }
  
  public func getMountainInfomations() -> [MountainInfo] {
    var info = [MountainInfo]()
    
    do {
      
      for mt in try DB.prepare(mountain) {
        let id = try mt.get(self.id)
        let name = try mt.get(self.name)
        let infoLat = try mt.get(self.infoLat)
        let infoLong = try mt.get(self.infoLong)
        let mtLat = try mt.get(self.mtLat)
        let mtLong = try mt.get(self.mtLong)
        let mtAtitude = try mt.get(self.mtAltitude)
        let distance = try mt.get(self.distance)
        let etc = try mt.get(self.etc)
        
        info.append(MountainInfo(id: id,
                                 name: name,
                                 infoLat: infoLat,
                                 infoLong: infoLong,
                                 mtLat: mtLat,
                                 mtLong: mtLong,
                                 mtAtitude: mtAtitude,
                                 climbingDistance: distance,
                                 etc: etc))
      }
      
    } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
      print("constraint failed: \(message), in \(String(describing: statement)), code: \(code)")
    } catch {
      print("insert error insertRecode: \(error.localizedDescription)")
    }
    
    return info
  }
  
  // MARK: - download mountain List
  private func insertMountainData() {
    
    firebase.fetchMoutainData { [weak self](result) in
      guard let `self` = self else { return print("self is nil")}
      switch result {
      case .success(let info):
        self.deleteAllMountainInfomations()
        
        for mountain in info {
          guard self.insertMountainInfomations(info: mountain) else { return print("insert mountain information fail")}
        }
      case .failure(let error):
        print("fetchMoutainData error: \(error.localizedDescription)")
        guard let mountainInfos = try? JSONDecoder().decode([MountainInfo].self, from: mountainSampleData)
          else { return print("MountainInfo.self decoding fail")}
        
        for mountain in mountainInfos {
          guard self.insertMountainInfomations(info: mountain) else { return print("insert mountain information fail")}
        }
      }
    }
  }
}
