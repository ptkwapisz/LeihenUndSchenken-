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
    
    @State var showInfoModalView: Bool = false
    @State var isParameterBereich: Bool = false
    
    @State var showMenue1: Bool = false
    @State var showMenue1_1: Bool = false
    @State var showMenue1_2: Bool = false
    @State var showMenue2: Bool = false
    @State var showMenue3: Bool = false
    @State var showMenue4: Bool = false
    @State var showMenue5: Bool = false
    @State var showAppInfo: Bool = false
    @State var showTabHilfe: Bool = false
    
    
    var body: some View {
    
        VStack(spacing: 10) {
            
            TabView(selection: $globaleVariable.navigationTabView) {
                
                Tab1(selectedTabView: $globaleVariable.navigationTabView).tabItem {
                    Image(systemName: "doc.text.magnifyingglass")
                    Text("Filter")
                }
                .tag(1) // Die Tags identifizieren die Tab und füren zum richtigen Titel
                
                
                Tab2(selectedTabView: $globaleVariable.navigationTabView).tabItem {
                    Image(systemName: "tablecells.fill")
                    Text("Liste")
                    
                }
                .tag(2) // Die Tags identifizieren die Tab und füren zum richtigen Titel
                
                Tab3(selectedTabView: $globaleVariable.navigationTabView).tabItem {
                    Image(systemName: "chart.xyaxis.line")
                    Text("Tab3")
                    
                }
                .tag(3) // Die Tags identifizieren die Tab und füren zum richtigen Titel
                
                Tab4(selectedTabView: $globaleVariable.navigationTabView).tabItem {
                    Image(systemName: "tablecells")
                    Text("Tab4")
                    
                }
                .tag(4) // Die Tags identifizieren die Tab und füren zum richtigen Titel
                
                Tab5(selectedTabView: $globaleVariable.navigationTabView).tabItem {
                    Image(systemName: "tablecells.fill.badge.ellipsis")
                    Text("Tab5")
                } // Ende Tabelle
                .tag(5) // Die Tags identifizieren die Tab und füren zum richtigen Titel
                
            } // Ende TabView
            
            
        } // Ende VStack
        .navigationTitle(naviTitleText(tabNummer: globaleVariable.navigationTabView))
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Menu(content: {
                    
                    Menu("Hinzufügen") { // Menue 1
                        Button("Person", action: {showMenue1_1 = true}) // Menue 1.1
                        Button("Gegenstand", action: {showMenue1_2 = true}) // Menue 1.2
                    } // Ende Menu
                    
                    
                    Menu("Menue 2") {
                        Button("Menue 2.1", action: {})
                        Button("Menue 2.2", action: {})
                    } // Ende Menu
                    
                    
                    Button("Menue 3", action: {})
                    Divider()
                    Button("Menue 4", action: {showMenue4.toggle()})
                    Button("Settings Zurücksetzen", action: {showMenue5.toggle()})
                }) {
                    Image(systemName: "filemenu.and.cursorarrow")
                } // Ende Button
                .alert("Trefen Sie eine Wahl!", isPresented: $showMenue4, actions: {
                      Button("Ausführen") {}; Button("Abbrechen") {}
                      }, message: { Text("Durch Menüpunkt 3 wird eine Tätigkeit ausgeführt.") } // Ende message
                ) // Ende alert
                .alert("Trefen Sie eine Wahl!", isPresented: $showMenue5, actions: {
                      Button("Ausführen") {deleteUserDefaults()}; Button("Abbrechen") {}
                      }, message: { Text("Durch das Zurücksetzen der Settings werden alle Einstellungen auf die Standardwerte zurückgesetzt. Standardwerte sind: Sprache: Deutsch, Farbe Ebene 0: blau, Farbe Ebene1: grün") } // Ende message
                    ) // Ende alert
                .sheet(isPresented: $showMenue1_1, content: { ShapeViewAddUser(isPresented: $showMenue1_1, isParameterBereich: $isParameterBereich )})
                .sheet(isPresented: $showMenue1_2, content: { ShapeViewAddGegenstand(isPresented: $showMenue1_2, isParameterBereich: $isParameterBereich) })
                
            } // Ende ToolbarItemGroup
                        
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {showAppInfo.toggle()
                    
                }) {
                    Image(systemName: "house")
                    
                } // Ende Button
                .alert("Allgemeine Information", isPresented: $showAppInfo, actions: {
                      Button(" - OK - ") {}
                      }, message: { Text("Das ist die allgemeine Information über diese Applikation.") } // Ende message
                    ) // Ende alert
                
            } // Ende ToolbarItemGroup
            
            //self.shapeSettings.showSettings = true
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {showInfoModalView = true
                        
                }) {
                    Image(systemName: "gear")
                } // Ende Button
                .sheet(isPresented: $showInfoModalView, content:  { ShapeViewSettings(isPresented: $showInfoModalView) })
                Spacer()
            } // Ende ToolbarItemGroup
            
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action:{showTabHilfe.toggle()
                        
                }) {
                    Image(systemName: "questionmark.circle")
                } // Ende Button
                .alert("Hilfe für \(naviTitleText(tabNummer: globaleVariable.navigationTabView))", isPresented: $showTabHilfe, actions: {
                      Button(" - OK - ") {}
                      }, message: { Text("Das ist die Beschreibung für die augewählte Tab.") } // Ende message
                    ) // Ende alert
                } // Ende ToolbarItemGroup
                
        } // Ende toolbar
        //.toolbarRole(.editor) // Bei dieser Rolle ist der back Button < ohne Text
        
        
        
    } // var body
} // Ende struct

func naviTitleText(tabNummer: Int) -> String {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    let returnWert:  String
    
    switch tabNummer {
        case 1:
            returnWert = "Abfragenfilter"
        case 2:
            returnWert = "Liste der Datensätze"
        case 3:
            returnWert = "Tab3 "
        case 4:
            returnWert = "Tab4 "
        case 5:
            returnWert = "Tab5 "
        default:
            returnWert = ""
    } // Ende switch

    return returnWert
    
} // Ende func naviTitleText
