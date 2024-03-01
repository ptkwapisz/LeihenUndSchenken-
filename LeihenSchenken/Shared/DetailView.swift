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
    
    @State private var hilfeTexte = HilfeTexte()
    @State private var alertMessageTexte = AlertMessageTexte()
    
    @State private var showAllgemeinesInfo: Bool = false
    
    @State private var showAbfrageModalView: Bool = false
    @State private var isParameterBereich: Bool = false
    
    @State private var showDBSichern: Bool = false
    @State private var showDBLaden: Bool = false
    //@State private var showExportToCSV: Bool = false
    @State private var showSetupEdit: Bool = false
    @State private var showSetupReset: Bool = false
    @State private var showDBReset: Bool = false
    @State private var showPremiumStatus: Bool = false
    
    @State private var showAppInfo: Bool = false
    @State private var showTabHilfe: Bool = false
    
    @State private var showStatistikenView: Bool = false
    
    @State private var gegenstandHinzufuegen: Bool = false
    @State private var selectedTypeTmp = ""
    
    @State private var navigationTabViewNo: Int = 1
    
    // Diese Variable wird als Binding and die untere Views gesendet
    // In dieser Variable wird der Wert für die .badge für TabView1 (Objekte) geschrieben
    @State private var badgeString: String = ""
    
    var body: some View {
        let _ = print("Struct DeteilView wird aufgerufen")
        
        // Prüfen, ob sich Objekte in der Datenbank befinden
        //let _ = querySQLAbfrageClassObjecte(queryTmp: "SELECT * FROM Objekte", abfrage: false) // Alle Objekte
        //let tmp2 = querySQLAbfrageClassObjecte(queryTmp: "SELECT * FROM Objekte", abfrage: true) // Objekte mit Abfrage
        //let tmp3 = serchObjectArray(parameter: tmp2) // Objekte mit Abfrage falls es sie gibt.
        //let tmp4: Int = tmp3.count == tmp1.count ? 0 : 1
        
        let _ = setColorOfBadge(numberOfObjects: numberOfObjects)
        
        VStack(spacing: 10) {
            
            TabView(selection: $navigationTabViewNo) {
                //Tab1(selectedTabView: $navigationTabViewNo, badgeString: $badgeString).tabItem {
                Tab1(badgeString: $badgeString).tabItem {
                    Image(systemName: "tablecells.fill")
                    Text("Objekte")
                    
                } // Ende Tab
                .tag(1) // Die Tags identifizieren die Tab und führen zum richtigen Titel
                // Wenn die Abfrage aktiviert wurde wird in der Badge die Anzahl der gefilterten Datensätze
                // gefolgt von Schregstrich und dem gesamten Zahl der Objekte angezeigt: 3 / 7.
                .badge(badgeString)
                
                //Tab2(selectedTabView: $navigationTabViewNo).tabItem {
                Tab2().tabItem {
                    Image(systemName: "archivebox.fill")
                    Text("Gegenstände")
                    
                } // Ende Tab
                .tag(2) // Die Tags identifizieren die Tab und füren zum richtigen Titel
                
                //Tab3(selectedTabView: $navigationTabViewNo).tabItem {
                Tab3().tabItem {
                    Image(systemName: "person.2.fill")
                    Text("Personen")
                    
                } // Ende Tab
                .tag(3) // Die Tags identifizieren die Tab und füren zum richtigen Titel
                
                if numberOfObjects > 0 {
                    //Tab4(selectedTabView: $navigationTabViewNo).tabItem {
                    Tab4().tabItem {
                        Image(systemName: "list.dash")
                        Text("PDF-Liste")
                        
                    } // Ende Tab
                    .tag(4) // Die Tags
                } // Ende if
                
                if userSettingsDefaults.showHandbuch == true {
                    //Tab5(selectedTabView: $navigationTabViewNo).tabItem {
                    Tab5().tabItem {
                        Image(systemName: "h.circle.fill")
                        Text("Handbuch")
                    } // Ende Tab
                    .tag(5) // Die Tags identifizieren die Tab und füren zum richtigen Titel
                } // Ende if
                
            } // Ende TabView
            
            
        } // Ende VStack
        //.navigationTitle(naviTitleUndHilfeText(tabNummer: globaleVariable.navigationTabView).tabName)
        .navigationTitle(naviTitleUndHilfeText(tabNummer: navigationTabViewNo).tabName)
        .onChange(of: navigationTabViewNo ){
            
            // Tab number wird in die StorageData.navigationTabView gespeichert
            // Das ist notwändig für unterscheiden der Hilfetexte für die einzehlne Tabs
           
            navigationTabView = navigationTabViewNo
        }
        .toolbar {
            
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
                    Button("Abbrechen") {}; Button("DB Laden") {loadDatabase()
                        numberOfObjects = anzahlDerDatensaetze(tableName: "Objekte") }
                }, message: { Text(String(backupTarget()) + " vom " + getfileCreatedDate() + ". \(AlertMessageTexte.showDBLadenMessageText)") } // Ende message
                ) // Ende alert
                .sheet(isPresented: $showSetupEdit, content: { ShapeViewSettings(isPresented: $showSetupEdit)})
                .sheet(isPresented: $showStatistikenView, content: {Statistik()})
                .sheet(isPresented: $showPremiumStatus, content: {StroreAccessPremium(isPresented: $showPremiumStatus)})
                
                
            } // Ende ToolbarItemGroup
            if navigationTabViewNo == 1 {
                MyToolbarItemsQueryButton()
                MyToolbarPlusButtonTab1()
                MyToolbarItemsHausButtonTab1()
                MyToolbarItemsHilfeButton()
            } // Ende if
            
            if navigationTabViewNo == 2 {
                MyToolbarItemsPlusAndTrashTab2()
                MyToolbarItemsHilfeButton()
            } // Ende if
            
            if navigationTabViewNo == 3 {
                MyToolbarItemsPlusAndTrashTab3()
                MyToolbarItemsHilfeButton()
            } // Ende if
            
            if navigationTabViewNo == 4 {
                //MyToolbarItemsQueryButton()
                MyToolbarItemsEditButtonTab4()
                MyToolbarItemsPrintButtonTab4()
                MyToolbarItemsHilfeButton()
            } // Ende if
            
            if navigationTabViewNo == 5 {
                MyToolbarItemsPrintButtonTab5()
                MyToolbarItemsHilfeButton()
            } // Ende if
            
        } // Ende toolbar
        
    } // Ende var body
    
    func setColorOfBadge(numberOfObjects: Int){
        
        var badgeColor: UIColor
        let tabBarAppearance = UITabBarAppearance()
        
        if numberOfObjects < numberOfObjectsFree {
            //print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Unter \(GlobalStorage.numberOfObjectsFree)")
            
            badgeColor = UIColor(Color.red)
        }else{
            //print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Über \(GlobalStorage.numberOfObjectsFree)")
            
            badgeColor = UIColor(globaleVariable.farbEbene0)
        } // Ende if/else
        
        tabBarAppearance.stackedLayoutAppearance.normal.badgeBackgroundColor = badgeColor
        UITabBar.appearance().standardAppearance = tabBarAppearance
        
        
    } // Ende func
    
    
} // Ende struct

