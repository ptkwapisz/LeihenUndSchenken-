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
    @ObservedObject var alertMessageTexte = AlertMessageTexte.shared
    @ObservedObject var hilfeTexte = HilfeTexte.shared
    
    
    @State var showAllgemeinesInfo: Bool = false
    
    @State var showAbfrageModalView: Bool = false
    @State var isParameterBereich: Bool = false
    
    @State var showDBSichern: Bool = false
    @State var showDBLaden: Bool = false
    //@State var showDBLadenMenueItem: Bool = false
    @State var showExportToCSV: Bool = false
    @State var showSetupEdit: Bool = false
    @State var showSetupReset: Bool = false
    @State var showDBReset: Bool = false
    
    @State var showAppInfo: Bool = false
    @State var showTabHilfe: Bool = false
    //@State var showExport: Bool = false  // Diese MenuePunkt wurde deaktiviert

    @State var showStatistikenView: Bool = false

    var body: some View {
    
        // Prüfen, ob sich Objekte in der Datenbank befinden
        let anzahlDerObjekte = querySQLAbfrageClassObjecte(queryTmp: "SELECT * FROM Objekte", abfrage: false)
        
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
                
                //Test(selectedTabView: $globaleVariable.navigationTabView).tabItem {
                
                Tab4(selectedTabView: $globaleVariable.navigationTabView).tabItem {
                    Image(systemName: "list.dash")
                    Text("PDF-Liste")
                    
                } // Ende Tab
                .tag(4) // Die Tags
                
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
            
            if globaleVariable.navigationTabView == 1 {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button( action: {
                        showAllgemeinesInfo = true
                    }) {Image(systemName: "house").imageScale(.large)}
                        .alert("Allgemeine Information", isPresented: $showAllgemeinesInfo, actions: {
                            //Button(" - OK - ") {}
                        }, message: { Text("\(hilfeTexte.allgemeineAppInfo)") } // Ende message
                        ) // Ende alert
                } // Ende ToolbarItemGroup
            }
            
            // Wenn das Tab Handbuch gezeigt wird
            // werden andere Tabmenuepunkte ausgeblendet
            if globaleVariable.navigationTabView < 6 {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Menu(content: {
                        
                        Menu("Datensicherung") { // Menue 1
                            Button("DB sichern", action: {showDBSichern.toggle()}).disabled(globaleVariable.disableDBSpeichernMenueItem)
                            Button("DB zurückspielen", action: {showDBLaden.toggle()}).disabled(globaleVariable.disableDBLadenMenueItem)
                            //Button("Export der Objekte to CSV", action: {showExportToCSV.toggle()}).disabled(globaleVariable.showDBSpeichernMenueItem)
                        } // Ende Menu
                    
                        Menu("App Einstellungen") {
                            Button("Einstellungen bearbeiten", action: {showSetupEdit.toggle()})
                            Button("Einstellungen zurücksetzen", action: {showSetupReset.toggle()})
                        } // Ende Menu
                        
                        Divider()
                        
                        Button("Statistiken", action: {showStatistikenView.toggle()})
                        
                        
                        Button("Datenbank zurücksetzen", action: {showDBReset.toggle()})
                        
                    }) {
                        Image(systemName: "filemenu.and.cursorarrow")
                    } // Ende Menue Image
                    .alert("Trefen Sie eine Wahl!", isPresented: $showSetupReset, actions: {
                        Button("Abbrechen") {}; Button("Ausführen") {deleteUserDefaults()}
                    }, message: { Text("\(alertMessageTexte.showSetupResetMessageText)") } // Ende message
                    ) // Ende alert
                    .alert("Trefen Sie eine Wahl!", isPresented: $showDBReset, actions: {
                        Button("Abbrechen") {}; Button("Ausführen") {datenbankReset()}
                    }, message: { Text("\(alertMessageTexte.showDBResetMessageText)") } // Ende message
                    ) // Ende alert
                    /*
                    .alert("Trefen Sie eine Wahl!", isPresented: $showExportToCSV, actions: {
                        Button("Abbrechen") {}; Button("Ausführen") {showExport = true}
                    }, message: { Text("\(alertMessageTexte.showExportToCSVMessageText)") } // Ende message
                    ) // Ende alert
                    */
                    .alert("Trefen Sie eine Wahl!", isPresented: $showDBSichern, actions: {
                        Button("Abbrechen") {}; Button("DB Sichern") {backupDatabase()}
                    }, message: { Text(backupTarget() + ". \(alertMessageTexte.showDBSichernMessageText)") } // Ende message
                    ) // Ende alert
                    .alert("Trefen Sie eine Wahl!", isPresented: $showDBLaden, actions: {
                        Button("Abbrechen") {}; Button("DB Laden") {loadDatabase()}
                    }, message: { Text(backupTarget() + " vom " + getfileCreatedDate() + ". \(alertMessageTexte.showDBLadenMessageText)") } // Ende message
                    ) // Ende alert
                    .sheet(isPresented: $showSetupEdit, content: { ShapeViewSettings(isPresented: $showSetupEdit)})
                    //.sheet(isPresented: $showExport, content: { ExportCSVProgressView(isPresented: $showExport).presentationBackground(.clear)})
                    .sheet(isPresented: $showStatistikenView, content: {Statistik()})
                    
                } // Ende ToolbarItemGroup
                
                // Wen sich keine Objekte in der Datenbank befinden
                // dann wird die Abfrage deaktiviert.
                if globaleVariable.navigationTabView == 1 || globaleVariable.navigationTabView == 4 {
                    if anzahlDerObjekte.count != 0 {
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            
                            Button(action: {showAbfrageModalView = true
                                
                            }) {
                                Image(systemName: "line.3.horizontal.decrease.circle") //"icons8-filter-25"  line.3.horizontal.decrease.circle
                            } // Ende Button
                            .sheet(isPresented: $showAbfrageModalView, content:  { ShapeViewAbfrage(isPresented: $showAbfrageModalView) }) // Zahnrad
                            Spacer()
                        } // Ende ToolbarItemGroup
                    } // Ende if anzahlDerObjekte
                } // Ende if globaleVariable
            } // Ende if
            
            // Wenn die Tabs PDF Liste oder Handbuch gezeigt werden
            // wird das Zeichen für Drucken gezeigt
            if globaleVariable.navigationTabView == 4 || globaleVariable.navigationTabView == 5 {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action:{
                        if globaleVariable.navigationTabView == 4 {
                            let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                            let pdfPath = docDir!.appendingPathComponent("objektenListe.pdf")
                            printingHandbuchFile(pdfPath: pdfPath, pdfName: " PDF Liste")
                        } // Ende if
                        
                        
                        if globaleVariable.navigationTabView == 5 {
                            let pdfPath = Bundle.main.url(forResource: "L&S Handbuch", withExtension: "pdf")
                            printingHandbuchFile(pdfPath: pdfPath!, pdfName: " Handbuch")
                        } // Ende if
                        
                    }) {
                        Image(systemName: "printer") // printer.fill square.and.arrow.up
                    } // Ende Button
                } // Ende ToolbarGroup
            } // Ende if
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action:{
                    showTabHilfe.toggle()
                    
                }) {
                    Image(systemName: "questionmark.circle.fill")
                } // Ende Button
                
                .alert("Hilfe für \(naviTitleUndHilfeText(tabNummer: globaleVariable.navigationTabView).tabName)", isPresented: $showTabHilfe, actions: {}, message: { Text("\(naviTitleUndHilfeText(tabNummer: globaleVariable.navigationTabView).tabHilfe)")
                    
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
        returnWert = (tabName: "Die Liste der Objekte", tabHilfe: "\(hilfeTexte.tabObjektenListe)")
    case 2:
        returnWert = (tabName: "Gegenstände", tabHilfe: "\(hilfeTexte.tabGegenstandListe)")
    case 3:
        returnWert = (tabName: "Personen", tabHilfe: "\(hilfeTexte.tabPersonenListe)")
    case 4:
        returnWert = (tabName: "PDF-Liste", tabHilfe: "\(hilfeTexte.tabObjektenPDFListe)")
    case 5:
        returnWert = (tabName: "Handbuch", tabHilfe: "\(hilfeTexte.tabHandbuch)")
    default:
        returnWert = (tabName: "", tabHilfe: "")
    } // Ende switch
    
    return returnWert
    
} // Ende func naviTitleText
