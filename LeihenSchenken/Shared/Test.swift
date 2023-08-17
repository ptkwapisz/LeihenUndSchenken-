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
struct emptyView: View {
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
        resultat =  36.0
    }else{
        resultat =  50.0
    } // Ende if/else
    
    return resultat
    
}// Ende func


// Ermitteln von der Erstellungsdatum der Backup-Datei
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


// Diese Funktion prüft ob es lokal genügt Speicher für die Backupdatei gibt
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

// Zweite Zeile bei der Liste der Objekte
func subStringOfTextField(parameter: String) -> String {
    var resultat: String = ""
    
    if UIDevice.current.userInterfaceIdiom == .phone {
        
       resultat = String(parameter.prefix(30))
        
    }else{
        
        resultat = String(parameter.prefix(50))
        
    } // Ende if/else
    
    return resultat
} // Ende func


// Das ist die View für den Full Search in den Objekten
// Aufgerufen in der Tab1 View
struct serchFullTextInObjekten: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    @FocusState var isInputSarchFullTextInObjektenActive: Bool
    
    var body: some View {
        
        TextField("", text: $globaleVariable.searchTextObjekte)
            .focused($isInputSarchFullTextInObjektenActive)
            .frame(height: detailViewBottomToolbarHight() - 36)
            .font(.system(size: 18, weight: .medium))
            .disableAutocorrection (true)
            .submitLabel(.done)
            .foregroundColor(.white)
            .padding()
            .background(Color.gray)
            .cornerRadius(10)
            .onTapGesture {
                isInputSarchFullTextInObjektenActive = true
                
                
            } // Ende onTapGesture
            .padding(.horizontal, 15)
            .padding(.vertical, 5)
            .overlay(
                HStack {
                    if globaleVariable.searchTextObjekte.isEmpty && isInputSarchFullTextInObjektenActive == false{
                        
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)
                    }else{
                        if !globaleVariable.searchTextObjekte.isEmpty {
                            Button(action: {
                                self.globaleVariable.searchTextObjekte = ""
                                
                            }) {
                                
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.white)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                                    .padding(.trailing, 20)
                            }// Button Image
                        }
                    } // Ende if/else
                })
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    if isInputSarchFullTextInObjektenActive {
                        HStack {
                            Text("")
                            Spacer()
                            Button("Abbrechen") {
                                self.globaleVariable.searchTextObjekte = ""
                                isInputSarchFullTextInObjektenActive = false
                                
                            } // Ende Button
                            .buttonStyle(.bordered).foregroundColor(.blue).font(.system(size: 16, weight: .regular))
                           
                        } // Ende HStack
                        .font(.system(size: 16, weight: .regular))
                    }// Ende if
                    
                } // Ende ToolbarItemGroup
            } // Ende toolbar
            
    } // Ende var body
    
} // Ende struct


// Filter für die Fulltextsuche der Objekte
// Diese func war notwändig weil if abfrage in der View nicht zuläsig ist.
// Diese Funktion wird in der Tab1 View aufgerufen
func serchObjectArray(parameter: [ObjectVariable]) -> [ObjectVariable]{
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    var resultat: [ObjectVariable] = []
    
    if globaleVariable.searchTextObjekte.isEmpty {
        resultat = parameter
    }else{
        resultat = parameter.filter {
            $0.gegenstandText.localizedCaseInsensitiveContains(globaleVariable.searchTextObjekte) ||
            $0.allgemeinerText.localizedCaseInsensitiveContains(globaleVariable.searchTextObjekte) ||
            //$0.datum.localizedCaseInsensitiveContains(globaleVariable.searchTextObjekte) ||
            //$0.preisWert.localizedCaseInsensitiveContains(globaleVariable.searchTextObjekte) ||
            $0.gegenstand.localizedCaseInsensitiveContains(globaleVariable.searchTextObjekte) ||
            $0.personVorname.localizedCaseInsensitiveContains(globaleVariable.searchTextObjekte) ||
            $0.personNachname.localizedCaseInsensitiveContains(globaleVariable.searchTextObjekte)
            
        }// Ende par.filter
    }// Ende if/else
    
    return resultat
}// Ende func


