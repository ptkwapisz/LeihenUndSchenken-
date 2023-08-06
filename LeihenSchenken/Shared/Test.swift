//
//  Test.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 20.05.23.
//
import SwiftUI


//import Foundation
//import Contacts

/*
struct EmptyView: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    var breite: CGFloat = 370
    var hoehe: CGFloat = 320
    
    var body: some View {
        ZStack{
            VStack{
                Text("Info zu Tabellen").bold()
                    .font(.title2)
                    .frame(alignment: .center)
                
                Divider().background(Color.black)
                Text("")
                Text("Die Tabellen können nur dann angezeigt werden, wenn mindestens ein Objekt gespeichert wurde. Gehen Sie bitte zu Eingabemaske zurück und geben sie den ersten Gegenstand ein. Bitte vergessen Sie nicht dann Ihre Eingaben zu speichern. Danach können Sie die Tabellen sehen.")
                    .font(.system(size: 18))
                Spacer()
                
            } // Ende Vstack
            //.frame(width: breite, height: hoehe, alignment: .leading)
            .padding(EdgeInsets(top: 40, leading: 20, bottom: 30, trailing: 20))
            .frame(width: breite, height: hoehe, alignment: .leading)
            .background(Color.gray.gradient)
            .cornerRadius(10.0)
            .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 15.0)
        } // Ende ZStack
    } // Ende var body
    
} // Ende struct

// ------------------------------------------
*/

// Höhe des unteren Toolbarstreifes bei den Tabs
func detailViewBottomToolbarHight() -> CGFloat {
    var resultat: CGFloat = 0.0
    
    if UIDevice.current.userInterfaceIdiom == .phone {
        resultat =  34.0
    }else{
        resultat =  50.0
    } // Ende if/else
    
    return resultat
    
}// Ende func


// Diese Erweiterung wird benutzt, um zu ermitteln, wie oft ein bestimmtes Zeichen in einem String vorkommt.
extension String {
    func numberOfOccurrencesOf(string: String) -> Int {
        return self.components(separatedBy:string).count - 1
    } // Ende func
} // Ende extension


// Ermitteln von Erstellungsdatum der Backup-Datei
func getfileCreatedDate() -> String {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @ObservedObject var userSettingsDefaults = UserSettingsDefaults.shared
    
    var theCreationDate: String = ""
    var documentsUrl: URL
  
    
    let fileManager = FileManager.default
    // Wenn iCloud ist ausgeschaltet (nicht verfügbar) ist wird Datensicherung local gespeichert
    if userSettingsDefaults.iCloudSwitch == false {
        //filePath = "Lokal-"
        documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }else{
        //filePath = "iCloud-"
        documentsUrl = (fileManager.url(forUbiquityContainerIdentifier:
                                            nil)?.appendingPathComponent("Documents"))!
    }// Ende if/else
    
    let backupDatabaseURL = documentsUrl.appendingPathComponent("LeiheUndSchenkeDbCopy.db")
    
    
    if fileManager.fileExists(atPath: backupDatabaseURL.path) {
        //let backupDatabaseURL = documentsUrl.appendingPathComponent("LeiheUndSchenkeDbCopy.db")
        let attributes = try? FileManager.default.attributesOfItem(atPath: backupDatabaseURL.path)
        
        theCreationDate = dateToString(parDatum: (attributes?[.creationDate])! as! Date)
    }// Ende if

    return theCreationDate
    
} // Ende func


