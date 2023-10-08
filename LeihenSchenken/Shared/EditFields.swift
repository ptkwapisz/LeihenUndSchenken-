//
//  EditFields.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 21.06.23.
//


import Foundation
import SwiftUI
import Combine

struct EditSheetView: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @Binding var isPresentedChartViewEdit: Bool
    @Binding var par1: [ObjectVariable]
    @Binding var par2: Int
    
    @State var disableSpeichern: Bool = false
    @State var showChartHilfe: Bool = false
    @State var gegenstandTmp: String = ""
    @State var gegenstandTextTmp: String = ""
    @State var allgemeinerTextTmp: String = ""
    @State var datumTmp: Date = Date()
    @State var preisWertTmp: String = ""
    @State var gegenstandBildTmp: String = ""
    @State var vorgangTmp: String = ""
    @State var personPickerTmp: String = ""
    @State var neuePersonTmp: [PersonClassVariable] = [PersonClassVariable(perKey: "", personPicker: "", personVorname: "", personNachname: "", personSex: "")]
    
    @FocusState private var focusedEditField: editField?
    
    private enum editField: Int, CaseIterable {
        case gegenstandKeyboard // Für Gegenstand
        case betragKeyboard // Für Preis/Wert
        case text1Keyboard // Für Gegenstandbeschreibung
        case text2Keyboard // Für allgemeine Informationen
        
    } // Ende private enum
    
    var body: some View {
        
        //NavigationStack {
            GeometryReader { geometry in
                
                Form {
                    Section{
                        
                        EditGegenstand(par1: $par1, par2: $par2, gegenstandTmp: $gegenstandTmp)
                            .focused($focusedEditField, equals: .gegenstandKeyboard)
                        EditGegenstandText(par1: $par1, par2: $par2, gegenstandTextTmp: $gegenstandTextTmp)
                            .focused($focusedEditField, equals: .text1Keyboard)
                        EditGegenstandBild(par1: $par1, par2: $par2, gegenstandBildTmp: $gegenstandBildTmp)
                        EditPreisWert(par1: $par1, par2: $par2, preisWertTmp: $preisWertTmp)
                            .focused($focusedEditField, equals: .betragKeyboard)
                        EditDatum(par1: $par1, par2: $par2, datumTmp: $datumTmp)
                        EditVorgang(par1: $par1, par2: $par2, vorgangTmp: $vorgangTmp)
                        EditPerson(par1: $par1, par2: $par2, personPickerTmp: $personPickerTmp, neuePersonTmp: $neuePersonTmp)
                        EditAllgemeinerText(par1: $par1, par2: $par2, allgemeinerTextTmp: $allgemeinerTextTmp)
                            .focused($focusedEditField, equals: .text2Keyboard)
                    } // Ende Section
                    
                    Section{
                        HStack {
                            Spacer()
                            Button("Abbrechen"){
                                isPresentedChartViewEdit = false
                                globaleVariable.parameterImageString = "Kein Bild"
                            } // Ende Button
                            .buttonStyle(.bordered)
                            .foregroundColor(.blue)
                            .fontWeight(.semibold)
                            .font(.system(size: 16, weight: .regular))
                            
                            Button("Speichern") {
                                
                                updateSqliteTabellenField(sqliteFeld: "gegenstand", neueInhalt: gegenstandTmp, perKey: par1[par2].perKey)
                                par1[par2].gegenstand = gegenstandTmp
                                
                                updateSqliteTabellenField(sqliteFeld: "gegenstandText", neueInhalt: gegenstandTextTmp, perKey: par1[par2].perKey)
                                par1[par2].gegenstandText = gegenstandTextTmp
                                
                                updateSqliteTabellenField(sqliteFeld: "gegenstandbild", neueInhalt: gegenstandBildTmp, perKey: par1[par2].perKey)
                                par1[par2].gegenstandBild = gegenstandBildTmp
                                
                                updateSqliteTabellenField(sqliteFeld: "preiswert", neueInhalt: preisWertTmp, perKey: par1[par2].perKey)
                                par1[par2].preisWert = preisWertTmp
                                
                                par1[par2].datum = dateToString(parDatum: datumTmp)
                                updateSqliteTabellenField(sqliteFeld: "datum", neueInhalt: par1[par2].datum, perKey: par1[par2].perKey)
                                
                                updateSqliteTabellenField(sqliteFeld: "vorgang", neueInhalt: vorgangTmp, perKey: par1[par2].perKey)
                                par1[par2].vorgang = vorgangTmp
                                
                                updateSqliteTabellenField(sqliteFeld: "personVorname", neueInhalt: neuePersonTmp[0].personVorname, perKey: par1[par2].perKey)
                                par1[par2].personVorname = neuePersonTmp[0].personVorname
                                
                                updateSqliteTabellenField(sqliteFeld: "personNachname", neueInhalt: neuePersonTmp[0].personNachname, perKey: par1[par2].perKey)
                                par1[par2].personNachname = neuePersonTmp[0].personNachname
                                
                                updateSqliteTabellenField(sqliteFeld: "personSex", neueInhalt: neuePersonTmp[0].personSex, perKey: par1[par2].perKey)
                                par1[par2].personSex = neuePersonTmp[0].personSex
                                
                                updateSqliteTabellenField(sqliteFeld: "allgemeinerText", neueInhalt: allgemeinerTextTmp, perKey: par1[par2].perKey)
                                par1[par2].allgemeinerText = allgemeinerTextTmp
                                
                                globaleVariable.parameterImageString = "Kein Bild"
                                refreshAllViews()
                                isPresentedChartViewEdit = false
                                
                            } // Ende Button
                            .buttonStyle(.borderedProminent)
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .font(.system(size: 16, weight: .regular))
                            .disabled(disableSpeichern)
                            Spacer()
                        } // Ende HStack
                    } // Ende Section
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                        
                        if focusedEditField == .gegenstandKeyboard {
                            HStack {
                                Text("\(gegenstandTmp.count)/25")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.gray)
                                Spacer()
                                Button("Abbrechen") {
                                    //isInputGegenstandActive = false
                                    gegenstandTmp = par1[par2].gegenstand
                                    focusedEditField = nil
                                } // Ende Button
                                .buttonStyle(.bordered)
                            } // Ende HStack
                            .font(.system(size: 16, weight: .regular))
                        } else if focusedEditField == .text1Keyboard {
                            HStack {
                                Text("\(gegenstandTextTmp.count)/100")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.gray)
                                Spacer()
                                Button("Abbrechen") {
                                    gegenstandTextTmp = par1[par2].gegenstandText
                                    focusedEditField = nil
                                } // Ende Button
                                .buttonStyle(.bordered)
                            } // Ende HStack
                            .font(.system(size: 16, weight: .regular))
                            
                        } else if focusedEditField == .betragKeyboard {
                            HStack {
                                
                                Spacer()
                                Button("Fertig") {
                                    //preisWertTmp = par1[par2].preisWert
                                    focusedEditField = nil
                                } // Ende Button
                                .buttonStyle(.bordered)
                            } // Ende HStack
                            .font(.system(size: 16, weight: .regular))
                        } else if focusedEditField == .text2Keyboard {
                            HStack {
                                Text("\(allgemeinerTextTmp.count)/100")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.gray)
                                Spacer()
                                Button("Abbrechen") {
                                    allgemeinerTextTmp = par1[par2].allgemeinerText
                                    focusedEditField = nil
                                } // Ende Button
                                .buttonStyle(.bordered)
                            } // Ende HStack
                            .font(.system(size: 16, weight: .regular))
                        } // Ende if/else
                    } // Ende ToolbarGroup
                    } // Ende toolbar
                    
                    
                } // Ende Form
                .onAppear(){
                    neuePersonTmp[0].personPicker = " " + par1[par2].personNachname + ", " + par1[par2].personVorname
                    neuePersonTmp[0].personVorname = par1[par2].personVorname
                    neuePersonTmp[0].personNachname  = par1[par2].personNachname
                    neuePersonTmp[0].personSex = par1[par2].personSex
                }// Ende onApear
            } // Ende GeometryReader
            
            .navigationTitle("Objekt bearbeiten").navigationBarTitleDisplayMode(.inline)
            
       //} // Ende NavigationStack
        .interactiveDismissDisabled()  // Disable dismiss with a swipe
        
    } // Ende var body
    
} // Ende struc TestView