func naviTitleUndHilfeText(tabNummer: Int) -> (tabName: String, tabHilfe: String) {
    print("Funktion naviTitleUndHilfeText() wird aufgerufen ")
    
    let returnWert:  (tabName: String, tabHilfe: String)
    
    switch tabNummer {
    case 1:
            returnWert = (tabName: "Liste der Objekte", tabHilfe: "\(HilfeTexte.tabObjektenListe)")
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


struct MyToolbarItemsPlusAndTrashTab2: ToolbarContent {
    //@ObservedObject var globaleVariable = GlobaleVariable.shared
    
    @State private var isParameterBereich: Bool = false
    @State private var gegenstandHinzufuegen: Bool = false
    @State private var errorMessageText = ""
    @State private var selectedTypeTmp = ""
    @State private var showAlert = false
    @State private var activeAlert: ActiveAlert = .error
    
    var body: some ToolbarContent {
        
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
                selectedTypeTmp = selectedGegenstandTab2
                
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
        
    } // Ende var
} // Ende Struct


struct MyToolbarItemsPlusAndTrashTab3: ToolbarContent {
    //@ObservedObject var globaleVariable = GlobaleVariable.shared
    
    @State private var isParameterBereich: Bool = false
    @State private var errorMessageText = ""
    @State private var selectedPickerTmp: String = ""
    
    @State private var personHinzufuegen: Bool = false
    @State private var showAlert = false
    @State private var activeAlertTab3: ActiveAlertTab3 = .error
    
    let anzahlDerPersonen = querySQLAbfrageClassPerson(queryTmp: "SELECT * FROM Personen", isObjectTabelle: false)
    
    var body: some ToolbarContent {
        
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
                    selectedPickerTmp = "\(selectedPersonPickerTab3 )"
                    
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
                                    
                                    selectedPersonPickerTab3 = ""
                                    
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
        
    } // Ende var
    
} // Ende struct


struct MyToolbarItemsHilfeButton: ToolbarContent {
    @ObservedObject var userSettingsDefaults = UserSettingsDefaults.shared
    
    @State private var showTabHilfe: Bool = false
    
    var body: some ToolbarContent {
        
        if userSettingsDefaults.showHandbuch == true {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action:{
                    showTabHilfe.toggle()
                    
                }) {
                    Image(systemName: "questionmark.circle.fill")
                } // Ende Button
                
                .alert("Hilfe für \(naviTitleUndHilfeText(tabNummer: navigationTabView).tabName)", isPresented: $showTabHilfe, actions: {}, message: { Text("\(naviTitleUndHilfeText(tabNummer: navigationTabView).tabHilfe)")
                    
                } // Ende message
                       
                ) // Ende .alert
                
            } // Ende ToolbarItemGroup
        } // Ende if
        
    } // Ende var body
} // Ende struct

