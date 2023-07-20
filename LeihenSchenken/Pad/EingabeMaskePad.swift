//
//  EingabeMaskePad.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 19.07.23.
//

import SwiftUI
//import PhotosUI
//import UIKit
import SQLite3


struct EingabeMaskePadView: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @ObservedObject var hilfeTexte = HilfeTexte.shared
    @StateObject var cameraManager = CameraManager()
    
    @State var showParameterHilfe: Bool = false
    @State var showParameterAllgemeinesInfo: Bool = false
    @State var showAlerOKButton: Bool = false
    @State var showAlertAbbrechenButton: Bool = false
    @State var showAlertSpeichernButton: Bool = false
    
    //@State var showCameraButton: Bool = false
    
    @State var showSheetPerson: Bool = false
    @State var showSheetGegenstand: Bool = false
    @State var isParameterBereich: Bool = true
    
    @FocusState private var focusedField: Field?
    
    private enum Field: Int, CaseIterable {
        case amount // Für Preis/Wert
        case str1 // Für Gegenstandbeschreibung
        case str2 // Für allgemeine Informationen
        
    } // Ende private enum
    
    @State private var calendarId: Int = 0
    
    @State var platzText1: String = "Gegenstandbeschreibung"
    @State var platzText2: String = "Allgemeine Notizen"
    @State var selectedGegenstand: String = ""
    @State var selectedPerson: String = ""
    
    @State private var text: String = ""
    @State private var platz: String = ""
    
    @State var imageData = UIImage()
     
    private let numberFormatter: NumberFormatter
    private let perKeyFormatter: DateFormatter
    private let germanDateFormatter: DateFormatter
    
    init() {
        numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 2
        
        perKeyFormatter = DateFormatter()
        perKeyFormatter.dateFormat = "y MM dd, HH:mm"
        
        germanDateFormatter = DateFormatter()
        germanDateFormatter.locale = .init(identifier: "de")
        germanDateFormatter.dateFormat = "d MMM yyyy"
        germanDateFormatter.dateStyle = .long
        germanDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
    } // Ende init
    
    var body: some View {
        
        let tapOptionGegenstand = Binding<Int>(
            get: { globaleVariable.selectedGegenstandInt }, set: { globaleVariable.selectedGegenstandInt = $0
                
                //Add the onTapGesture contents here
                if globaleVariable.parameterGegenstand[globaleVariable.selectedGegenstandInt] == "Neuer Gegenstand" {
                   showSheetGegenstand = true
                   selectedGegenstand = "Neuer Gegenstand"
                }else{
                    selectedGegenstand = globaleVariable.parameterGegenstand[globaleVariable.selectedGegenstandInt]
                } // Ende if
            } // Ende set
        ) // Ende let
        
        let tapOptionPerson = Binding<Int>(
            get: { globaleVariable.selectedPersonInt }, set: { globaleVariable.selectedPersonInt = $0
                
                //Add the onTapGesture contents here
                if globaleVariable.personenParameter[globaleVariable.selectedPersonInt].personPicker == "Neue Person" {
                   showSheetPerson = true
                   selectedPerson = "Neue Person"
                }else{
                    selectedPerson = globaleVariable.personenParameter[globaleVariable.selectedPersonInt].personPicker
                } // Ende if
            } // Ende set
        ) // Ende let
        
            GeometryReader { geometry in
                
                VStack {
                    Text("")
                    Form {
                        
                        
                        Picker("Gegenstand: ", selection: tapOptionGegenstand, content: {
                            ForEach(0..<$globaleVariable.parameterGegenstand.count, id: \.self) { index in
                                Text("\(globaleVariable.parameterGegenstand[index])")//.tag(index)
                            } // Ende ForEach
                            
                        })
                        .font(.system(size: 16, weight: .regular))
                        .sheet(isPresented: $showSheetGegenstand, content: { ShapeViewAddGegenstand(isPresented: $showSheetGegenstand, isParameterBereich: $isParameterBereich )})
                        
                        TextEditorWithPlaceholder(text: $globaleVariable.textGegenstandbeschreibung, platz: $platzText1)
                           .focused($focusedField, equals: .str1)
                        
                        HStack {
                            Text("Gegenstandsbild:   ")
                                .frame(height: 50)
                                .font(.system(size: 16, weight: .regular))
                            
                            ImageSelector()
                            Text(" ")
                            if cameraManager.permissionGranted {
                               PhotoSelector()
                            }
                            //Text(" ")
                            
                            if globaleVariable.parameterImageString != "Kein Bild" {
                                let imageData = Data (base64Encoded: globaleVariable.parameterImageString)!
                                let image = UIImage (data: imageData)!
                                
                                Image(uiImage: image)
                                    .resizable()
                                    .cornerRadius(50)
                                    .padding(.all, 4)
                                    .frame(width: 50, height: 50)
                                    .background(Color.black.opacity(0.2))
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                
                            } // Ende if
                            
                        } // Ende HStack
                        .onAppear {
                            cameraManager.requestPermission()
                        } // Ende onAppear
                        
                        HStack {
                            
                            Text("Preis/Wert:  ")
                                .frame(height: 35, alignment: .leading)  // width: 190,
                                .font(.system(size: 16, weight: .regular))
                            Spacer()
                            //Text(String(repeating: " ", count: 28))
                            TextField("0.00 €", text: $globaleVariable.preisWert)
                            
                                .modifier(TextFieldEuro(textParameter: $globaleVariable.preisWert))
                                .multilineTextAlignment(.trailing)
                                .frame(width: 115, height: 35, alignment: .trailing)
                                .background(Color(.systemGray6))
                                .cornerRadius(5)
                                .font(.system(size: 16, weight: .regular))
                                .keyboardType(.decimalPad)
                                .focused($focusedField, equals: .amount)
                            
                            //Text("€").font(.system(size: 16, weight: .regular))
                               
                        } // Ende HStack
                        //.frame(width: UIScreen.screenWidth)
                        
                        HStack{
                            Text("Datum:")
                                .font(.system(size: 16, weight: .regular))
                            Spacer()
                            DatePicker("", selection: $globaleVariable.datum, displayedComponents: [.date])
                                .labelsHidden()
                                .colorInvert()
                                .colorMultiply(Color.gray)
                                //.font(.system(size: 16, weight: .regular))
                                .multilineTextAlignment (.center)
                                .environment(\.locale, Locale.init(identifier: "de"))
                                .transformEffect(.init(scaleX: 0.9, y: 0.9))
                                .id(calendarId)
                                .onChange(of: globaleVariable.datum, perform: { _ in
                                    calendarId += 1
                                }) // Ende onChange...
                                
                        } //Ende HStack
                     
                        
                        Picker("Vorgang: ", selection: $globaleVariable.selectedVorgangInt, content: {
                            ForEach(0..<$globaleVariable.parameterVorgang.count, id: \.self) { index in
                                Text("\(globaleVariable.parameterVorgang[index])")//.tag(index)
                            } // Ende ForEach
                        }) // Picker
                        .font(.system(size: 16, weight: .regular))
                        
                        Picker("Person: ", selection: tapOptionPerson, content: {
                            ForEach(0..<$globaleVariable.personenParameter.count, id: \.self) { index in
                                Text("\(globaleVariable.personenParameter[index].personPicker)")//.tag(index)
                            } // Ende ForEach
                        }) // Picker
                        .font(.system(size: 16, weight: .regular))
                        .sheet(isPresented: $showSheetPerson, content: { ShapeViewAddUser(isPresented: $showSheetPerson, isParameterBereich: $isParameterBereich) })
                        
                        TextEditorWithPlaceholder(text: $globaleVariable.textAllgemeineNotizen, platz: $platzText2)
                        //.focused($preisWertIsFocused)
                            .focused($focusedField, equals: .str2)
                        
                        VStack{
                            Text("").frame(height: 20)
                            
                            HStack {
                                Spacer()
                                Button(action: {showAlertAbbrechenButton = true}) { Text("Abbrechen") } .buttonStyle(.bordered).foregroundColor(.blue).font(.system(size: 16, weight: .regular))
                                    .alert(isPresented:$showAlertAbbrechenButton) {
                                        Alert(
                                            title: Text("Möchten Sie alle Eingaben unwiederfuflich löschen?"),
                                            message: Text("Man kann den Vorgang nicht rückgängich machen!"),
                                            primaryButton: .destructive(Text("Löschen")) {
                                                
                                                // Die Parameterwerte werden gelöscht.
                                                cleanEingabeMaske()
                                                
                                            },
                                            secondaryButton: .cancel(Text("Abbrechen")){
                                                //print("\(globaleVariable.parameterPerson[globaleVariable.selectedPersonInt])")
                                                print("Abgebrochen ....")
                                            } // Ende secondary Button
                                        ) // Ende Alert
                                    } // Ende alert
                                
                                Button(action: {showAlertSpeichernButton = true}) { Text("Speichern")}
                                    .disabled(parameterCheck(parGegenstand: "\(globaleVariable.parameterGegenstand)", parPerson: "\(globaleVariable.personenParameter[globaleVariable.selectedPersonInt].personVorname)"))
                                    .buttonStyle(.borderedProminent)
                                    .foregroundColor(.white).font(.system(size: 16, weight: .regular))
                                    .alert(isPresented:$showAlertSpeichernButton) {
                                        Alert(
                                            title: Text("Möchten Sie alle Eingaben speichern?"),
                                            message: Text("Die Daten werden in die Datenbank gespeichert und die Eingabemaske wird geleert!"),
                                            primaryButton: .destructive(Text("Speichern")) {
                                                
                                                // perKey ist die einmahlige Zahgl zum eindeutigen definieren jeden Datensatzes
                                                let perKey = erstellePerKey(par1: perKeyFormatter.string(from: globaleVariable.datum))
                                                
                                                //let personIntTmp = globaleVariable.selectedPersonInt
                                                let personVornameTmp = globaleVariable.personenParameter[globaleVariable.selectedPersonInt].personVorname
                                                let personNachnameTmp = globaleVariable.personenParameter[globaleVariable.selectedPersonInt].personNachname
                                                let persoSexTmp = globaleVariable.personenParameter[globaleVariable.selectedPersonInt].personSex
                                                
                                                let insertDataToDatenbank = "INSERT INTO Objekte(perKey, gegenstand, gegenstandText, gegenstandBild, preisWert, datum, vorgang, personVorname, personNachname, personSex, allgemeinerText) VALUES('\(perKey)','\(globaleVariable.parameterGegenstand[globaleVariable.selectedGegenstandInt])', '\(globaleVariable.textGegenstandbeschreibung)','\(globaleVariable.parameterImageString)','\(globaleVariable.preisWert)', '\(dateToString(parDatum: globaleVariable.datum))', '\(globaleVariable.parameterVorgang[globaleVariable.selectedVorgangInt])', '\(personVornameTmp)', '\(personNachnameTmp)', '\(persoSexTmp)', '\(globaleVariable.textAllgemeineNotizen)')"
                                                
                                                if sqlite3_exec(db, insertDataToDatenbank, nil, nil, nil) !=
                                                    SQLITE_OK {
                                                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                                                    print("error -->: \(errmsg)")
                                                    print("Daten wurden nicht hinzugefügt")
                                                }else{
                                                    
                                                    // Die Parameterwerte wurden in die Tabelle geschrieben.
                                                    
                                                    cleanEingabeMaske()
                                                    print("In der Tabelle Gespeichert...")
                                                    
                                                } // End if/else
                                                
                                            },
                                            secondaryButton: .cancel(Text("Abbrechen")){
                                                print("Abgebrochen ....")
                                            } // Ende secondaryButton
                                        ) // Ende Alert
                                    } // Ende alert
                                Spacer()
                            } // Ende HStack
                            
                        } // Ende VStack
                        
                        .toolbar {ToolbarItemGroup(placement: .keyboard) {
                            
                            if focusedField == .amount {
                                Spacer()
                                Button("Fertig") {
                                    //preisWertIsFocused = false
                                    focusedField = nil
                                    print("OK Button wurde gedrückt!")
                                } // Ende Button
                            }else if focusedField == .str1 {
                                HStack {
                                    Text("\(globaleVariable.textGegenstandbeschreibung.count)/100")
                                        .font(.system(size: 16, weight: .regular))
                                        .foregroundColor(.gray)
                                        .padding()
                                    Spacer()
                                    Button("Abbrechen") {
                                        //preisWertIsFocused = false
                                        globaleVariable.textGegenstandbeschreibung = ""
                                        focusedField = nil
                                        print("Abbrechen Button Str1 wurde gedrückt!")
                                    } // Ende Button
                                    .font(.system(size: 16, weight: .regular))
                                } // Ende HStack
                            }else if focusedField == .str2  {
                                HStack{
                                    Text("\(globaleVariable.textAllgemeineNotizen.count)/100")
                                        .font(.system(size: 16, weight: .regular))
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Button("Abbrechen") {
                                        //preisWertIsFocused = false
                                        globaleVariable.textAllgemeineNotizen = ""
                                        focusedField = nil
                                        print("Abbrechen Button Str2 wurde gedrückt!")
                                    } // Ende Button
                                } // Ende HStack
                            } // Ende if/else
                            
                        } // Ende ToolbarItemGroup
                        } // Ende toolbar
                        
                    } // Ende Form
                    
                } // Ende VStack
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(globaleVariable.farbenEbene0)
                
                
            } // Ende GeometryReader
            .navigationTitle("Eingabemaske")
        
            .toolbar {ToolbarItem(placement: .navigationBarLeading) {
                
                if UIDevice.current.userInterfaceIdiom == .phone {
                    
                    if anzahlDerDatensaetze(tableName: "Objekte") == 0 {
                        NavigationLink(destination: EmptyView()){
                            Label("", systemImage: "sidebar.left")
                            
                        } // Ende NavigationLink
                    }else{
                        NavigationLink(destination: DeteilView()){
                            Label("", systemImage: "sidebar.left")
                            
                        } // Ende NavigationLink
                        
                    } // Ende if/else
                    
                } // Ende UIDevice
                
            } // Ende ToolbarItem
                
            } // Ende toolbar
            .navigationBarItems(trailing: Button( action: {
                showParameterHilfe = true
            }) {Image(systemName: "questionmark.circle.fill").imageScale(.large)} )
            .alert("Hilfe zu Eingabemaske", isPresented: $showParameterHilfe, actions: {
               // Button(" - OK - ") {}
            }, message: { Text("\(hilfeTexte.eingabeMaske)") } // Ende message
            ) // Ende alert
            .navigationBarItems(trailing: Button( action: {
                showParameterAllgemeinesInfo = true
            }) {Image(systemName: "house").imageScale(.large)} )
            .alert("Allgemeine Information", isPresented: $showParameterAllgemeinesInfo, actions: {
                //Button(" - OK - ") {}
            }, message: { Text("\(hilfeTexte.allgemeineAppInfo)") } // Ende message
            ) // Ende alert
       
    } // Ende var body
    
} // Ende struct