struct EditGegenstand: View {
    
    @Binding var par1: [ObjectVariable]
    @Binding var par2: Int
    @Binding var gegenstandTmp: String
    
    @State var lastText: String = ""
    
    @FocusState var isInputGegenstandActive: Bool
    
    var body: some View {
        //NavigationStack {
        
        HStack{
            Text("Gegenstand: ")
                .font(.system(size: 16, weight: .regular))
            Spacer()
            TextField("", text: $gegenstandTmp)
                .focused($isInputGegenstandActive)
                .padding(.leading, 6)
                .foregroundColor(.black)
                .modifierEditFields()
                .onAppear(){
                    gegenstandTmp = par1[par2].gegenstand
                } // Ende onAppear
                .onChange(of: gegenstandTmp, perform: { newValue in
                    if newValue.count <= 25 {
                        lastText = newValue
                    }else{
                        self.gegenstandTmp = lastText
                    } // Ende else
                    
                }) // Ende onChange
        }// Ende HStack
        
        //} // Ende NavigationStack
    } // Ende var body
} // Ende struct EditGegenstand

struct EditGegenstandText: View {
    
    @Binding var par1: [ObjectVariable]
    @Binding var par2: Int
    @Binding var gegenstandTextTmp: String
    
    @State var lastText: String = ""
    
