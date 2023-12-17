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
    
    @State var hilfeTexte = HilfeTexte()
    @State var alertMessageTexte = AlertMessageTexte()
    
    @State var showAllgemeinesInfo: Bool = false
    
    @State var showAbfrageModalView: Bool = false
    @State var isParameterBereich: Bool = false
    
    @State var showDBSichern: Bool = false
    @State var showDBLaden: Bool = false
    @State var showExportToCSV: Bool = false
    @State var showSetupEdit: Bool = false
    @State var showSetupReset: Bool = false
    @State var showDBReset: Bool = false
    @State var showPremiumStatus: Bool = false
    
    @State var showAppInfo: Bool = false
    @State var showTabHilfe: Bool = false
    
    @State var showStatistikenView: Bool = false
    //@State var backupTargetStr: String = backupTarget()
    
    @State var gegenstandHinzufuegen: Bool = false
    @State var selectedTypeTmp = ""
  
    var body: some View {
       
        // Prüfen, ob sich Objekte in der Datenbank befinden
        //let anzahlDerObjekte = querySQLAbfrageClassObjecte(queryTmp: "SELECT * FROM Objekte", abfrage: false)
        let _ = setColorOfBadge(numberOfObjects: globaleVariable.numberOfObjects)
       
            VStack(spacing: 10) {
                
                TabView(selection: $globaleVariable.navigationTabView) {
                    
                    Tab1(selectedTabView: $globaleVariable.navigationTabView).tabItem {
                        Image(systemName: "tablecells.fill")
                        Text("Objekte")
                    } // Ende Tab
                    .tag(1) // Die Tags identifizieren die Tab und füren zum richtigen Titel
                    .badge(globaleVariable.numberOfObjects)
                    
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
                    
                    if globaleVariable.numberOfObjects > 0 {
                        Tab4(selectedTabView: $globaleVariable.navigationTabView).tabItem {
                            Image(systemName: "list.dash")
                            Text("PDF-Liste")
                            
                        } // Ende Tab
                        .tag(4) // Die Tags
                    } // Ende if
                    
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
                
                MyToolbarItemsHausButton()
                
                if globaleVariable.navigationTabView < 6 {
                    
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Menu(content: {
                            
                            Menu("Datensicherung") { // Menue 1
                                Button("DB sichern", action: {showDBSichern.toggle()}).disabled(ifExistSpaceForLeiheUndSchenkeDbCopy())
                                Button("DB zurückspielen", action: {showDBLaden.toggle()}).disabled(ifExistLeiheUndSchenkeDbCopy())
                                //Button("Export der Objekte to CSV", action: {showExportToCSV.toggle()}).disabled(globaleVariable.showDBSpeichernMenueItem)
                            } // Ende Menu
                            
                            Menu("App Einstellungen") {
                                Button("Einstellungen bearbeiten", action: {showSetupEdit.toggle()})
                                Button("Einstellungen zurücksetzen", action: {showSetupReset.toggle()})
                            } // Ende Menu
                            
                            Button("In-App-Käufe", action: {showPremiumStatus.toggle()})
                            
                            Divider()
                            
                            Button("Statistiken", action: {showStatistikenView.toggle()})
                            Button("Datenbank zurücksetzen", action: {showDBReset.toggle()})
                            
                        }) {
                            Image(systemName: "filemenu.and.cursorarrow")
                        } // Ende Menue Image
                        .alert("Trefen Sie eine Wahl!", isPresented: $showSetupReset, actions: {
                            Button("Abbrechen") {}; Button("Ausführen") {deleteUserDefaults()}
                        }, message: { Text("\(AlertMessageTexte.showSetupResetMessageText)") } // Ende message
                        ) // Ende alert
                        .alert("Trefen Sie eine Wahl!", isPresented: $showDBReset, actions: {
                            Button("Abbrechen") {}; Button("Ausführen") {datenbankReset()}
                        }, message: { Text("\(AlertMessageTexte.showDBResetMessageText)") } // Ende message
                        ) // Ende alert
                        .alert("Trefen Sie eine Wahl!", isPresented: $showDBSichern, actions: {
                            Button("Abbrechen") {}; Button("DB Sichern") {backupDatabase()}
                        }, message: { Text(String(backupTarget()) + ". \(AlertMessageTexte.showDBSichernMessageText)") } // Ende message
                        ) // Ende alert
                        .alert("Trefen Sie eine Wahl!", isPresented: $showDBLaden, actions: {
                            Button("Abbrechen") {}; Button("DB Laden") {loadDatabase()}
                        }, message: { Text(String(backupTarget()) + " vom " + getfileCreatedDate() + ". \(AlertMessageTexte.showDBLadenMessageText)") } // Ende message
                        ) // Ende alert
                        .sheet(isPresented: $showSetupEdit, content: { ShapeViewSettings(isPresented: $showSetupEdit)})
                        .sheet(isPresented: $showStatistikenView, content: {Statistik()})
                        .sheet(isPresented: $showPremiumStatus, content: {StroreAccessPremium(isPresented: $showPremiumStatus)})
                        
                    } // Ende ToolbarItemGroup
                
                    MyToolbarItemsQueryButton()
                    
                } // Ende if
                
                MyToolbarItemsEditButton()
                MyToolbarItemsPrintButton()
                MyToolbarPlusButtonTab1()
                MyToolbarItemsPlusMinusTab2()
                MyToolbarItemsPlusMinusTab3()
                
                MyToolbarItemsHilfeButton()
                
            } // Ende toolbar
            
            
    } // Ende var body
   
    func setColorOfBadge(numberOfObjects: Int){
        
        var badgeColor: UIColor
        let tabBarAppearance = UITabBarAppearance()
        
        if numberOfObjects < GlobalStorage.numberOfObjectsFree {
            print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Unter \(GlobalStorage.numberOfObjectsFree)")
            
            badgeColor = UIColor(Color.red)
        }else{
            print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Über \(GlobalStorage.numberOfObjectsFree)")
           
            badgeColor = UIColor(globaleVariable.farbenEbene0)
        } // Ende if/else
    
        tabBarAppearance.stackedLayoutAppearance.normal.badgeBackgroundColor = badgeColor
        UITabBar.appearance().standardAppearance = tabBarAppearance
    

    } // Ende func

} // Ende struct

