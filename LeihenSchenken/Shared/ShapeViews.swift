//
//  ShapeViews.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 27.03.23.
//


import Foundation
import SwiftUI
import Contacts

struct ShapeViewAddGegenstand: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    //@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
   
    @Binding var isPresented: Bool
    @Binding var isParameterBereich: Bool
    
    @State var showHilfe: Bool = false
    @State var showWarnung: Bool = false
    
    @State var gegenstandNeu: String = ""
    
    @FocusState var isInputActive: Bool
    
    var body: some View {
        
       //NavigationStack {
            
            Form {
                Section(){
                    TextField("Gegenstand", text: $gegenstandNeu.max(20))
                        .focused($isInputActive)
                        .padding(5)
                        .background(Color(.systemGray6))
                        .submitLabel(.done)
                        .cornerRadius(5)
                        .disableAutocorrection(true)
                    
                } // Ende Section
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                    HStack {
                        Text("\(gegenstandNeu.count)/20")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.gray)
                            .padding()
                        Spacer()
                        
                        Button("Abbrechen") {
                            isInputActive = false
                            gegenstandNeu = ""
                           
                        } // Ende Button
                    } // Ende HStack
                    
                } // Ende ToolbarItemGroup
                } // Ende Toolbar
                
                HStack {
                    Spacer()
                    Button(action: {
                        isPresented = false
                      
                        //self.presentationMode.wrappedValue.dismiss()
                        print("Gegenstand wurde in die Auswahl nicht hinzugefügt!")
                    }) {Text("Abbrechen")}
                        .buttonStyle(.bordered).foregroundColor(.blue).font(.system(size: 16, weight: .regular))
                    
                    Button(action: {
                        if gegenstandNeu != "" {
                            if isParameterBereich {
                                globaleVariable.parameterGegenstand.append(gegenstandNeu)
                                // Es wird in der Eingabemaske bei Gegenstand der neue Gegenstand ausgewählt
                                globaleVariable.selectedGegenstandInt = globaleVariable.parameterGegenstand.count-1
                                isPresented = false
                                print("Gegenstand wurde in die Auswahl hinzugefügt!")
                            }else{
                                if pruefenDieElementeDerDatenbank(parPerson: ["","",""], parGegenstand: gegenstandNeu) {
                                    
                                    showWarnung = true
                                    
                                }else{
                                    
                                    gegenstandInDatenbankSchreiben(par1: gegenstandNeu)
                                    globaleVariable.parameterGegenstand.removeAll()
                                    globaleVariable.parameterGegenstand = querySQLAbfrageArray(queryTmp: "Select gegenstandName FROM Gegenstaende")
                                    
                                    print("Gegenstand wurde in die Datenbank hinzugefügt!")
                                    
                                    isPresented = false
                                } // Ende guard/else
                                
                            } // Ende if/else
                            
                        } // Ende if
                    }) {
                        
                        Text("Speichern")
                        
                    }// Ende Button
                    .disabled(gegenstandNeu != "" ? false : true)
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .regular))
                    .cornerRadius(10)
                    
                    Spacer()
                    
                } // Ende Hstack
                .alert("Warnung zu neuem Gegenstand", isPresented: $showWarnung, actions: {
                    Button(" - OK - ") {}
                }, message: { Text("Der Gegenstand: '\(gegenstandNeu)' befindet sich schon in der Datenbank. In der Datenbank können keine Duplikate von Gegenständen gespeichert werden!") } // Ende message
                ) // Ende alert
                
                if isParameterBereich {
                    Text("Die Taste 'Speichern' wird aktiv, wenn der Gegenstand erfasst wurde. Dann mit drücken auf 'Speichern' wird der Gegenstand nur zur Auswahl in die Eingabemaske hinzugefügt. Er wird nach beenden der App entfernt. Möchten Sie ein Gegenstand dauerhaft zur Auswahl in der Eingabemaske hinzufügen, gehen Sie bitte zum Tab 'Gegenstände' und dort unten links auf das '+' Symbol. Auf der entsprechender Maske geben Sie den Gegenstand ein und speichen ihn.")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                }else{
                    Text("Die Taste 'Speichern' wird aktiv, wenn der Gegenstand erfasst wurde. Dann beim drücken auf 'Speichern' wird der neue Gegenstand dauerhaft in die Datenbank hinzugefügt.")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.gray)
                    
                } // Ende if/else
                
            } // Ende Form
            .navigationTitle("Neuer Gegenstand").navigationBarTitleDisplayMode(.inline)
            .scrollContentBackground(.hidden)
            
        //} // Ende NavigationStack
        .interactiveDismissDisabled()  // Disable dismiss with a swipe
        
    } // Ende var body
} // Ende struct