// Diese function verändert die File Attribute (Datum) bei der BackupDatei
// Die Backupdatei wird erstellt durch kopieren der Datenbank. Dadurch werden
// die Attribute der Datenbank übernohmen. Das kann dazufüren, dass das Erstellungsdatum oder
// Modifikationsdatum weit in der Vergangenheit liegen.
func changeFileAttributes(){
    @ObservedObject var userSettingsDefaults = UserSettingsDefaults.shared
    //let calendar = Calendar(identifier: .gregorian)
    
    let myDateObject = Date()
    
    let fileManager = FileManager.default
    //var filePath: String = ""
    var documentsUrl: URL
    
    // Wenn iClud nicht verfügbar ist wird Datensicherung local gespeichert
    if userSettingsDefaults.iCloudSwitch == false {
      //  filePath = "Lokal - "
        documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }else{
        documentsUrl = (fileManager.url(forUbiquityContainerIdentifier:
                                            nil)?.appendingPathComponent("Documents"))!
        //filePath = "iCloud - "
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

/*
func moveDbBackup() {
    @ObservedObject var userSettingsDefaults = UserSettingsDefaults.shared
    //let fileManager = FileManager.default
    
    if userSettingsDefaults.iCloudSwitch == true {
       print("iCloud eingeschaltet")
        
    }else{
        print("iCloud ausgeschaltet")
        
    }// Ende if/else
    
    
    
} // Ende func

*/

// Das ist die extension für erfassung des lokalen Speicherplatzes
// Die benutzung:
// print(UIDevice.current.freeDiskSpaceInGB)
// print(UIDevice.current.usedDiskSpaceInGB)
extension UIDevice {
    func MBFormatter(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = ByteCountFormatter.Units.useMB
        formatter.countStyle = ByteCountFormatter.CountStyle.decimal
        formatter.includesUnit = false
        return formatter.string(fromByteCount: bytes) as String
    } // Ende func
    
    //MARK: Get String Value
    var totalDiskSpaceInGB:String {
        return ByteCountFormatter.string(fromByteCount: totalDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
    } // Ende var
    
    var freeDiskSpaceInGB:String {
        return ByteCountFormatter.string(fromByteCount: freeDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
    } // Ende var
    
    var usedDiskSpaceInGB:String {
        return ByteCountFormatter.string(fromByteCount: usedDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
    } // Ende var
    
    var totalDiskSpaceInMB:String {
        return MBFormatter(totalDiskSpaceInBytes)
    } // Ende var
    
    var freeDiskSpaceInMB:String {
        return MBFormatter(freeDiskSpaceInBytes)
    } // Ende var
    
    var usedDiskSpaceInMB:String {
        return MBFormatter(usedDiskSpaceInBytes)
    } // Ende var
    
    //MARK: Get raw value
    var totalDiskSpaceInBytes:Int64 {
        guard let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
              let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value else { return 0 }
        return space
    } // Ende var
    
    var freeDiskSpaceInBytes:Int64 {
        /*
        if #available(iOS 11.0, *) {
            if let space = try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage {
                return space // ?? 0
            } else {
                return 0
            } // Ende if/else
        } else {
         */
            if let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
               let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value {
                return freeSpace
            } else {
                return 0
            }// Ende if/else
        //} // Ende if/else
    } // Ende var
    
    var usedDiskSpaceInBytes:Int64 {
        return totalDiskSpaceInBytes - freeDiskSpaceInBytes
    } // Ende var
    
} // Ende extension

func getFlieSitze() -> (numMB: UInt64, strMB: String) {
   
    var numValueMB: UInt64
    var strValueMB: String
    
    var userDatabaseURL: URL
    let fileManager = FileManager.default
    
    let documentsUrlDB = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
    
    userDatabaseURL = documentsUrlDB!.appendingPathComponent("LeiheUndSchenkeDb.db")
    
    //print("file size = \(userDatabaseURL.fileSize), \(userDatabaseURL.fileSizeString)")
    
    numValueMB = userDatabaseURL.fileSize
    strValueMB = userDatabaseURL.fileSizeString
    
    return (numValueMB, strValueMB)
    
    
} // Ende func getFile....


// Das ist die Extension für die getFileSitze funktion
extension URL {
    var attributes: [FileAttributeKey : Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        } // Ende catch
        return nil
    } // Ende var
    
    var fileSize: UInt64 {
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    } // Ende var
    
    var fileSizeString: String {
        return ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
    }// Ende var
    
    var creationDate: Date? {
        return attributes?[.creationDate] as? Date
    } // Ende var
} // Ende extension URL

// Diese Funktion prüft ob es lokal genügt Speicher für die Backupdatei Gibt
func ifExistSpaceForLeiheUndSchenkeDbCopy() -> Bool {
    var resultat: Bool = true
    let dbFileSitze = getFlieSitze()
    
    //print(dbFileSitze.numMB)
    //print(dbFileSitze.strMB)
    
    //print(UIDevice.current.totalDiskSpaceInMB)
    //print(UIDevice.current.freeDiskSpaceInMB)
    //print(UIDevice.current.usedDiskSpaceInMB)
    
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