// Funktion für die sortierung der Objekte nach Datum
// Par1: Objektvariable mit gefilterten objekten
// Per2: Logischer Operator true: aufsteigend, false: absteigend
func sortiereObjekte(par1: [ObjectVariable], par2: Bool ) -> [ObjectVariable] {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    var resultat: [ObjectVariable] = []
    
    let sortDateFormatter: DateFormatter
    
    sortDateFormatter = DateFormatter()
    sortDateFormatter.locale = .init(identifier: "de")
    sortDateFormatter.dateFormat = "d MMM yyyy"
    sortDateFormatter.dateStyle = .short
    
    if par2 == true {
        
        resultat = par1.sorted {($0.vorgang, sortDateFormatter.date(from: $0.datum)!) < ($1.vorgang, sortDateFormatter.date(from: $1.datum)!)}
        
        //print("Sortiert True")
    }else{
        
        resultat = par1.sorted {($0.vorgang, sortDateFormatter.date(from: $0.datum)!) > ($1.vorgang, sortDateFormatter.date(from: $1.datum)!)}
        
        //print("Sortiert False")
    }// Ende if/else
    
    return resultat
}// Ende func

// Das ist die View für den Full Search in den Objekten
// Aufgerufen in der Tab1 View
struct serchFullTextInAdressbook: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    @FocusState var isInputSarchFullTextInAdressbookActive: Bool
    
    var body: some View {
        
        TextField("", text: $globaleVariable.searchTextAdressBook)
            .focused($isInputSarchFullTextInAdressbookActive)
            .frame(height: detailViewBottomToolbarHight() - 36)
            .font(.system(size: 18, weight: .medium))
            .disableAutocorrection (true)
            .submitLabel(.done)
            .foregroundColor(.white)
            .padding()
            .background(Color.gray)
            .cornerRadius(10)
            .onTapGesture {
                isInputSarchFullTextInAdressbookActive = true
                
            } // Ende onTapGesture
            .padding(.horizontal, 15)
            .padding(.vertical, 5)
            .overlay(
                HStack {
                    if globaleVariable.searchTextAdressBook.isEmpty && isInputSarchFullTextInAdressbookActive == false{
                        
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)
                    }else{
                        if !globaleVariable.searchTextAdressBook.isEmpty {
                            Button(action: {
                                self.globaleVariable.searchTextAdressBook = ""
                                
                            }) {
                                
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.white)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                                    .padding(.trailing, 20)
                            }// Button Image
                        }
                    } // Ende if/else
                })
        
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    if isInputSarchFullTextInAdressbookActive {
                        HStack {
                            Text("")
                            Spacer()
                            Button("Abbrechen") {
                                self.globaleVariable.searchTextAdressBook = ""
                                isInputSarchFullTextInAdressbookActive = false
                                
                            } // Ende Button
                            .buttonStyle(.bordered).foregroundColor(.blue).font(.system(size: 16, weight: .regular))
                            
                        } // Ende HStack
                        .font(.system(size: 16, weight: .regular))
                    }// Ende if
                    
                } // Ende ToolbarItemGroup
            } // Ende toolbar
        
    } // Ende var body
    
} // Ende struct


// Filter für die Fulltextsuche im Adressbook
// Diese func war notwändig weil if abfrage in der View nicht zuläsig ist.
// Diese Funktion wird in dem ShapeViewAddUser aufgerufen
func serchInAdressBookArray(parameter:  [Contact]) ->  [Contact]{
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    var resultat:  [Contact] = []
    
    if globaleVariable.searchTextAdressBook.isEmpty {
        resultat = parameter
    }else{
        resultat = parameter.filter {
            $0.firstName.localizedCaseInsensitiveContains(globaleVariable.searchTextAdressBook) ||
            $0.lastName.localizedCaseInsensitiveContains(globaleVariable.searchTextAdressBook)
            
        }// Ende par.filter
    }// Ende if/else
    
    return resultat
}// Ende func