func naviTitleUndHilfeText(tabNummer: Int) -> (tabName: String, tabHilfe: String) {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    //@ObservedObject var hilfeTexte = HilfeTexte.shared
    //var hilfeTexte = HilfeTexte()
    
    let returnWert:  (tabName: String, tabHilfe: String)
    
    switch tabNummer {
    case 1:
            returnWert = (tabName: "Liste der Objekte", tabHilfe: "\(HilfeTexte.tabObjektListe)")
    case 2:
            returnWert = (tabName: "Gegenstände", tabHilfe: "\(HilfeTexte.tabGegenstandListe)")
    case 3:
            returnWert = (tabName: "Personen", tabHilfe: "\(HilfeTexte.tabPersonenListe)")
    case 4:
            returnWert = (tabName: "PDF-Liste", tabHilfe: "\(HilfeTexte.tabObjektPDFListe)")
    case 5:
            returnWert = (tabName: "Handbuch", tabHilfe: "\(HilfeTexte.tabHandbuch)")
    default:
        returnWert = (tabName: "", tabHilfe: "")
    } // Ende switch
    
    return returnWert
    
} // Ende func naviTitleText


struct MyToolbarItemsPlusMinusTab2: ToolbarContent {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @State var isParameterBereich: Bool = false
    
    @State var gegenstandHinzufuegen: Bool = false
    @State var errorMessageText = ""
    @State var selectedTypeTmp = ""
    @State var showAlert = false
    @State var activeAlert: ActiveAlert = .error
    
    
    var body: some ToolbarContent {
        if globaleVariable.navigationTabView == 2  {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action:{
                    gegenstandHinzufuegen = true
                    
                }) {
                    Image(systemName: "plus")
                } // Ende Button
                .navigationDestination(isPresented: $gegenstandHinzufuegen, destination: { ShapeViewAddGegenstand(isPresented: $gegenstandHinzufuegen, isParameterBereich: $isParameterBereich)
                        .navigationBarBackButtonHidden()
                        .navigationBarTitleDisplayMode(.large)
                })
                
                Button(action:{
                    selectedTypeTmp = GlobalStorage.selectedGegenstandTab2
                    
                    if selectedTypeTmp == "Buch" || selectedTypeTmp == "Geld" || selectedTypeTmp == "CD/DVD" || selectedTypeTmp == "Werkzeug"{
                        errorMessageText = "Standard Gegenstände, wie Buch, Geld, CD/DVD und Werkzeug können nicht gelöscht werden!"
                        
                        showAlert = true
                        activeAlert = .error
                        
                    }else{
                        
                        showAlert = true
                        activeAlert = .delete
                    }// Ende if/else
                    
                }) {
                    Image(systemName: "trash")
                } // Ende Button
                .alert(isPresented: $showAlert) {
                    switch activeAlert {
                        case .error:
                            return Alert(title: Text("Wichtige Information"), message: Text(errorMessageText), dismissButton: .default(Text("OK")))
                        case .delete:
                            return Alert(
                                title: Text("Wichtige Information!"),
                                message: Text("Der Gegenstand: \(selectedTypeTmp) wird unwiederfuflich gelöscht! Man kann den Vorgang nicht rückgängich machen!"),
                                primaryButton: .destructive(Text("Löschen")) {
                                    
                                    let perKeyTmp = perKeyBestimmenGegenstand(par: selectedTypeTmp)
                                    deleteItemsFromDatabase(tabelle: "Gegenstaende", perKey: perKeyTmp[0])
                                    print("\(selectedTypeTmp)" + " wurde gelöscht")
                                    
                                    refreshAllViews()
                                    
                                },
                                secondaryButton: .cancel(Text("Abbrechen")){
                                    print("Abgebrochen ....")
                                } // Ende secondary Button
                            ) // Ende Alert
                        case .information:
                            return Alert(title: Text("Wichtige Information"), message: Text(errorMessageText), dismissButton: .default(Text("OK")))
                    } // Ende switch
                } // Ende alert
                
            } // Ende ToolbarGroup
            
            
        } // Ende if
    } // Ende var
} // Ende Struct


