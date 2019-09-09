//
//  UserHistoryModel.swift
//  MountainTop
//
//  Created by CHANGGUEN YU on 08/09/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import Foundation
import SQLite

final class UserHistoryModel {

  private var DB: Connection!
  
  private let userRecode = Table("UserRecode")
  private let id = Expression<Int>("id")
  private let startTime = Expression<String>("StartTime")
  private let finishTime = Expression<String>("FinishTime")
  private let recode = Expression<String>("Recode")
  private let mountainID = Expression<Int>("idMountain")
  
  init?() {
    do {
      let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
      let fileUrl = documentDirectory.appendingPathComponent("userRecode").appendingPathExtension("sqlite3")
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
    let table = self.userRecode.create { t in
      t.column(self.id, primaryKey: true)
      t.column(self.startTime)
      t.column(self.finishTime)
      t.column(self.recode)
      t.column(self.mountainID)
    }
    
    do {
      try self.DB.run(table)
      print("create success!!")
    } catch {
      print("error: \(error.localizedDescription)")
    }
  }
  
  public func insertRecode(start: String, finish: String, recode: String, mountainID: Int) {
    print("insert Recode")
    
    let insertRecode = self.userRecode.insert(self.startTime <- start,
                                              self.finishTime <- finish,
                                              self.recode <- recode,
                                              self.mountainID <- mountainID
                                              )
    do {
      let id = try self.DB.run(insertRecode)
      print("insert success!! id: \(id)")
    } catch {
      print("insert error: \(error.localizedDescription)")
    }
  }
  
  public func updateRecode(finish: String, recode: String) {
    print("update Recode")
    
    let updateRecode = self.userRecode.update(//self.startTime <- startTime,
                                              self.finishTime <- finish,
                                              self.recode <- recode
                                              //self.mountainID <- mountainID
                                              )
    do {
      let id = try self.DB.run(updateRecode)
      print("update success id: \(id)")
    } catch {
      print("update Recode")
    }
  }
  
  public func deleteRecode(delete: Int) {
    print("delete Recode")
    
    do {
      let deleteId = self.userRecode.filter(id == delete)
      try self.DB.run(deleteId.delete())
      print("delete succes!!")
    } catch {
      print("delete error: \(error.localizedDescription)")
    }
  }
}