    @FocusState var isInputGegenstandTextActive: Bool
    
    var body: some View {
        //NavigationStack {
        VStack{
            HStack {
                Text("GegenstandText: ")
                    .font(.system(size: 16, weight: .regular))
                Spacer()
            } // Ende HStack
            
            TextField("", text: $gegenstandTextTmp, axis: .vertical)
                .focused($isInputGegenstandTextActive)
                .padding(.top, 10)
                .padding(.leading, 6)
                .disableAutocorrection (true)
                .frame(height: 90, alignment: .topTrailing)
                .submitLabel(.done)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(Color.black)
                .background(Color.blue)
                .opacity(0.3)
                .cornerRadius(5)
                .onAppear(){
                    gegenstandTextTmp = par1[par2].gegenstandText
                } // Ende onAppear
                .onChange(of: gegenstandTextTmp, perform: { newValue in
                    if newValue.count <= 100 {
                        lastText = newValue
                    }else{
                        self.gegenstandTextTmp = lastText
                    } // Ende else
                    
                    guard let newValueLastChar = newValue.last else { return }
                    
                    if newValueLastChar == "\n" {
                        gegenstandTextTmp.removeLast()
                        isInputGegenstandTextActive = false
                    } // Ende if
                    
                }) // Ende onChange
        }// Ende HStack
        // } // Ende NavigationStack
    } // Ende var body
} // Ende struct EditGegenstandText


struct EditPreisWert: View {
    
    @Binding var par1: [ObjectVariable]
    @Binding var par2: Int
    @Binding var preisWertTmp: String
    
    //@State var lastText: String = ""
    
    @FocusState var isInputPreisWertActive: Bool
    
    var body: some View {
        //NavigationStack {
        
        HStack{
            Text("Preis/Wert: ")
                .font(.system(size: 16, weight: .regular))
            Spacer()
            TextField("€", text: $preisWertTmp)
                .focused($isInputPreisWertActive)
                .padding(.leading, 6)
                .foregroundColor(.black)
                .keyboardType(.decimalPad)
                .frame(width: 150, height: 30, alignment: .trailing)
                .multilineTextAlignment(.trailing)
                .modifier(TextFieldEuro(textParameter: $preisWertTmp))
                .submitLabel(.done)
                .font(.system(size: 16, weight: .regular))
                .background(Color.blue)
                .cornerRadius(5)
                .opacity(0.4)
                .onReceive(Just(preisWertTmp)) { newValue in
                    // Es soll verhindert werden mit cut/past nicht numerische Werte einzugeben. Zum Beispiel beim iPad
                    let allowedCharacters = "0123456789,"
                    var filtered = newValue.filter { allowedCharacters.contains($0) }
                    let numberOfOccurances = filtered.numberOfOccurrencesOf(string: ",")
                    
                    if filtered != newValue  {
                        preisWertTmp = filtered
                        
                    }else{
                        if numberOfOccurances > 1 { // Wenn mehr als eine "," eingegeben wurden, werden sie gelöscht
                            if let position = filtered.lastIndex(of: ",") {
                                filtered.remove(at: position)
                            } // Ende if
                            preisWertTmp = filtered
                        }else{
                            if filtered.prefix(1) == "," { // Wenn das erste zeichen "," ist, wird "0" voreingestellt.
                                filtered = "0" + filtered
                                preisWertTmp = filtered
                            } // Ende if/else
                            
                        } // Ende if/else
                        
                    } // Ende if/else
                } // Ende onReceive
                .onAppear(){
                    preisWertTmp = par1[par2].preisWert
                } // Ende onAppear
            
        }// Ende HStack
        
        
    } // Ende var body
    
} // Ende struct PreisWert