struct MyToolbarItemsPlusMinusTab3: ToolbarContent {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @State var isParameterBereich: Bool = false
    @State var errorMessageText = ""
    @State var selectedPickerTmp: String = ""
    
    
    @State var personHinzufuegen: Bool = false
    @State private var showAlert = false
    @State private var activeAlertTab3: ActiveAlertTab3 = .error
    
    let anzahlDerPersonen = querySQLAbfrageClassPerson(queryTmp: "SELECT * FROM Personen", isObjectTabelle: false)
    
    
    var body: some ToolbarContent {
        
            if globaleVariable.navigationTabView == 3  {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action:{
                        personHinzufuegen = true
                        
                    }) {
                        Image(systemName: "plus")
                    } // Ende Button
                    
                    .navigationDestination(isPresented: $personHinzufuegen, destination: { ShapeViewAddUser(isPresented: $personHinzufuegen, isParameterBereich: $isParameterBereich)
                            .navigationBarBackButtonHidden()
                            .navigationBarTitleDisplayMode(.inline)
                    })
                    
                    if anzahlDerPersonen.count > 1 {
                        Button(action:{
                            selectedPickerTmp = "\(GlobalStorage.selectedPersonPickerTab3 )"
                            
                            if selectedPickerTmp == "" {
                                errorMessageText = "Bitte markieren Sie zuerst eine Person, die Sie löschen möchten. Das tun sie durch das Klicken auf die entsprechende Zeile. Danach betätigen Sie noch mal das Minuszeichen, um die markierte Person zu löschen ."
                                
                                showAlert = true
                                activeAlertTab3 = .error
                            }else{
                                
                                showAlert = true
                                activeAlertTab3 = .delete
                                
                            }// Ende if/else
                            
                        }) {
                            Image(systemName: "trash")
                        } // Ende Button
                        
                        .alert(isPresented: $showAlert) {
                            switch activeAlertTab3 {
                                case .error:
                                    return Alert(title: Text("Wichtige Information"), message: Text(errorMessageText), dismissButton: .default(Text("OK")))
                                case .delete:
                                    return Alert(
                                        title: Text("Wichtige Information!"),
                                        message: Text("Die Person: \(selectedPickerTmp) wird unwiederfuflich gelöscht! Man kann diesen Vorgang nicht rückgängich machen!"),
                                        primaryButton: .destructive(Text("Löschen")) {
                                            
                                            let perKeyTmp = perKeyBestimmenPerson(par: selectedPickerTmp)
                                            deleteItemsFromDatabase(tabelle: "Personen", perKey: perKeyTmp[0])
                                            
                                            print("\(selectedPickerTmp)" + " wurde gelöscht")
                                            print(perKeyTmp)
                                            
                                            GlobalStorage.selectedPersonPickerTab3 = ""
                                            
                                            refreshAllViews()
                                            
                                        },
                                        secondaryButton: .cancel(Text("Abbrechen")){
                                            print("\(selectedPickerTmp)" + " wurde nicht gelöscht")
                                            print("Abgebrochen ....")
                                        } // Ende secondary Button
                                    ) // Ende Alert
                                    
                            } // Ende switch
                        } // Ende alert
                    } // Ende if anzahlDerPersonen
                    
                } // Ende ToolbarGroup
                
            } // Ende if
        
    } // Ende var
        
} // Ende struct