struct ShapeViewSettings: View {
    //@Environment(\.presentationMode) var presentationMode
    @Binding var isPresented: Bool
    
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @ObservedObject var userSettingsDefaults = UserSettingsDefaults.shared
    
    @State var showSettingsHilfe: Bool = false
    
    @State var colorData = ColorData()
    
    var body: some View {
       
        
        NavigationStack {
            
            Form {
                
                Section(header: Text("Farbeinstellung")) {
                    ColorPicker("Farben für Ebene 0", selection:  $globaleVariable.farbenEbene0, supportsOpacity: false)
                        .onAppear ( perform: {globaleVariable.farbenEbene0 = colorData.loadColor0()})
                        .frame(width: 300, height: 40)
                    
                    ColorPicker("Farben für Ebene 1", selection: $globaleVariable.farbenEbene1, supportsOpacity: false)
                        .onAppear ( perform: {globaleVariable.farbenEbene1 = colorData.loadColor1()})
                        .frame(width: 300, height: 40)
                    
                }// Ende Section Farben
                Section {
                    Toggle("Tab Handbuch anzeigen", isOn: $userSettingsDefaults.showHandbuch ).toggleStyle(SwitchToggleStyle(tint: .blue))
                } // Ende Section
                
                // Prüfen, ob iClaud verfügbar ist
                if isICloudContainerAvailable() {
                    Section {
                        Toggle("iCloud Sicherung", isOn: $userSettingsDefaults.iCloudSwitch ).toggleStyle(SwitchToggleStyle(tint: .blue))
                        
                    } footer: {
                        
                        Text("Beim einschalten der iCloud Sicherung, wird die Datensicherung in der iCloud gespeichert. Dadurch wird es möglich sein, diese Datensicherung auf Ihrem anderen Gerät (iPhone oder iPad) einzuspielen.")
                        
                    } // Ende Section
                
                } // Ende if
                HStack {
                    Spacer()
                    
                    Button() {
                        
                        colorData.saveColor(color0: globaleVariable.farbenEbene0, color1: globaleVariable.farbenEbene1)
                        //presentationMode.wrappedValue.dismiss()
                        isPresented = false
                    }label: {
                     //Text("Parameterfenster verlassen.")
                        Label("Einstellungenfenster verlassen", systemImage: "arrowshape.turn.up.backward.circle")
                        
                    } // Ende Button Text
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .regular))
                        
                    Spacer()
                } // Ende HStack
                
                Text("Beim Drücken auf 'Einstellungenfenster verlassen' wird das Fenster geschloßen und die einzehlen Parameter werden gespeichert.")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.gray)
                
            } // Ende Form
            .font(.system(size: 14, weight: .regular))
            .navigationTitle("App-Einstellungen").navigationBarTitleDisplayMode(.inline)
            
        } // Ende NavigationStack
        .interactiveDismissDisabled()  // Disable dismiss with a swipe
        
    } // Ende var body
} // Ende struct ShapeViewSettings


