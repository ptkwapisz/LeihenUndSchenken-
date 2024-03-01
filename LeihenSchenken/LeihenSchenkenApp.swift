//
//  LeihenSchenkenApp.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 27.03.23.
//


import SwiftUI
import SQLite3

// Zugriff auf die SQLite Datenbank
var db: OpaquePointer?
// Diese Variable definier die Anzahl der Objekte, die in Standardversion möglich sind
var numberOfObjectsFree: Int = 100
// Diese Variable hält die Anzahl aller Objekte in der Datenbank in der Tabbelle Objekte
var numberOfObjects: Int = anzahlDerDatensaetze(tableName: "Objekte")
// Bei Frames (View-Breiten) wird die Breite um den Faktor multipliziert
var widthFaktorEbene1: Double = 0.97
// Anpassung der View-Höhe in der Ebene 0
var heightFaktorEbene0: Double = 0.99
// Anpassung der View-Höhe in der Ebene 1
var heightFaktorEbene1: Double = 0.97
// Arry zur Auswahl bei Personen
var parameterPersonSex: [String] =  ["Frau", "Mann", "Divers"]
// Arry zur Auswahl der Vorgänge
var parameterVorgang: [String] =  ["Verleihen", "Verschenken", "Bekommen", "Aufbewahren", "Geschenkidee"]
// The Number of selected TabView
var navigationTabView: Int = 1
// Selektierter Gegenstand in Tab4
var selectedGegenstandTab2: String = ""
// Selektierte Person in Tab3
var selectedPersonPickerTab3: String = ""


@main

struct LeihenSchenkenApp: App {
    
    var body: some Scene {
        
        let _: Bool = ifDatabaseExist()
        let _ = deletePdfList()
        
        WindowGroup {
            
            ContentView()
                .onAppear {
                    
                    UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                    
                } // Ende onAppear
            
        } // Ende WindowGroup
    } // Ende var body
    
} // Ende struckt


