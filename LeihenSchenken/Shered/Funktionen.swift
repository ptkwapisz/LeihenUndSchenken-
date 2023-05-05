//
//  Funktionen.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 27.03.23.
//

import Foundation
import SwiftUI

// Das Löschen/Zurücksetzen der UserDefaults wird hier durch zuweisen der Standardswerte vollzogen.
func deleteUserDefaults() {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @ObservedObject var userSettingsDefaults = UserSettingsDefaults.shared
    let colorData = ColorData()
    
    userSettingsDefaults.selectedSprache = 0
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


func addDataGegenstaende() -> [GegenstaendeVariable] {
    
    var resultat: [GegenstaendeVariable] = [GegenstaendeVariable(perKey: "", gegenstand: "", gegenstandTex: "", gegenstandBild: "", preisWert: "", datum: "", vorgang: "", personSpitzname: "", personVorname: "", personNachname: "", personSex: "", allgemeinerText: "")]
    
    resultat.removeAll()
    
    let anzahlDerDatensaetze = querySQLAbfrage(queryTmp: "SELECT count(perKey) FROM Objekte")
    let dbGeagenstaendePerKey = querySQLAbfrage(queryTmp: "SELECT perKey FROM Objekte")
    let dbGeagenstaendeGegenstand = querySQLAbfrage(queryTmp: "SELECT gegenstand FROM Objekte")
    let dbGeagenstaendeGegenstandText = querySQLAbfrage(queryTmp: "SELECT gegenstandText FROM Objekte")
    let dbGeagenstaendeGegenstandBild = querySQLAbfrage(queryTmp: "SELECT gegenstandBild FROM Objekte")
    let dbGeagenstaendePreisWert = querySQLAbfrage(queryTmp: "SELECT preisWert FROM Objekte")
    let dbGeagenstaendeDatum = querySQLAbfrage(queryTmp: "SELECT datum FROM Objekte")
    let dbGeagenstaendeVorgang = querySQLAbfrage(queryTmp: "SELECT vorgang FROM Objekte")
    let dbGeagenstaendePersonSpName = querySQLAbfrage(queryTmp: "SELECT personSpitzname FROM Objekte")
    let dbGeagenstaendePersonVorname = querySQLAbfrage(queryTmp: "SELECT personVorname FROM Objekte")
    let dbGeagenstaendePersonNachname = querySQLAbfrage(queryTmp: "SELECT personNachname FROM Objekte")
    let dbGeagenstaendePersonSex = querySQLAbfrage(queryTmp: "SELECT personSex FROM Objekte")
    let dbGeagenstaendeAllgemeinerText = querySQLAbfrage(queryTmp: "SELECT allgemeinerText FROM Objekte")
    
    for n in 0...Int(anzahlDerDatensaetze[0])!-1 {
        resultat.append(contentsOf: [GegenstaendeVariable(perKey: dbGeagenstaendePerKey[n], gegenstand: dbGeagenstaendeGegenstand[n], gegenstandTex: dbGeagenstaendeGegenstandText[n], gegenstandBild: dbGeagenstaendeGegenstandBild[n], preisWert: dbGeagenstaendePreisWert[n], datum: dbGeagenstaendeDatum[n], vorgang: dbGeagenstaendeVorgang[n], personSpitzname: dbGeagenstaendePersonSpName[n], personVorname: dbGeagenstaendePersonVorname[n], personNachname: dbGeagenstaendePersonNachname[n], personSex: dbGeagenstaendePersonSex[n], allgemeinerText: dbGeagenstaendeAllgemeinerText[n])])
        //print(n)
        
    } // Ende for n
    
return resultat
} // Ende func

func distingtArray(par1: [GegenstaendeVariable], par2: String) -> [String]{
    var resultat: [String] = [""]
    
    // In diesen Array werden verdichtete Werte (distinct) von dem bluKategorie1
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

// Das ist die funktion zum Bereinige der Eingabemaske
func cleanEingabeMaske () {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    globaleVariable.parameterImageString = ""
    globaleVariable.selectedGegenstandInt = 0
    globaleVariable.selectedVorgangInt = 0
    globaleVariable.selectedPersonInt = 0
    globaleVariable.textGegenstandbeschreibung = ""
    globaleVariable.preisWert = ""
    globaleVariable.datum = Date()
    globaleVariable.textAllgemeineNotizen = ""
    
    print("Gelöscht...")
    
} // Ende func