struct ShapeViewAbfrage: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @ObservedObject var userSettingsDefaults = UserSettingsDefaults.shared
    
    @Binding var isPresented: Bool
    
    @State var showAbfrageHilfe: Bool = false
    @State var showAlertAbbrechenButton: Bool = false
    @State var showAlertSpeichernButton: Bool = false
    
    @State var abfrageFeld1: [String] = ["Gegenstand", "Vorgang","Name", "Vorname"]
    @State var selectedAbfrageFeld1 = "Gegenstand"
    @State var abfrageFeld2: [String] = ["gleich", "ungleich"]
    @State var selectedAbfrageFeld2 = "gleich"
    @State var abfrageFeld3: [String] = querySQLAbfrageArray(queryTmp: "SELECT DISTINCT Gegenstand FROM Objekte ORDER BY Gegenstand")
    @State var selectedAbfrageFeld3 = querySQLAbfrageArray(queryTmp: "SELECT DISTINCT Gegenstand FROM Objekte ORDER BY Gegenstand")[0]
    
    var body: some View {
        
        VStack {
            //Text("")
            //Text("Abfragefilter").bold()
            NavigationStack {
                Form {
                    Section(header: Text("Bedingung").font(.system(size: 16, weight: .regular))) {
                        Picker("Wenn ", selection: $selectedAbfrageFeld1, content: {
                            ForEach(abfrageFeld1, id: \.self, content: { index1 in
                                Text(index1)
                            })
                        })
                        .font(.system(size: 16, weight: .regular))
                        .frame(height: 30)
                        .onAppear(perform: {
                            
                            abfrageFeld3 = abfrageField3(field1: selectedAbfrageFeld1)
                            print("Feld1 onAppear")
                        })
                        .onChange(of: selectedAbfrageFeld1, perform: { _ in
                            
                            abfrageFeld3 = abfrageField3(field1: selectedAbfrageFeld1)
                            selectedAbfrageFeld3 = abfrageFeld3[0]
                            print("Feld1 onChange")
                        }) // Ende onChange...
                        
                        HStack{
                            Text("ist  ")
                                .font(.system(size: 16, weight: .regular))
                            
                            Picker("", selection: $selectedAbfrageFeld2, content: {
                                ForEach(abfrageFeld2, id: \.self, content: { index2 in
                                    Text(index2)
                                })
                            })
                            //.pickerStyle(.inline)
                            .frame(height: 30)
                            .font(.system(size: 16, weight: .regular))
                        } // Ende HStack
                        
                        Picker("", selection: $selectedAbfrageFeld3, content: {
                            ForEach(abfrageFeld3, id: \.self, content: { index3 in
                                Text(index3)
                            })
                            .font(.system(size: 16, weight: .regular))
                        })
                        .frame(height: 30)
                        .onAppear(perform: {
                            print("\(selectedAbfrageFeld3)")
                            print("Feld3 onAppear")
                        })
                        .onChange(of: selectedAbfrageFeld3, perform: {  _ in
                            print("\(selectedAbfrageFeld3)")
                            print("Feld3 onChange")
                        })
                    } // Ende Section
                    
                    Section(header: Text("Filteraktivierung").font(.system(size: 16, weight: .regular))) {
                        Toggle("Filterschalter:", isOn: $globaleVariable.abfrageFilter ).toggleStyle(SwitchToggleStyle(tint: .blue))
                            .font(.system(size: 16, weight: .regular))
                    } // Ende Section
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            var tmpFeld1 = ""
                            if globaleVariable.abfrageFilter == true {
                                
                                switch selectedAbfrageFeld1 {
                                        
                                    case "Gegenstand":
                                        tmpFeld1 = selectedAbfrageFeld1
                                    case "Vorgang":
                                        tmpFeld1 = selectedAbfrageFeld1
                                    case "Name":
                                        tmpFeld1 = "personNachname"
                                    case "Vorname":
                                        tmpFeld1 = "personVorname"
                                    default:
                                        tmpFeld1 = ""
                                        
                                } // Ende switch
                                
                                let temp = " WHERE " + "\(tmpFeld1)" + " = " + "'" + "\(selectedAbfrageFeld3)" + "'"
                                globaleVariable.abfrageQueryString = temp
                                
                            }else{
                                globaleVariable.abfrageQueryString = ""
                            } // Ende if
                            globaleVariable.navigationTabView = 1
                            
                            isPresented = false
                            
                        } label: {
                            //Text("Abfrage verlassen")
                            Label("Abfrage verlassen", systemImage: "arrowshape.turn.up.backward.circle")
                            
                            
                        } // Ende Button/label
                        .buttonStyle(.borderedProminent)
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .regular))
                        
                        Spacer()
                    } // Ende HStack
                    
                    //Section {
                    Text("Hier können Sie eine Abfrage für Darstellung der Objektenabelle definieren und speichern. Die Abfrage behält ihre Gültigkeit bis zum erneutem Start dieser Darstellung.")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.gray)
                    
                    //} // Ende Section
                } // Ende Form
                .navigationTitle("Abfrage").navigationBarTitleDisplayMode(.inline)
                .background(globaleVariable.farbenEbene1)
                .cornerRadius(10)
                
            } // Ende NavigationStack
        } // Ende VStack
        .interactiveDismissDisabled()  // Disable dismiss with a swipe
        
    } // Ende var body
} // Ende struct

