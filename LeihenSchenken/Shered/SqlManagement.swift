//
//  SqlManagement.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 12.04.23.
//

import SwiftUI
import Foundation
import SQLite3

func ifDatabaseExist() -> Bool {
    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        print(url)
        if let pathComponent = url.appendingPathComponent("LeiheUndSchenkeDb.db") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) && sqlite3_open(filePath, &db) == SQLITE_OK{
                print("File available")
                return true
            } else {
                print("File not available")
                let erstellenDB = erstellenDatenbankUndTabellen()
                return erstellenDB
            }
        } else {
            print("File path not available")
            return false
        } // Ende if/Else
} // Return func i


func erstellenDatenbankUndTabellen() -> Bool {
    
    let createTableObjekte = "CREATE TABLE IF NOT EXISTS Objekte (perKey TEXT PRIMARY KEY, gegenstand TEXT, gegenstandText TEXT, gegenstandBild TEXT, preisWert TEXT, datum TEXT, vorgang TEXT, personSpitzname TEXT, personVorname TEXT, personNachname TEXT, personSex TEXT, allgemeinerText TEXT)"
    
    let createTablePersonen = "CREATE TABLE IF NOT EXISTS Personen (perKey TEXT PRIMARY KEY, personSpitzname TEXT, personVorname TEXT, personNachname TEXT, personSex TEXT)"
    
    let createTableGegenstaende = "CREATE TABLE IF NOT EXISTS Gegenstaende (perKey TEXT PRIMARY KEY, personSpitzname TEXT, personVorname TEXT, personNachname TEXT, personSex TEXT)"
    
    let fileUrl = try!
    FileManager.default.url(for: .documentDirectory,
                            in: .userDomainMask, appropriateFor: nil, create:
                                false).appendingPathComponent("LeiheUndSchenkeDb.db")
    
    if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
        print("Error opening database")
        sqlite3_close(db)
        db = nil
        return false
    }else{
        print("Datenbank wurde erstellet in")
        print(fileUrl.path)
    } // Ende if
    
    // Bei der Erstellung der Datenbank werden hier die Tabellen kreiert
    if sqlite3_exec(db, createTableObjekte, nil, nil, nil) !=
        SQLITE_OK {
        print("Error creating table Objekte")
        sqlite3_close(db)
        db = nil
        return false
    } else if sqlite3_exec(db, createTablePersonen, nil, nil, nil) !=
                SQLITE_OK {
        print("Error creating table Personen")
        sqlite3_close(db)
        db = nil
        return false
    
    } else if sqlite3_exec(db, createTableGegenstaende, nil, nil, nil) !=
                SQLITE_OK {
        print("Error creating table Gegenstaende")
        sqlite3_close(db)
        db = nil
        return false
        
    }else{
        print("Tabellen wurden erstellt")
        
    } // Ende if
    
    print("Alles ist OK")
    
    return true
    
} // Ende func erstellenDatenbankUndTabellen

func querySQLAbfrage(queryTmp: String) -> Array<String>  {
    
    var resultatArray = [String]()
    var statement: OpaquePointer?
    
    if sqlite3_prepare_v2(db, "\(queryTmp)", -1, &statement, nil) != SQLITE_OK {
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("Error preparing query select: \(errmsg)")
    } // End if

    while sqlite3_step(statement) == SQLITE_ROW {

        if let cString0 = sqlite3_column_text(statement, 0) {
            let name0 = String(cString: cString0)
            // print("Das erste Feld die Summe = \(name0) ", terminator: "")
            if name0 != "" {
               resultatArray.append(name0)
            }
        } else {
            print("Die Werte in der Tabelle Gegenstaende not found")
        } // End if else

    } // Ende while
    
    if sqlite3_finalize(statement) != SQLITE_OK {
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("Error finalizing prepared statement: \(errmsg)")
    } // End if

    statement = nil
    
    // Ende der Abfrage aus der Datenbank
    // print("Ende der Abfrage aus der Datenbank")
    
    
    return resultatArray
    
} // Ende querySQLAbfrage