struct MyToolbarPlusButtonTab1: ToolbarContent {
    //@ObservedObject var globaleVariable = GlobaleVariable.shared
    @ObservedObject var userSettingsDefaults = UserSettingsDefaults.shared
  
    @State private var showEingabeMaske: Bool = false
    @State private var showStoreAlert: Bool = false
    
    let purchaseManager = PurchaseManager()
    
    var body: some ToolbarContent {
        
        //if GlobalStorage.navigationTabView == 1 && UIDevice.current.userInterfaceIdiom == .phone {
        if  UIDevice.current.userInterfaceIdiom == .phone {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action:{
                    
                    if numberOfObjects < numberOfObjectsFree || purchaseManager.isPremium() == true {
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


struct MyToolbarItemsPrintButtonTab4: ToolbarContent {
    //@ObservedObject var globaleVariable = GlobaleVariable.shared
    //@ObservedObject var userSettingsDefaults = UserSettingsDefaults.shared
    
    var body: some ToolbarContent {
        
        // Wenn die Tabs PDF Liste oder Handbuch gezeigt werden
        // wird das Zeichen für Drucken gezeigt
        //if GlobalStorage.navigationTabView == 4 || GlobalStorage.navigationTabView == 5 {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action:{
                   // if GlobalStorage.navigationTabView == 4 {
                        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                        let pdfPath = docDir!.appendingPathComponent("ObjektenListe.pdf")
                        printingHandbuchFile(pdfPath: pdfPath, pdfName: " PDF Liste")
                    //} // Ende if
                    
                    
                    
                }) {
                    Image(systemName: "printer") // printer.fill square.and.arrow.up
                } // Ende Button
            } // Ende ToolbarGroup
        //} // Ende if
        
    } // Ende var body
} // Ende struct

struct MyToolbarItemsPrintButtonTab5: ToolbarContent {
    //@ObservedObject var globaleVariable = GlobaleVariable.shared
    //@ObservedObject var userSettingsDefaults = UserSettingsDefaults.shared
    
    var body: some ToolbarContent {
        
        // Wenn die Tabs PDF Liste oder Handbuch gezeigt werden
        // wird das Zeichen für Drucken gezeigt
        //if GlobalStorage.navigationTabView == 4 || GlobalStorage.navigationTabView == 5 {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            Button(action:{
            
                
               // if GlobalStorage.navigationTabView == 5 {
                    let pdfPath = Bundle.main.url(forResource: "L&S Handbuch", withExtension: "pdf")
                    printingHandbuchFile(pdfPath: pdfPath!, pdfName: " Handbuch")
                //} // Ende if
                
            }) {
                Image(systemName: "printer") // printer.fill square.and.arrow.up
            } // Ende Button
        } // Ende ToolbarGroup
        //} // Ende if
        
    } // Ende var body
} // Ende struct


