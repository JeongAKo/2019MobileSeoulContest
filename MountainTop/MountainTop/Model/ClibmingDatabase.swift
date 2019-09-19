//
//  ClibmingDatabase.swift
//  MountainTop
//
//  Created by CHANGGUEN YU on 08/09/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import Foundation
import SQLite

final class ClibmingDatabase {

  private var recordDB: Connection!
  private var idDB: Connection!
  
  private let userRecode = Table("UserRecode")
  private let id = Expression<Int>("id")
  private let startTime = Expression<Double>("StartTime")
  private let finishTime = Expression<Double>("FinishTime")
  private let record = Expression<String>("Record")
  private let mountainID = Expression<Int>("idMountain")
  
  private let usingID = Table("StartID")
  private let primeID = Expression<Int>("id")
  private let userID = Expression<Int>("using")
  
  init?() {
    do {
      let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
      
      // 사용자 등산기록 table
      let recordFileUrl = documentDirectory.appendingPathComponent("userRecode").appendingPathExtension("sqlite3")
      let recordDatabase = try Connection(recordFileUrl.path)
      self.recordDB = recordDatabase
      
      // 사용자 등산도전 id 기록 table
      let idFileUrl = documentDirectory.appendingPathComponent("usingID").appendingPathExtension("sqlite3")
      let idDatabase = try Connection(idFileUrl.path)
      self.idDB = idDatabase
      
      // table 생성
      self.createUserRecodeTable()
      self.createUsingIDTable()
    } catch {
      print("error: \(error)")
      return nil
    }
  }
  
  private func createUserRecodeTable() {
    let table = self.userRecode.create { t in
      t.column(self.id, primaryKey: true)
      t.column(self.startTime)
      t.column(self.finishTime)
      t.column(self.record)
      t.column(self.mountainID)
    }
    
    do {
      try self.recordDB.run(table)
      print("create success!!")
    } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
      print("constraint failed: \(message), in \(String(describing: statement)), code: \(code)")
    }catch {
      print("error createTable: \(error.localizedDescription)")
    }
  }
  
  private func createUsingIDTable() {
    let table = self.usingID.create { t in
      t.column(self.primeID, primaryKey: true)
      t.column(self.userID)
    }
    
    do {
      try self.idDB.run(table)
      print("create success!!")
    } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
      print("constraint failed: \(message), in \(String(describing: statement)), code: \(code)")
    }catch {
      print("error createTable: \(error.localizedDescription)")
    }
  }
  
  private func insertID(_ id: Int) {
    print("setId")
    let insertId = self.usingID.insert(self.userID <- id)
    
    do {
      try self.idDB.run(insertId)
    }  catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
      print("constraint failed: \(message), in \(String(describing: statement)), code: \(code)")
    }catch {
      print("insert error insertRecode: \(error.localizedDescription)")
    }
  }
  
  public func updateID(_ id: Int) {
    print("updateId")
    
    if self.getIDTotal() == 0 {
      self.insertID(0)
    }
    
    let updateFilter = self.usingID.filter(self.primeID == 1)
    let updateId = updateFilter.update(self.userID <- id)
    
    do {
      try self.idDB.run(updateId)
      print("update success id: \(id)")
    }  catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
      print("constraint failed: \(message), in \(String(describing: statement)), code: \(code)")
    }catch {
      print("update updateRecode: \(error.localizedDescription)")
    }
  }
  
  public func getUsingID() -> Int? {
    do {
      let getID = self.usingID.filter(self.primeID == 1)
      
      for ids in try idDB.prepare(getID) {
        let id = try ids.get(self.userID)
        return id != 0 ? id : nil
      }
      
    } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
      print("constraint failed: \(message), in \(String(describing: statement)), code: \(code)")
    } catch {
      print("getUsingID error: \(error.localizedDescription)")
    }
    self.updateID(0)
    return nil
  }
  
  private func getIDTotal() -> Int {
    let count = try? self.idDB.scalar(self.usingID.count)
    print("count: \(String(describing: count))")
    return count ?? 0
  }
  
  public func insertRecode(start: Double, finish: Double?, recode: String, mountainID: Int) -> Int {
    print("insert Recode: \(start), \(Date(timeIntervalSinceNow: start as TimeInterval))")
    
    
    let insertRecode = self.userRecode.insert(self.startTime <- start,
                                              self.finishTime <- finish ?? 0.0,
                                              self.record <- record,
                                              self.mountainID <- mountainID
                                              )
    
    do {
      let id = try self.recordDB.run(insertRecode)
      print("insert success!! id: \(String(describing: id))")
      return Int(id)
    } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
      print("constraint failed: \(message), in \(String(describing: statement)), code: \(code)")
    } catch {
      print("insert error insertRecode: \(error.localizedDescription)")
    }
    
    return 0
  }
  
  public func updateRecode(updateID: Int, finish: Double, record: String) {
    print("update Recode: \(finish), \(Date(timeIntervalSinceNow: finish as TimeInterval))")
    
    let updateFilter = self.userRecode.filter(self.id == updateID)
    
    let updateRecode = updateFilter.update([self.finishTime <- finish,
                                            self.record <- record
                                            ])
    do {
      let id = try self.recordDB.run(updateRecode)
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
      try self.recordDB.run(deleteId.delete())
      print("delete succes!!")
    }  catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
      print("constraint failed: \(message), in \(String(describing: statement)), code: \(code)")
    }catch {
      print("delete error: \(error.localizedDescription)")
    }
  }
  
  public func getTotal() -> Int {
    let count = try? self.recordDB.scalar(self.userRecode.count)
    print("count: \(String(describing: count))")
    return count ?? 0
  }
  
  public func getAllRecode(complete: @escaping ([UserRecord]) -> Void) {
    do {
      var records = [UserRecord]()
      
      for record in try recordDB.prepare(userRecode) {
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
      
      for record in try recordDB.prepare(getRow) {
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
