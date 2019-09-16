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
  private let startTime = Expression<Double>("StartTime")
  private let finishTime = Expression<Double>("FinishTime")
  private let record = Expression<String>("Record")
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
      t.column(self.record)
      t.column(self.mountainID)
    }
    
    do {
      try self.DB.run(table)
      print("create success!!")
    } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
      print("constraint failed: \(message), in \(String(describing: statement)), code: \(code)")
    }catch {
      print("error createTable: \(error.localizedDescription)")
    }
  }
  
  public func insertRecode(start: Double, finish: Double?, recode: String, mountainID: Int) {
    print("insert Recode")
    
    let insertRecode = self.userRecode.insert(self.startTime <- start,
                                              self.finishTime <- finish ?? 0.0,
                                              self.record <- record,
                                              self.mountainID <- mountainID
                                              )
    do {
      let id = try self.DB.run(insertRecode)
      print("insert success!! id: \(id)")
    } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
      print("constraint failed: \(message), in \(String(describing: statement)), code: \(code)")
    }catch {
      print("insert error insertRecode: \(error.localizedDescription)")
    }
  }
  
  public func updateRecode(updateID: Int, finish: Double, record: String) {
    print("update Recode")
    
    let updateFilter = self.userRecode.filter(self.id == updateID)
    
    let updateRecode = updateFilter.update([self.finishTime <- finish,
                                            self.record <- record
                                            ])
    do {
      let id = try self.DB.run(updateRecode)
      print("update success id: \(id)")
    }  catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
      print("constraint failed: \(message), in \(String(describing: statement)), code: \(code)")
    }catch {
      print("update updateRecode: \(error.localizedDescription)")
    }
  }
  
  public func deleteRecode(delete: Int) {
    print("delete Recode")
    
    do {
      let deleteId = self.userRecode.filter(self.id == delete)
      try self.DB.run(deleteId.delete())
      print("delete succes!!")
    }  catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
      print("constraint failed: \(message), in \(String(describing: statement)), code: \(code)")
    }catch {
      print("delete error: \(error.localizedDescription)")
    }
  }
  
  public func getTotal() -> Int {
    let count = try? self.DB.scalar(self.userRecode.count)
    print("count: \(String(describing: count))")
    return count ?? 0
  }
  
  public func getAllRecode(complete: @escaping ([UserRecord]) -> Void) {
    do {
      var records = [UserRecord]()
      
      for record in try DB.prepare(userRecode) {
        let id = try record.get(self.id)
        let start = try record.get(self.startTime)
        let finish = try record.get(self.finishTime)
        let climbingRecord = try record.get(self.record)
        let mountainID = try record.get(self.mountainID)
        
        print("id: \(id), start: \(start), finish: \(finish), record: \(climbingRecord), mountainID: \(mountainID)")
        
        records.append(UserRecord(id: id,
                                  start: Date(timeIntervalSinceNow: start),
                                  finish: Date(timeIntervalSinceNow: finish),
                                  recode: climbingRecord,
                                  mountainID: mountainID))
      }
      
      complete(records)
    } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
      print("constraint failed: \(message), in \(String(describing: statement)), code: \(code)")
    } catch {
      print("delete error: \(error.localizedDescription)")
    }
  }
  
  public func getRecordID(id: Int, complete: @escaping ([UserRecord]) -> Void) {
    do {
      var records = [UserRecord]()
      
      let getRow = self.userRecode.filter(self.id == id)
      
      for record in try DB.prepare(getRow) {
        let id = try record.get(self.id)
        let start = try record.get(self.startTime)
        let finish = try record.get(self.finishTime)
        let climbingRecord = try record.get(self.record)
        let mountainID = try record.get(self.mountainID)
        
        records.append(UserRecord(id: id,
                                  start: Date(timeIntervalSinceNow: start),
                                  finish: Date(timeIntervalSinceNow: finish),
                                  recode: climbingRecord,
                                  mountainID: mountainID))
      }
      
      complete(records)
    } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
      print("constraint failed: \(message), in \(String(describing: statement)), code: \(code)")
    } catch {
      print("delete error: \(error.localizedDescription)")
    }
  }
}


//let published_at = Expression<Date>("published_at")
//
//let published = posts.filter(published_at <= Date())
//// SELECT * FROM "posts" WHERE "published_at" <= '2014-11-18T12:45:30.000'
//
//let startDate = Date(timeIntervalSince1970: 0)
//let published = posts.filter(startDate...Date() ~= published_at)
//// SELECT * FROM "posts" WHERE "published_at" BETWEEN '1970-01-01T00:00:00.000' AND '2014-11-18T12:45:30.000'

//DateFunctions.date("now")
//// date('now')
//Date().date
//// date('2007-01-09T09:41:00.000')
//Expression<Date>("date").date
//// date("date")