struct MyToolbarItemsQueryButton: ToolbarContent {
    //@ObservedObject var globaleVariable = GlobaleVariable.shared
    
    let anzahlDerObjekte = querySQLAbfrageClassObjecte(queryTmp: "SELECT * FROM Objekte", abfrage: false)
    
    @State private var showAbfrageModalView: Bool = false
    
    var body: some ToolbarContent {
        
        // Wen sich keine Objekte in der Datenbank befinden
        // dann wird die Abfrage deaktiviert.
        //if GlobalStorage.navigationTabView == 1 || GlobalStorage.navigationTabView == 4 {
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
        //} // Ende if globaleVariable
        
    } // Ende var body
} // Ende struct


struct MyToolbarItemsHausButtonTab1: ToolbarContent {
    //@ObservedObject var globaleVariable = GlobaleVariable.shared
    @ObservedObject var userSettingsDefaults = UserSettingsDefaults.shared
   
    @State private var hilfeTexte = HilfeTexte()
    
    @State private var showAllgemeinesInfo: Bool = false
    
    var body: some ToolbarContent {
        
        if userSettingsDefaults.showHandbuch == true {
        //    if GlobalStorage.navigationTabView == 1 && userSettingsDefaults.showHandbuch == true {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button( action: {
                        showAllgemeinesInfo = true
                    }) {Image(systemName: "house").imageScale(.large)}
                        .alert("Allgemeine Information", isPresented: $showAllgemeinesInfo, actions: {
                            //Button(" - OK - ") {}
                        }, message: { Text("\(HilfeTexte.allgemeineAppInfo)") } // Ende message
                        ) // Ende alert
                } // Ende ToolbarItemGroup
            } // Ende if
        //} // Ende if
        
    } // Ende var body
} // Ende struct


struct MyToolbarItemsEditButtonTab4: ToolbarContent {
    //@ObservedObject var globaleVariable = GlobaleVariable.shared
    @ObservedObject var sheredData = SharedData.shared
    @State private var isSheetPresented: Bool = false
    //@State private var showAllgemeinesInfo: Bool = false
    //@State private var versionCounter: Int = 0
    
    //@State private var tabNumber: Int = 4
    
    var body: some ToolbarContent {
        
        //if GlobalStorage.navigationTabView == 4  {
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button( action: {
                    isSheetPresented.toggle()
                }) {
                    //Text("Bearbeiten")
                    Image(systemName: "pencil").imageScale(.large)
                }  // PDF-List
                .navigationDestination(isPresented: $isSheetPresented, destination: { ObjektenListeParameter(sheredData: sheredData, isPresented: $isSheetPresented)})
                    
            } // Ende ToolbarItemGroup
            
            
        //} // Ende if
            
        
    } // Ende var body
        

} // Ende struct