struct EditDatum: View {
    
    @Binding var par1: [ObjectVariable]
    @Binding var par2: Int
    @Binding var datumTmp: Date
    
    @State var calendarId: Int = 0
    //@State var datumTmp: Date = Date()
    
    @FocusState var isInputDatumActive: Bool
    
    var body: some View {
        
        let datumTmpArray = querySQLAbfrageArray(queryTmp: "Select datum From Objekte Where perKey = '\(par1[par2].perKey)'")
        let datumTmpString = datumTmpArray[0]
        
        //NavigationStack {
        HStack{
            Text("Neues Datum: ")
                .font(.system(size: 16, weight: .regular))
            Spacer()
            DatePicker("", selection: $datumTmp, displayedComponents: [.date])
                .labelsHidden()
                .background(Color.blue.opacity(0.2), in: RoundedRectangle(cornerRadius: 5))
                .foregroundColor(.black)
                .background(Color.blue)
                .opacity(0.3)
                .multilineTextAlignment (.center)
                .environment(\.locale, Locale.init(identifier: "de"))
                .font(.system(size: 16, weight: .regular))
                .cornerRadius(5)
                .id(calendarId)
                .onChange(of: datumTmp, perform: { _ in
                    calendarId += 1
                }) // Ende onChange...
                .onAppear{
                    datumTmp = stringToDate(parDatum: "\(datumTmpString)")
                } // Ende onAppear
            
        }// Ende HStack
        //} // Ende NavigationStack
    } // Ende var body
} // Ende struct PreisWert


struct EditAllgemeinerText: View {
    
    @Binding var par1: [ObjectVariable]
    @Binding var par2: Int
    @Binding var allgemeinerTextTmp: String
    
    @State var lastText: String = ""
    
    @FocusState var isInputAllgemeinerTextActive: Bool
    
    var body: some View {
        //NavigationStack {
        VStack{
            HStack {
                Text("AllgemeinerText: ")
                    .font(.system(size: 16, weight: .regular))
                Spacer()
            } // Ende HStack
            
            TextField("", text: $allgemeinerTextTmp, axis: .vertical)
                .focused($isInputAllgemeinerTextActive)
                .padding(.top, 10)
                .padding(.leading, 6)
                .disableAutocorrection (true)
                .frame(height: 90, alignment: .topTrailing)
                .submitLabel(.done)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(Color.black)
                .background(Color.blue)
                .opacity(0.3)
                .cornerRadius(5)
                .onAppear(){
                    allgemeinerTextTmp = par1[par2].allgemeinerText
                } // Ende onAppear
                .onChange(of: allgemeinerTextTmp, perform: { newValue in
                    if newValue.count <= 100 {
                        lastText = newValue
                    }else{
                        self.allgemeinerTextTmp = lastText
                    } // Ende else
                    
                    guard let newValueLastChar = newValue.last else { return }
                    
                    if newValueLastChar == "\n" {
                        allgemeinerTextTmp.removeLast()
                        isInputAllgemeinerTextActive = false
                    } // Ende if
                    
                }) // Ende onChange
        }// Ende HStack
        //} // Ende NavigationStack
    } // Ende var body
} // Ende struct EditAllgemeinerText

