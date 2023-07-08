//
//  DetailView.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 27.03.23.
//

import Foundation
import SwiftUI

struct DeteilView: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @ObservedObject var userSettingsDefaults = UserSettingsDefaults.shared
    
    @State var showAbfrageModalView: Bool = false
    @State var isParameterBereich: Bool = false
    
    //@State var showMenue1: Bool = false
    @State var showMenue1_1: Bool = false
    @State var showMenue1_2: Bool = false
    //@State var showMenue2: Bool = false
    @State var showMenue2_1: Bool = false
    @State var showMenue2_2: Bool = false
    @State var showMenue3: Bool = false
    @State var showMenue3_1: Bool = false
    @State var showMenue3_2: Bool = false
    @State var showMenue4: Bool = false
    @State var showMenue5: Bool = false
    @State var showAppInfo: Bool = false
    @State var showTabHilfe: Bool = false
    @State var showExport: Bool = false
    
    var body: some View {
    
        VStack(spacing: 10) {
            
            TabView(selection: $globaleVariable.navigationTabView) {
                
                Tab1(selectedTabView: $globaleVariable.navigationTabView).tabItem {
                    Image(systemName: "tablecells.fill")
                    Text("Objekte")
                } // Ende Tab
                .tag(1) // Die Tags identifizieren die Tab und füren zum richtigen Titel
                
                
                Tab2(selectedTabView: $globaleVariable.navigationTabView).tabItem {
                    Image(systemName: "archivebox.fill")
                    Text("Gegenstände")
                    
                } // Ende Tab
                .tag(2) // Die Tags identifizieren die Tab und füren zum richtigen Titel
                
                Tab3(selectedTabView: $globaleVariable.navigationTabView).tabItem {
                    Image(systemName: "person.2.fill")
                    Text("Personen")
                    
                } // Ende Tab
                .tag(3) // Die Tags identifizieren die Tab und füren zum richtigen Titel
                
                Tab4(selectedTabView: $globaleVariable.navigationTabView).tabItem {
                    Image(systemName: "chart.xyaxis.line")
                    Text("Statistik")
                    
                } // Ende Tab
                .tag(4) // Die Tags identifizieren die Tab und füren zum richtigen Titel
                
                if userSettingsDefaults.showHandbuch == true {
                    Tab5(selectedTabView: $globaleVariable.navigationTabView).tabItem {
                        Image(systemName: "h.circle.fill")
                        Text("Handbuch")
                    } // Ende Tab
                    .tag(5) // Die Tags identifizieren die Tab und füren zum richtigen Titel
                } // Ende if
            } // Ende TabView
            
        } // Ende VStack
        .navigationTitle(naviTitleUndHilfeText(tabNummer: globaleVariable.navigationTabView).tabName)
        
        .toolbar {
            // Wenn das Tab Handbuch gezeigt wird
            // andere Tabmenuepunkte ausgeblendet
            if globaleVariable.navigationTabView < 5 {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Menu(content: {
                        
                        Menu("Datensicherung") { // Menue 1
                            Button("DB sichern", action: {showMenue1_1.toggle()}) // Menue 1.1
                            Button("DB zurückspielen", action: {showMenue1_2.toggle()}) // Menue 1.2
                        } // Ende Menu
                    
                        Menu("App Parameter") {
                            Button("Parameter bearbeiten", action: {showMenue3_1.toggle()}) // Menue3_1
                            Button("Parameter zurücksetzen", action: {showMenue3_2.toggle()}) // Menue3_2
                        } // Ende Menu
                        
                        Divider()
                        
                        Button("Export to CSV", action: {showMenue2_1.toggle()}) // Menue2_1
                        Button("Datenbank zurücksetzen", action: {showMenue5.toggle()})
                        
                    }) {
                        Image(systemName: "filemenu.and.cursorarrow")
                    } // Ende Menue Image
                    .alert("Trefen Sie eine Wahl!", isPresented: $showMenue3_2, actions: {
                        Button("Abbrechen") {}; Button("Ausführen") {deleteUserDefaults()}
                    }, message: { Text("Durch das Zurücksetzen der Parameter werden alle Einstellungen auf die Standardwerte zurückgesetzt. Standardwerte sind: Farbe Ebene 0: blau, Farbe Ebene1: grün") } // Ende message
                    ) // Ende alert
                    .alert("Trefen Sie eine Wahl!", isPresented: $showMenue5, actions: {
                        Button("Abbrechen") {}; Button("Ausführen") {datenbankReset()}
                    }, message: { Text("Durch das Zurücksetzen der Datenbank werden die Datenbank und alle Tabellen gelöscht. Dabei gehen alle gespeicherte Daten verloren. Dies kann nicht rückgängig gemacht werden! Dann werden die Datenbank und alle Tabellen neu erstellt.") } // Ende message
                    ) // Ende alert
                    .alert("Trefen Sie eine Wahl!", isPresented: $showMenue2_1, actions: {
                        Button("Abbrechen") {}; Button("Ausführen") {showExport = true}
                    }, message: { Text("Alle Objekte aus der Datenbank werden in dem Format SCV in die Datei 'LeihUndSchenkeDB.CSV' exportiert. Diese Datei überschreibt die letzte Exportversion falls vorhanden!") } // Ende message
                    ) // Ende alert
                    .alert("Trefen Sie eine Wahl!", isPresented: $showMenue1_1, actions: {
                        Button("Abbrechen") {}; Button("DB Sichern") {backupDatabase()}
                    }, message: { Text("Die Datenbank wird inclusiwe aller Tabellen gesichert. Diese Sicherung überschreibt die letzte Sicherungsversion falls vorhanden!") } // Ende message
                    ) // Ende alert
                    .sheet(isPresented: $showMenue3_1, content: { ShapeViewSettings(isPresented: $showMenue3_1)})
                    .sheet(isPresented: $showExport, content: { ExportCSVProgressView(isPresented: $showExport).presentationBackground(.clear)})
                   
                } // Ende ToolbarItemGroup
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {showAbfrageModalView = true
                        
                    }) {
                        Image(systemName: "line.3.horizontal.decrease.circle") //"icons8-filter-25"  line.3.horizontal.decrease.circle
                    } // Ende Button
                    .sheet(isPresented: $showAbfrageModalView, content:  { ShapeViewAbfrage(isPresented: $showAbfrageModalView) }) // Zahnrad
                    Spacer()
                } // Ende ToolbarItemGroup
                
            } // Ende if
            
            // Wenn das Tab Handbuch gezeigt wird
            // wird das Zeichen für Drucken gezeigt
            if globaleVariable.navigationTabView == 5 {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action:{
                        
                        printingFile()
                        
                    }) {
                        Image(systemName: "printer") // printer.fill square.and.arrow.up
                    } // Ende Button
                } // Ende ToolbarItem
            } // Ende if
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action:{
                    showTabHilfe.toggle()
                    
                }) {
                    Image(systemName: "questionmark.circle.fill")
                } // Ende Button
                
                .alert("Hilfe für \(naviTitleUndHilfeText(tabNummer: globaleVariable.navigationTabView).tabName)", isPresented: $showTabHilfe, actions: {
                    Button(" - OK - ") {}
                }, message: { Text("\(naviTitleUndHilfeText(tabNummer: globaleVariable.navigationTabView).tabHilfe)")
                    
                } // Ende message
                    
                ) // Ende .alert
                
            } // Ende ToolbarItemGroup
            //.blur(radius: showMenue2_2 ? 15 : 0 ); if showMenue2_2 {AlertView()}
            
        } // Ende toolbar
        //.toolbarRole(.editor) // Bei dieser Rolle ist der back Button < ohne Text
        
        
    } // var body
} // Ende struct

func naviTitleUndHilfeText(tabNummer: Int) -> (tabName: String, tabHilfe: String) {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @ObservedObject var hilfeTexte = HilfeTexte.shared
    
    let returnWert:  (tabName: String, tabHilfe: String)
    
    switch tabNummer {
        case 1:
            returnWert = (tabName: "Objektenliste", tabHilfe: "\(hilfeTexte.tabObjektenListe)")
        case 2:
            returnWert = (tabName: "Gegenständeliste", tabHilfe: "\(hilfeTexte.tabGegenstandListe)")
        case 3:
            returnWert = (tabName: "Personenliste", tabHilfe: "\(hilfeTexte.tabPersonenListe)")
        case 4:
            returnWert = (tabName: "Statistiken", tabHilfe: "\(hilfeTexte.tabStatistiken)")
        case 5:
            returnWert = (tabName: "Handbuch", tabHilfe: "\(hilfeTexte.tabHandbuch)")
        default:
            returnWert = (tabName: "", tabHilfe: "")
    } // Ende switch
    
    return returnWert
    
} // Ende func naviTitleText
