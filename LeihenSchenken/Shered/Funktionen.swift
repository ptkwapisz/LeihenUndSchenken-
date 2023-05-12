//
//  Funktionen.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 27.03.23.
//

import Foundation
import SwiftUI
import SQLite3

// Das Löschen/Zurücksetzen der UserDefaults wird hier durch zuweisen der Standardswerte vollzogen.
func deleteUserDefaults() {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    //@ObservedObject var userSettingsDefaults = UserSettingsDefaults.shared
    let colorData = ColorData()
    
    //userSettingsDefaults.selectedSprache = 0
    globaleVariable.farbenEbene0 = Color.blue
    globaleVariable.farbenEbene1 = Color.green
    colorData.saveColor(color0: globaleVariable.farbenEbene0, color1: globaleVariable.farbenEbene1)
    refreshAllViews()
    
} // Ende func

// Diese Funktion ist notwändig, weil die UserDefaults bei Veränderung des Wertes
// die Views nicht nachzeichnen. Bei der Änderung der Werte der GlobalenVariablen werden
// die Views neu gezeichnet.
func refreshAllViews() {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    if globaleVariable.refreshViews == true {
        globaleVariable.refreshViews = false
    }else{
        globaleVariable.refreshViews = true
    } // Ende if/else
} // Ende func

// Diese Funktion erstellt aus Datum einen String mit Datum und Zeit mit Secunden im Format "20230427201567"
// Dieser einmaliger String wird als perKey in der SQLite DB Gespeichert.
func erstellePerKey(par1: String) -> String {
    
    let removeCharacters: Set<Character> = [" ", ",", ":"]
    var result = par1
    
    result.removeAll(where: { removeCharacters.contains($0) } )
    
    let nowDate = Date()
    let nowSeconds = (Calendar.current.component(.second, from: nowDate))
    result = result + String(nowSeconds)
    
return result
    
} // Ende func

/*
func addDataGegenstaende() -> [GegenstaendeVariable] {
    
    var resultat: [GegenstaendeVariable] = [GegenstaendeVariable(perKey: "", gegenstand: "", gegenstandTex: "", gegenstandBild: "", preisWert: "", datum: "", vorgang: "", personVorname: "", personNachname: "", personSex: "", allgemeinerText: "")]
    
    let anzahlDerDatenSaetze = querySQLAbfrageArray(queryTmp: "SELECT count(perKey) FROM Objekte")
    let dbGeagenstaendePerKey = querySQLAbfrageArray(queryTmp: "SELECT perKey FROM Objekte")
    let dbGeagenstaendeGegenstand = querySQLAbfrageArray(queryTmp: "SELECT gegenstand FROM Objekte")
    let dbGeagenstaendeGegenstandText = querySQLAbfrageArray(queryTmp: "SELECT gegenstandText FROM Objekte")
    let dbGeagenstaendeGegenstandBild = querySQLAbfrageArray(queryTmp: "SELECT gegenstandBild FROM Objekte")
    let dbGeagenstaendePreisWert = querySQLAbfrageArray(queryTmp: "SELECT preisWert FROM Objekte")
    let dbGeagenstaendeDatum = querySQLAbfrageArray(queryTmp: "SELECT datum FROM Objekte")
    let dbGeagenstaendeVorgang = querySQLAbfrageArray(queryTmp: "SELECT vorgang FROM Objekte")
    //let dbGeagenstaendePersonSpName = querySQLAbfrage(queryTmp: "SELECT personSpitzname FROM Objekte")
    let dbGeagenstaendePersonVorname = querySQLAbfrageArray(queryTmp: "SELECT personVorname FROM Objekte")
    let dbGeagenstaendePersonNachname = querySQLAbfrageArray(queryTmp: "SELECT personNachname FROM Objekte")
    let dbGeagenstaendePersonSex = querySQLAbfrageArray(queryTmp: "SELECT personSex FROM Objekte")
    let dbGeagenstaendeAllgemeinerText = querySQLAbfrageArray(queryTmp: "SELECT allgemeinerText FROM Objekte")
    
    
    if Int(anzahlDerDatenSaetze[0])! > 0 {
        resultat.removeAll()
        for n in 0...Int(anzahlDerDatenSaetze[0])!-1 {
            resultat.append(contentsOf: [GegenstaendeVariable(perKey: dbGeagenstaendePerKey[n], gegenstand: dbGeagenstaendeGegenstand[n], gegenstandTex: dbGeagenstaendeGegenstandText[n], gegenstandBild: dbGeagenstaendeGegenstandBild[n], preisWert: dbGeagenstaendePreisWert[n], datum: dbGeagenstaendeDatum[n], vorgang: dbGeagenstaendeVorgang[n], personVorname: dbGeagenstaendePersonVorname[n], personNachname: dbGeagenstaendePersonNachname[n], personSex: dbGeagenstaendePersonSex[n], allgemeinerText: dbGeagenstaendeAllgemeinerText[n])])
            //print(n)
        } // Ende for n
    } // Ende if
return resultat
} // Ende func
*/