struct EditGegenstandBild: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @Binding var par1: [ObjectVariable]
    @Binding var par2: Int
    @Binding var gegenstandBildTmp: String
    
    @State private var presentAlert = false
    
    @FocusState var isInputBildActive: Bool
    
    var body: some View {
        //NavigationStack {
        HStack{
            Text("Neues Bild: ")
                .font(.system(size: 16, weight: .regular))
            Spacer()
            
            if gegenstandBildTmp == "Kein Bild" {
                Text("X")
                    .scaledToFit()
                    .frame(width: 30, height: 30, alignment: .center)
                    .background(Color.gray.gradient)
                    .cornerRadius(5)
                Text(" ")
                ImageSelector()
                Text(" ")
                PhotoSelector()
            }else{
                Image(base64Str: gegenstandBildTmp)?
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
                    .clipped()
                    .cornerRadius(5)
                Text(" ")
                Button(action: {
                    gegenstandBildTmp = "Kein Bild"
                }, label: {
                    Image(systemName: "trash.square")
                    //.symbolRenderingMode(.multicolor)
                        .font(.system(size: 30))
                        .foregroundColor(.accentColor)
                })
            } // Ende if/else
            
            
        }// Ende HStack
        .onAppear(){
            print("onAppear")
            gegenstandBildTmp = par1[par2].gegenstandBild
            
        } // Ende onAppear
        .onChange(of: globaleVariable.parameterImageString, perform: { _ in
            print("Foto ausgesucht!")
            gegenstandBildTmp = globaleVariable.parameterImageString
            //par1[par2].gegenstandBild = bildTmp
            //globaleVariable.parameterImageString = "Kein Bild"
            print("\(gegenstandBildTmp)")
        }) // Ende onChange
        
        //} // Ende NavigationStack
        
    } // Ende var body
} // Ende struct EditBild

struct EditVorgang: View {
    
    @Binding var par1: [ObjectVariable]
    @Binding var par2: Int
    @Binding var vorgangTmp: String
    
    @State var vorgangArrayTmp: [String] =  ["Verleihen", "Verschenken", "Bekommen", "Aufbewahren", "Geschenkidee"]
    
    @State var indexInt: Int = 0
    
    @FocusState var isInputVorgangActive: Bool
    
    var body: some View {
        
        let indexIntTmp = vorgangArrayTmp.firstIndex(of: "\(par1[par2].vorgang)" )!
        
        //NavigationStack {
        HStack{
            Text("Vorgang: ")
                .font(.system(size: 16, weight: .regular))
            Spacer()
            Picker("", selection: $indexInt, content: {
                ForEach(0..<$vorgangArrayTmp.count, id: \.self) { index in
                    Text("\(vorgangArrayTmp[index])")//.tag(index)
                } // Ende ForEach
            }) // Picker
            .font(.system(size: 16, weight: .regular))
            .frame(width: 180, height: 30)
            .background(Color.blue)
            .opacity(0.4)
            .cornerRadius(5)
            .onAppear(){
                vorgangTmp = par1[par2].vorgang
                indexInt = indexIntTmp
            } // Ende onAppear
            .onChange(of: indexInt, perform: { _ in
                vorgangTmp = vorgangArrayTmp[indexInt]
            }) // Ende onChange
            
        }// Ende HStack
        //} // Ende NavigationStack
    } // Ende var body
} // Ende struct EditVorgang

struct EditPerson: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @Binding var par1: [ObjectVariable]
    @Binding var par2: Int
    @Binding var personPickerTmp: String
    @Binding var neuePersonTmp: [PersonClassVariable]
    
    @State var personEditieren: Bool = false
    
    var body: some View {
        
        //NavigationStack {
        HStack{
            Text("Neue Person: ")
                .font(.system(size: 16, weight: .regular))
            Spacer()
            
            Button(action:{
                personEditieren = true
                
                print("Button Person ......")
            }) {
                Text("\(personPickerTmp)")
                    .font(.system(size: 16, weight: .regular))
                    .frame(height: 30)
                    .background(Color.blue)
                    .opacity(0.4)
                    .cornerRadius(5)
                
            } // Ende Button
            .onAppear(){
                personPickerTmp = " " + par1[par2].personNachname + ", " + par1[par2].personVorname + " "
            } // Ende onAppear
            //.sheet(isPresented: $personEditieren, content: { ShapeViewEditUser(isPresentedShapeViewEditUser: $personEditieren, personPickerTmp: $personPickerTmp, neuePersonTmp: $neuePersonTmp)})
            .navigationDestination(isPresented: $personEditieren, destination: { ShapeViewEditUser(isPresentedShapeViewEditUser: $personEditieren, personPickerTmp: $personPickerTmp, neuePersonTmp: $neuePersonTmp)
                    .navigationBarBackButtonHidden()
                    .navigationBarTitleDisplayMode(.inline)
            })
            
            
        }// Ende HStack
        //} // Ende NavigationStack
    } // Ende var body
} // Ende struct EditVorgang