struct MyToolbarItemsHilfeButton: ToolbarContent {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @ObservedObject var userSettingsDefaults = UserSettingsDefaults.shared
    
    @State var showTabHilfe: Bool = false
    
    var body: some ToolbarContent {
        
        if userSettingsDefaults.showHandbuch == true {
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
        } // Ende if
        
        
    } // Ende var body
} // Ende struct

struct MyToolbarPlusButtonTab1: ToolbarContent {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @ObservedObject var userSettingsDefaults = UserSettingsDefaults.shared
    //@StateObject var productManager = ProductManager()
    
    @State var showEingabeMaske: Bool = false
    @State var showStoreAlert: Bool = false
    
    
    //let statusManager = StatusManager()
    let purchaseManager = PurchaseManager()
    
    var body: some ToolbarContent {
        
        if globaleVariable.navigationTabView == 1 && UIDevice.current.userInterfaceIdiom == .phone {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action:{
                    
                    if globaleVariable.numberOfObjects < GlobalStorage.numberOfObjectsFree || purchaseManager.isPremium() == true {
                    //if globaleVariable.numberOfObjects < GlobalStorage.numberOfObjectsFree || statusManager.isProductPurchased == true {
                        showEingabeMaske = true
                    }else{
                        showStoreAlert = true
                    } // Ende if/else
                    
                }) {
                    Image(systemName: "plus")
                } // Ende Button
                .applyModifier(UIDevice.current.userInterfaceIdiom == .phone) {
                    $0.navigationDestination(isPresented: $showEingabeMaske, destination: { EingabeMaskePhoneAndPadView()
                           
                    })
                } // Ende .applyModifier
                .alert("Status Information", isPresented: $showStoreAlert, actions: {
                }, message: { Text("Sie haben eine Standarversion. Sie erlaubt es nicht mehr als 10 Objekte zu verwalten. Bitte klicken Sie auf das Menue-Icon oben links und wählen Sie die Menuezeile 'In-App-Käufe' aus. Dort können Sie einmahlig die Premiumversion kaufen und dadurch die Objektsperre ausschalten.") } // Ende message
                ) // Ende alert
                
            } // Ende ToolbarItemGroup
            
        } // Ende if
        
    } // Ende var body
} // Ende struct