// In dieser Funktion werden verdichtete Werte aus dem Array (distinct) erstellt
// Erster Parameter ist Array
// Zweiter Parameter ist String für die Verdichtung
func distingtArray(par1: [GegenstaendeVariable], par2: String) -> [String]{
    
    var resultat: [String] = [""]
    
    switch par2 {
        
    case "Vorgang" :
        resultat = Array(Set(par1.compactMap { $0.vorgang }))
        
    case "Gegenstand" :
        
         resultat = Array(Set(par1.compactMap { $0.gegenstand }))
    
    default:
        print("Default")
    } // Ende Switch
    
    return resultat
} // Ende func

// Das ist die funktion zum Bereinigen der Eingabemaske
func cleanEingabeMaske () {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    globaleVariable.parameterImageString = "Kein Bild"
    globaleVariable.selectedGegenstandInt = 0
    globaleVariable.selectedVorgangInt = 0
    globaleVariable.selectedPersonInt = 0
    globaleVariable.textGegenstandbeschreibung = ""
    globaleVariable.preisWert = "0.00"
    globaleVariable.datum = Date()
    globaleVariable.textAllgemeineNotizen = ""
    globaleVariable.selectedPersonVariable.removeAll()
    globaleVariable.parameterPerson.removeAll()
    globaleVariable.parameterPerson = personenArray()
    
    print("Gelöscht...")
    
} // Ende func


// Aus der Datenbanktabelle Personen werden die Personendaten geladen, die bei Angabemaske angezeigt werden.
// Dabei wird das Format "Name, Vorname" erstellt.
func personenArray() -> [String] {
    var resultat: [String] = [""]
    
    var tempPicker: [String]
    var tempNachUndVor: String
    
    tempPicker = querySQLAbfrageArray(queryTmp: "Select personPicker from Personen")
    
    if tempPicker.count > 0 {
        for n in 0...tempPicker.count - 1 {
            
            tempNachUndVor = tempPicker[n]
            
            resultat.append("\(tempNachUndVor)")
            
        } // Ende for n
    } // Ende if tempNachname
    
    resultat[0] = "Neue Person"
    
    return resultat.unique()
} // Ende func


// Diese Funktion speichert die Personendaten in die Datenbank in die Tabelle Personen
// par1 = Vorname
// par2 = Nachname
// par3 = Geschlecht
func personenDatenInDatenbankSchreiben(par1: String, par2: String, par3: String){
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    let perKeyFormatter: DateFormatter
    perKeyFormatter = DateFormatter()
    perKeyFormatter.dateFormat = "y MM dd, HH:mm"
    
    let perKey = erstellePerKey(par1: perKeyFormatter.string(from: globaleVariable.datum))
    let personPickerTemp: String = par2 + ", " + par1
    
    let insertDataToDatenbank = "INSERT INTO Personen(perKey, personPicker, personVorname, personNachname, personSex) VALUES('\(perKey)', '\(personPickerTemp)', '\(par1)', '\(par2)', '\(par3)')"

    if sqlite3_exec(db, insertDataToDatenbank, nil, nil, nil) !=
       SQLITE_OK {
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("error -->: \(errmsg)")
        print("Personendaten wurden nicht hinzugefügt")
    } // End if

    globaleVariable.parameterPerson.removeAll()
    globaleVariable.parameterPerson = personenArray()
    print("Personendaten wurden in die Tabelle gespeichert...")
    
} // Ende func

// Diese Funktion speichert die Personendaten in die Variable
// par1 = Vorname
// par2 = Nachname
// par3 = Geschlecht
func personenDatenInVariableSchreiben(par1: String, par2: String, par3: String){
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    globaleVariable.selectedPersonVariable.removeAll()
    globaleVariable.selectedPersonVariable.append(contentsOf: [PersonVariable(personVorname: "\(par1)", personNachname: "\(par2)", personSex: "\(par3)")])
    
    print("Personendaten wurden in die Variable gespeichert...")
    
} // Ende func

// Diese Funktion speichert die gegenstaende in die Datenbank in die Tabelle Gegenstaende
func gegenstaendenInDatenbankSchreiben(par1: String, par2: String) {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    let perKeyFormatter: DateFormatter
    perKeyFormatter = DateFormatter()
    perKeyFormatter.dateFormat = "y MM dd, HH:mm"
    
    let perKey = erstellePerKey(par1: perKeyFormatter.string(from: globaleVariable.datum))
    
    let insertDataToDatenbank = "INSERT INTO gegenstaende(perKey, gegenstandName) VALUES('\(perKey)','\(par1)')"

    if sqlite3_exec(db, insertDataToDatenbank, nil, nil, nil) !=
       SQLITE_OK {
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("error -->: \(errmsg)")
        print("Personendaten wurden nicht hinzugefügt")
    } // End if

    
    print("Personendaten wurden gespeichert...")
    
    
} // Ende func
