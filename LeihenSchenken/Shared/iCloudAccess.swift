//
//  iCloudAccess.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 30.07.23.
//

import SwiftUI
import Foundation

// Prüfen ob iCloud ist verfügbar
// Wenn User nicht eingelogt ist, dann return ist false
func isICloudContainerAvailable() -> Bool {
    let _ = print("Funktion isICloudContainerAvailable() wird aufgerufen!")
    if let _ = FileManager.default.ubiquityIdentityToken {
        print("iCloud vorhanden")
        return true
        
    } else {
        print("iCloud nicht vorhanden")
        return false
        
    } // Ende if/else
    
} // Ende func

// Ermitteln von der Erstellungsdatum der Backup-Datei
func getfileCreatedDate() -> String {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @ObservedObject var userSettingsDefaults = UserSettingsDefaults.shared
    let _ = print("Funktion getfileCreatedDate() wird aufgerufen!")
    var theCreationDate: String = ""
    var documentsUrl: URL
    
    let fileManager = FileManager.default
    // Wenn iCloud ist ausgeschaltet (nicht verfügbar) wird Datensicherung local gespeichert
    if userSettingsDefaults.iCloudSwitch == false {
        //filePath = "Lokal-"
        documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }else{
        if isICloudContainerAvailable(){
            //filePath = "iCloud-"
            documentsUrl = (fileManager.url(forUbiquityContainerIdentifier:
                                                nil)?.appendingPathComponent("Documents"))!
        }else{
            //filePath = "Lokal-"
            documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            
        } // Ende if/else
    }// Ende if/else
    
    let backupDatabaseURL = documentsUrl.appendingPathComponent("LeiheUndSchenkeDbCopy.db")
    
    if fileManager.fileExists(atPath: backupDatabaseURL.path) {
        //let backupDatabaseURL = documentsUrl.appendingPathComponent("LeiheUndSchenkeDbCopy.db")
        let attributes = try? FileManager.default.attributesOfItem(atPath: backupDatabaseURL.path)
        
        theCreationDate = dateToStringWithTime(parDatum: (attributes?[.creationDate])! as! Date)
    }// Ende if
    
    return theCreationDate
    
} // Ende func

// Diese function verändert die File Attribute (Datum) bei der BackupDatei
// Die Backupdatei wird erstellt durch kopieren der Datenbank. Dadurch werden
// die Attribute der Datenbank übernohmen. Das kann dazufüren, dass das Erstellungsdatum oder
// Modifikationsdatum weit in der Vergangenheit liegen.
func changeFileAttributes(){
    @ObservedObject var userSettingsDefaults = UserSettingsDefaults.shared
    
    let _ = print("Funktion changeFileAttributes() wird aufgerufen!")
    
    let myDateObject = Date()
    
    let fileManager = FileManager.default
    //var filePath: String = ""
    var documentsUrl: URL
    
    // Wenn iClud nicht verfügbar ist wird Datensicherung local gespeichert
    if userSettingsDefaults.iCloudSwitch == false {
        //  filePath = "Lokal - "
        documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }else{
        if isICloudContainerAvailable(){
            //filePath = "iCloud - "
            documentsUrl = (fileManager.url(forUbiquityContainerIdentifier:
                                                nil)?.appendingPathComponent("Documents"))!
            
        }else{
            //  filePath = "Lokal - "
            documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            
        } // Ende if/else
    }// Ende if/else
    
    let backupDatabaseURL = documentsUrl.appendingPathComponent("LeiheUndSchenkeDbCopy.db")
    
    let attributesCreationDate =  [FileAttributeKey.creationDate: myDateObject]
    let attributesModificationDate =  [FileAttributeKey.modificationDate: myDateObject]
    
    do {
        try FileManager.default.setAttributes(attributesModificationDate, ofItemAtPath: backupDatabaseURL.path)
        try FileManager.default.setAttributes(attributesCreationDate, ofItemAtPath: backupDatabaseURL.path)
    }
    catch {
        print(error)
    } // Ende catch
    
    //print("\(filePath)" + "\(attributesCreationDate)")
} // Ende func

func getFlieSitze() -> (numMB: UInt64, strMB: String) {
    let _ = print("Funktion getFlieSitze() wird aufgerufen!")
    
    var numValueMB: UInt64
    var strValueMB: String
    
    var userDatabaseURL: URL
    let fileManager = FileManager.default
    
    let documentsUrlDB = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
    
    userDatabaseURL = documentsUrlDB!.appendingPathComponent("LeiheUndSchenkeDb.db")
    
    numValueMB = userDatabaseURL.fileSize
    strValueMB = userDatabaseURL.fileSizeString
    
    return (numValueMB, strValueMB)
    
} // Ende func getFile....

// Diese Funktion prüft ob es lokal genügt Speicher für die Backupdatei gibt
func ifExistSpaceForLeiheUndSchenkeDbCopy() -> Bool {
    let _ = print("Funktion ifExistSpaceForLeiheUndSchenkeDbCopy() wird aufgerufen!")
    var resultat: Bool = true
    let dbFileSitze = getFlieSitze()
    
    let totalSpeicher = UIDevice.current.totalDiskSpaceInBytes/1000
    let usedSpeicher = UIDevice.current.usedDiskSpaceInBytes/1000
    
    let freeSpeicher = totalSpeicher - usedSpeicher
    
    //print(freeSpeicher)
    
    if dbFileSitze.numMB < freeSpeicher {
        
        resultat = false
        
    }else{
        
        resultat = true
        
    }// Ende if/else
    
    return resultat
    
} // Ende func
