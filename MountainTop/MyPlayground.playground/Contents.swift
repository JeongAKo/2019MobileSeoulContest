import UIKit
import SQLite3




func openDatabase() -> OpaquePointer? {
  var db: OpaquePointer? = nil
  if sqlite3_open(part1DbPath, &db) == SQLITE_OK {
    print("Successfully opened connection to database at \(part1DbPath)")
    return db
  } else {
    print("Unable to open database. Verify that you created the directory described " +
      "in the Getting Started section.")
    PlaygroundPage.current.finishExecution()
  }
  
}

let db = openDatabase()