// Wird bei Objekt editieren aufgerufen und nicht bei Tab Personen
struct ShapeViewEditUser: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @Binding var isPresentedShapeViewEditUser: Bool
    @Binding var personPickerTmp: String
    @Binding var neuePersonTmp: [PersonClassVariable]
    
    @State var showHilfe: Bool = false
    
    @State var selectedPerson_sexInt: Int = 0
    
    @FocusState private var focusedField: Field?
    
    private enum Field: Int, CaseIterable {
        case vorname // Für Vorname
        case name // Für Nachname
        
    } // Ende private enum
    
    var body: some View {
        //NavigationStack {
            Form {
                Section() {
                    
                    TextField("Vorname", text: $neuePersonTmp[0].personVorname)
                        .focused($focusedField, equals: .vorname)
                        .padding(5)
                        .background(Color(.systemGray6))
                        .cornerRadius(5)
                        .submitLabel(.done)
                        .disableAutocorrection(true)
                    
                    TextField("Namen", text: $neuePersonTmp[0].personNachname)
                        .focused($focusedField, equals: .name)
                        .padding(5)
                        .background(Color(.systemGray6))
                        .cornerRadius(5)
                        .submitLabel(.done)
                        .disableAutocorrection(true)
                } // Ende Section
                
                
                Section() {
                    Picker("Geschlecht:", selection: $selectedPerson_sexInt) {
                        
                        ForEach(0..<globaleVariable.parameterPersonSex.count, id: \.self) { index in
                            Text("\(globaleVariable.parameterPersonSex[index])")
                            
                        } // Ende ForEach
                    } // Ende Picker
                   
                } // Ende Section
                
                HStack {
                    Spacer()
                    Button(action: { isPresentedShapeViewEditUser = false }) {Text("Abbrechen")}
                        .buttonStyle(.bordered).foregroundColor(.blue).font(.system(size: 16, weight: .regular))
                    
                    Button(action: {
                        // Hier aktion für speichern
                        
                        if neuePersonTmp[0].personVorname != "" || neuePersonTmp[0].personNachname != "" {
                            personPickerTmp = " " + neuePersonTmp[0].personNachname + ", " + neuePersonTmp[0].personVorname + " "
                            isPresentedShapeViewEditUser = false
                            
                        } else {
                            
                            print("Die Felder sind leer")
                        } // Ende if/else
                        
                    }) {
                        
                        Text("Speichern")
                        
                    } // Ende Button
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .regular))
                    .cornerRadius(10)
                    Spacer()
                } // Ende HStack
                
                
            } // Ende Form
            .navigationTitle("Benutzer bearbeiten").navigationBarTitleDisplayMode(.inline)
            
        //} // Ende NavigationStack
        .interactiveDismissDisabled()  // Disable dismiss with a swipe
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                if focusedField == .vorname {
                    HStack {
                        
                        Text("\(neuePersonTmp[0].personVorname.count)/15")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.gray)
                            .padding()
                        
                        Spacer()
                        
                         Button("Abbrechen") {
                         //neuePersonTmp[0].personVorname = ""
                         focusedField = nil
                         print("Abbrechen Button Vorname wurde gedrückt!")
                         } // Ende Button
                         
                    } // Ende HStack
                }else if focusedField == .name  {
                    HStack{
                        
                        Text("\(neuePersonTmp[0].personNachname.count)/25")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.gray)
                            .padding()
                        
                        Spacer()
                        
                         Button("Abbrechen") {
                         //neuePersonTmp[0].personNachname = ""
                         focusedField = nil
                         print("Abbrechen Button Nachname wurde gedrückt!")
                         } // Ende Button
                         
                    } // Ende HStack
                } // Ende if/else
                
            } // Ende ToolbarItemGroup
            
        } // Ende toolbar
        .font(.system(size: 16, weight: .regular))
        
    } // Ende var body
} // Ende struct

struct ShapeShowDetailPhoto: View {
    @Binding var isPresentedShowDetailPhoto: Bool
    @Binding var par1: [ObjectVariable]
    @Binding var par2: Int
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                Form {
                    VStack{
                        Image(base64Str: par1[par2].gegenstandBild)!
                            .resizable()
                            .scaledToFill()
                            .scaledToFit()
                            .clipped()
                            .cornerRadius(10)
                            .padding(5)
                        
                        Button {
                            isPresentedShowDetailPhoto = false
                            
                        } label: {
                            Label("Bildansicht verlassen", systemImage: "arrowshape.turn.up.backward.circle")
                            
                        } // Ende Button
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color.white)
                        .buttonStyle(.borderedProminent)
                        
                    } // Ende Vstak
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.9)
                } // Ende Form
                .navigationTitle("Detailsicht Photo").navigationBarTitleDisplayMode(.inline)
            } // Ende GeometryReader
        } // NavigationStack
        .interactiveDismissDisabled()  // Disable dismiss with a swipe
        
    } // Ende var body
    
} // Ende ShapeshowDetailPhoto