struct MyToolbarItemsPrintButton: ToolbarContent {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    //@ObservedObject var userSettingsDefaults = UserSettingsDefaults.shared
    
    var body: some ToolbarContent {
        
        // Wenn die Tabs PDF Liste oder Handbuch gezeigt werden
        // wird das Zeichen für Drucken gezeigt
        if globaleVariable.navigationTabView == 4 || globaleVariable.navigationTabView == 5 {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action:{
                    if globaleVariable.navigationTabView == 4 {
                        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                        let pdfPath = docDir!.appendingPathComponent("ObjektListe.pdf")
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
        
    } // Ende var body
} // Ende struct


struct MyToolbarItemsQueryButton: ToolbarContent {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    let anzahlDerObjekte = querySQLAbfrageClassObjecte(queryTmp: "SELECT * FROM Objekte", abfrage: false)
    
    @State var showAbfrageModalView: Bool = false
    
    var body: some ToolbarContent {
        
        // Wen sich keine Objekte in der Datenbank befinden
        // dann wird die Abfrage deaktiviert.
        if globaleVariable.navigationTabView == 1 || globaleVariable.navigationTabView == 4 {
            if anzahlDerObjekte.count != 0 {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    
                    Button(action: {showAbfrageModalView = true
                        
                    }) {
                        Image(systemName: "line.3.horizontal.decrease.circle") //"icons8-filter-25"  line.3.horizontal.decrease.circle
                    } // Ende Button
                    .sheet(isPresented: $showAbfrageModalView, content:  { ShapeViewAbfrage(isPresented: $showAbfrageModalView) })
                    
                    Spacer()
                } // Ende ToolbarItemGroup
            } // Ende if anzahlDerObjekte
        } // Ende if globaleVariable
        
    } // Ende var body
} // Ende struct


struct MyToolbarItemsHausButton: ToolbarContent {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @ObservedObject var userSettingsDefaults = UserSettingsDefaults.shared
    //@ObservedObject var hilfeTexte = HilfeTexte.shared
    @State var hilfeTexte = HilfeTexte()
    
    @State var showAllgemeinesInfo: Bool = false
    
    var body: some ToolbarContent {
        
        if userSettingsDefaults.showHandbuch == true {
            if globaleVariable.navigationTabView == 1 && userSettingsDefaults.showHandbuch == true {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button( action: {
                        showAllgemeinesInfo = true
                    }) {Image(systemName: "house").imageScale(.large)}
                        .alert("Allgemeine Information", isPresented: $showAllgemeinesInfo, actions: {
                            //Button(" - OK - ") {}
                        }, message: { Text("\(HilfeTexte.allgemeineAppInfo)") } // Ende message
                        ) // Ende alert
                } // Ende ToolbarItemGroup
            } // Ende if globaleVariable
        } // Ende if
        
        
    } // Ende var body
} // Ende struct


struct MyToolbarItemsEditButton: ToolbarContent {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @ObservedObject var data = SharedData.shared
    @State private var isSheetPresented: Bool = false
    @State var showAllgemeinesInfo: Bool = false
    @State var versionCounter: Int = 0
    
    @State var tabNumber: Int = 4
    
    var body: some ToolbarContent {
        
        if globaleVariable.navigationTabView == 4  {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button( action: {
                    isSheetPresented.toggle()
                }) {
                    //Text("Bearbeiten")
                    Image(systemName: "pencil").imageScale(.large)
                }  // PDF-List
                    .navigationDestination(isPresented: $isSheetPresented, destination: { ObjektListeParameter(data: data, isPresented: $isSheetPresented)})
                    //.navigationBarBackButtonHidden()
                    //.navigationBarTitleDisplayMode(.large)
                
            } // Ende ToolbarItemGroup
        } // Ende if globaleVariable
        
        
    } // Ende var body
} // Ende struct
