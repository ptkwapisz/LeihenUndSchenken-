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
    
   // @State var disableSpeichern: Bool = false
    @State var showChartHilfe: Bool = false
    @State var gegenstandTmp: String = ""
    @State var gegenstandTextTmp: String = ""
    @State var allgemeinerTextTmp: String = ""
    @State var datumTmp: Date = Date()
    @State var preisWertTmp: String = ""
    @State var gegenstandBildTmp: String = ""
    @State var vorgangTmp: String = ""
    @State var personPickerTmp: String = ""
    @State var tabelleDB: String = "Objekte"
    @State var neuePersonTmp: [PersonClassVariable] = [PersonClassVariable(perKey: "", personPicker: "", personVorname: "", personNachname: "", personSex: "")]
 
    
    // Das ist eigenes Button
    // Ohne dieses Button wird der Name der View angezeigt (Gegenstandsname)
    // Wenn man aber den Gegenstandsname ändert bleibt es in der Anzeige als zurück der alte Name.
    var btnBack : some View { Button(action: {
        isPresentedChartViewEdit = false
    }) {
        HStack {
            Image(systemName: "chevron.left").bold()
                .offset(x: -7)
            Text("Zurück")
                .offset(x: -11)
            Spacer()
        } // Ende HStack
        .onDisappear() {
            // It is like a Cancel Button
            print("Disappear in EditSheetView wurde ausgeführt.")
            //isPresentedChartViewEdit = false
            globaleVariable.parameterImageString = "Kein Bild"
        } // Ende onDisappear
    } // Ende Button Label
    } // Ende some View
    
    
    @FocusState private var focusedEditField: editField?
    
    private enum editField: Int, CaseIterable {
        case gegenstandKeyboard // Für Gegenstand
        case betragKeyboard // Für Preis/Wert
        case text1Keyboard // Für Gegenstandbeschreibung
        case text2Keyboard // Für allgemeine Informationen
        
    } // Ende private enum
    
    var body: some View {
 
            GeometryReader { geometry in
                VStack {
                    VStack {
                        Text("")
                        Text("Objekt bearbeiten").bold()
                        List {
                            
                            EditGegenstand(par1: $par1, par2: $par2, gegenstandTmp: $gegenstandTmp)
                                .focused($focusedEditField, equals: .gegenstandKeyboard)
                            EditGegenstandText(par1: $par1, par2: $par2, gegenstandTextTmp: $gegenstandTextTmp)
                                .focused($focusedEditField, equals: .text1Keyboard)
                            EditGegenstandBild(par1: $par1, par2: $par2, gegenstandBildTmp: $gegenstandBildTmp)
                            EditPreisWert(par1: $par1, par2: $par2, preisWertTmp: $preisWertTmp)
                                .focused($focusedEditField, equals: .betragKeyboard)
                            EditDatum(par1: $par1, par2: $par2, datumTmp: $datumTmp)
                            EditVorgang(par1: $par1, par2: $par2, vorgangTmp: $vorgangTmp)
                            EditPerson(par1: $par1, par2: $par2, personPickerTmp: $personPickerTmp, neuePersonTmp: $neuePersonTmp, tabelleDB: $tabelleDB)
                        
                            EditAllgemeinerText(par1: $par1, par2: $par2, allgemeinerTextTmp: $allgemeinerTextTmp)
                                .focused($focusedEditField, equals: .text2Keyboard)
                            
                            HStack {
                                Spacer()
                                
                                if UIDevice.current.userInterfaceIdiom == .pad {
                                    Button("Abbrechen"){
                                        isPresentedChartViewEdit = false
                                        globaleVariable.parameterImageString = "Kein Bild"
                                    } // Ende Button
                                    .buttonStyle(.bordered)
                                    .foregroundColor(.blue)
                                    .fontWeight(.semibold)
                                    .font(.system(size: 16, weight: .regular))
                                } // Ende if
                                
                                Button("Speichern") {
                                    
                                    updateSqliteTabellenField(sqliteFeld: "gegenstand", neueInhalt: gegenstandTmp, perKey: par1[par2].perKey, tabelle: "Objekte")
                                    par1[par2].gegenstand = gegenstandTmp
                                    
                                    updateSqliteTabellenField(sqliteFeld: "gegenstandText", neueInhalt: gegenstandTextTmp, perKey: par1[par2].perKey, tabelle: "Objekte")
                                    par1[par2].gegenstandText = gegenstandTextTmp
                                    
                                    updateSqliteTabellenField(sqliteFeld: "gegenstandbild", neueInhalt: gegenstandBildTmp, perKey: par1[par2].perKey, tabelle: "Objekte")
                                    par1[par2].gegenstandBild = gegenstandBildTmp
                                    
                                    updateSqliteTabellenField(sqliteFeld: "preiswert", neueInhalt: preisWertTmp, perKey: par1[par2].perKey, tabelle: "Objekte")
                                    par1[par2].preisWert = preisWertTmp
                                    
                                    par1[par2].datum = dateToString(parDatum: datumTmp)
                                    updateSqliteTabellenField(sqliteFeld: "datum", neueInhalt: par1[par2].datum, perKey: par1[par2].perKey, tabelle: "Objekte")
                                    
                                    updateSqliteTabellenField(sqliteFeld: "vorgang", neueInhalt: vorgangTmp, perKey: par1[par2].perKey, tabelle: "Objekte")
                                    par1[par2].vorgang = vorgangTmp
                                    
                                    updateSqliteTabellenField(sqliteFeld: "personVorname", neueInhalt: neuePersonTmp[0].personVorname, perKey: par1[par2].perKey, tabelle: "Objekte")
                                    par1[par2].personVorname = neuePersonTmp[0].personVorname
                                    
                                    updateSqliteTabellenField(sqliteFeld: "personNachname", neueInhalt: neuePersonTmp[0].personNachname, perKey: par1[par2].perKey, tabelle: "Objekte")
                                    par1[par2].personNachname = neuePersonTmp[0].personNachname
                                    
                                    updateSqliteTabellenField(sqliteFeld: "personSex", neueInhalt: neuePersonTmp[0].personSex, perKey: par1[par2].perKey, tabelle: "Objekte")
                                    par1[par2].personSex = neuePersonTmp[0].personSex
                                    
                                    updateSqliteTabellenField(sqliteFeld: "allgemeinerText", neueInhalt: allgemeinerTextTmp, perKey: par1[par2].perKey, tabelle: "Objekte")
                                    par1[par2].allgemeinerText = allgemeinerTextTmp
                                    
                                    globaleVariable.parameterImageString = "Kein Bild"
                                    refreshAllViews()
                                    isPresentedChartViewEdit = false
                                    
                                } // Ende Button
                                .buttonStyle(.borderedProminent)
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                                .font(.system(size: 16, weight: .regular))
                                .disabled(gegenstandTmp.isEmpty)
                                Spacer()
                            } // Ende HStack
                            
                        } // Ende List
                        .onAppear() {
                            // The if-Clausel is nesessery for keeping changes.
                            // Without if-Clausel the onApear delete all changes made in struct ShapeViewEditUser
                            if neuePersonTmp[0].personPicker.isEmpty {
                                neuePersonTmp[0].personPicker = " " + par1[par2].personNachname + ", " + par1[par2].personVorname
                            } // Ende if
                            if neuePersonTmp[0].personVorname.isEmpty {
                                neuePersonTmp[0].personVorname = par1[par2].personVorname
                            } // Ende if
                            if neuePersonTmp[0].personNachname.isEmpty {
                                neuePersonTmp[0].personNachname  = par1[par2].personNachname
                            }
                            if neuePersonTmp[0].personSex.isEmpty {
                                neuePersonTmp[0].personSex = par1[par2].personSex
                            } // Ende if
                        }// Ende onApear
                        
                    } // Ende VStack
                    .frame(width: geometry.size.width,height: geometry.size.height * GlobalStorage.heightFaktorEbene1, alignment: .center)
                    //.frame(width: geometry.size.width)
                    .background(GlobalStorage.farbEbene1)
                    .cornerRadius(10)
                    
                } // Ende VStack
                .frame(width: geometry.size.width,height: geometry.size.height * GlobalStorage.heightFaktorEbene0, alignment: .center)
                .background(GlobalStorage.farbEbene0)
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
            } // Ende GeometryReader
            .navigationTitle("\(gegenstandTmp)").navigationBarTitleDisplayMode(.large)
            .interactiveDismissDisabled()  // Disable dismiss with a swipe
            .navigationBarItems(leading: btnBack)
        
        //} // Ende NavigationStack
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
        VStack {
            CustomTextField(text: $gegenstandTmp.max(25), isMultiLine: false, placeholder: "Gegenstandname")
                .focused($isInputGegenstandActive)
        }
        .onAppear(){
            gegenstandTmp = par1[par2].gegenstand
        } // Ende onAppear
        
        /*
        HStack{
            Text("Gegenstand: ")
                .font(.system(size: 16, weight: .regular))
            Spacer()
            
            TextField("", text: $gegenstandTmp)
                .focused($isInputGegenstandActive)
                .padding(.leading, 6)
                .modifierEditFields()
            
                .onAppear(){
                    gegenstandTmp = par1[par2].gegenstand
                } // Ende onAppear
                .onChange(of: gegenstandTmp) {
                    if gegenstandTmp.count <= 25 {
                        lastText = gegenstandTmp
                    }else{
                        self.gegenstandTmp = lastText
                    } // Ende else
                    
                } // Ende onChange
        }// Ende HStack
        */
        // } // Ende NavigationStack
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
            
            CustomTextField(text: $gegenstandTextTmp.max(100), isMultiLine: true, placeholder: "Gegenstandbeschreibung")
                .focused($isInputGegenstandTextActive)
            /*
            TextField("Gegenstandbeschreibung", text: $gegenstandTextTmp, axis: .vertical)
                .focused($isInputGegenstandTextActive)
                .padding(.top, 10)
                .padding(.leading, 6)
                .disableAutocorrection (true)
                .frame(height: 90, alignment: .topTrailing)
                .submitLabel(.done)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(Color.black.opacity(0.3))
                .background(Color.blue.opacity(0.3))
                .cornerRadius(5)
                .onAppear(){
                    gegenstandTextTmp = par1[par2].gegenstandText
                } // Ende onAppear
                .onChange(of: gegenstandTextTmp) {
                    if gegenstandTextTmp.count <= 100 {
                        lastText = gegenstandTextTmp
                    }else{
                        self.gegenstandTextTmp = lastText
                    } // Ende else
                    
                    guard let newValueLastChar = gegenstandTextTmp.last else { return }
                    
                    if newValueLastChar == "\n" {
                        gegenstandTextTmp.removeLast()
                        isInputGegenstandTextActive = false
                    } // Ende if
                    
                } // Ende onChange
             */
        }// Ende VStack
        .onAppear(){
            gegenstandTextTmp = par1[par2].gegenstandText
        } // Ende onAppear
        
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
            TextField("", text: $preisWertTmp)
                .modifier(TextFieldEuro(textParameter: $preisWertTmp))
                .focused($isInputPreisWertActive)
                .frame(width: 100, height: 30, alignment: .trailing)
                .background(Color.gray.opacity(0.09))
                .cornerRadius(10)
                .font(.system(size: 18, weight: .regular).bold())
                .foregroundColor(Color.black.opacity(0.4))
            
                //.padding(.leading, 6)
                //.background(Color.blue.opacity(0.4))
                //.foregroundColor(Color.black.opacity(0.4))
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .submitLabel(.done)
                //.font(.system(size: 16, weight: .regular))
                //.cornerRadius(5)
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
                .padding(.trailing, -5)
                .foregroundColor(.gray)
                .opacity(0.4)
                //.background(Color.blue)
                //.opacity(0.4)
                .multilineTextAlignment (.center)
                .environment(\.locale, Locale.init(identifier: "de"))
                .cornerRadius(10)
                .id(calendarId)
                .onChange(of: datumTmp ) {
                    calendarId += 1
                } // Ende onChange...
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
            
            CustomTextField(text: $allgemeinerTextTmp.max(100), isMultiLine: true, placeholder: "Allgemeine Notitzen")
                .focused($isInputAllgemeinerTextActive)
            /*
            TextField("Allgemeiner Text", text: $allgemeinerTextTmp, axis: .vertical)
                .focused($isInputAllgemeinerTextActive)
                .padding(.top, 10)
                .padding(.leading, 6)
                .disableAutocorrection (true)
                .frame(height: 90, alignment: .topTrailing)
                .submitLabel(.done)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(Color.black.opacity(0.3))
                .background(Color.blue.opacity(0.3))
                .cornerRadius(5)
                .onAppear(){
                    allgemeinerTextTmp = par1[par2].allgemeinerText
                } // Ende onAppear
                .onChange(of: allgemeinerTextTmp) {
                    if allgemeinerTextTmp.count <= 100 {
                        lastText = allgemeinerTextTmp
                    }else{
                        self.allgemeinerTextTmp = lastText
                    } // Ende else
                    
                    guard let newValueLastChar = allgemeinerTextTmp.last else { return }
                    
                    if newValueLastChar == "\n" {
                        allgemeinerTextTmp.removeLast()
                        isInputAllgemeinerTextActive = false
                    } // Ende if
                    
                } // Ende onChange
             */
        }// Ende VStack
        .onAppear(){
            allgemeinerTextTmp = par1[par2].allgemeinerText
        } // Ende onAppear
        
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
                
                ImageSelector()
                Text(" ")
                PhotoSelector()
               // Text(" ")
                /*
                Text("X")
                    .scaledToFit()
                    .frame(width: 25, height: 25, alignment: .center)
                    .background(Color.gray.gradient)
                    .cornerRadius(5)
                 */
            }else{
                
                Image(base64Str: gegenstandBildTmp)?
                    .resizable()
                    .scaledToFill()
                    .frame(width: 28, height: 28)
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
        .onChange(of: globaleVariable.parameterImageString) {
            print("Foto ausgesucht!")
            gegenstandBildTmp = globaleVariable.parameterImageString

            print("\(gegenstandBildTmp)")
        } // Ende onChange
        
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
            }) // Ende Picker
            .font(.system(size: 16, weight: .regular))
            .frame(width: 150, height: 30)
            .padding(.trailing, 5)
            //.background(Color.blue.opacity(0.4))
            .foregroundColor(.black.opacity(0.4))
            .cornerRadius(5)
            .onAppear(){
                vorgangTmp = par1[par2].vorgang
                indexInt = indexIntTmp
            } // Ende onAppear
            .onChange(of: indexInt) {
                vorgangTmp = vorgangArrayTmp[indexInt]
            } // Ende onChange
            
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
    @Binding var tabelleDB: String
        
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
                    .frame(width: 150, height: 30, alignment: .trailing)
                    .font(.system(size: 16, weight: .regular))
                    .frame(height: 30)
                    //.background(Color.blue.opacity(0.4))
                    .foregroundColor(.black.opacity(0.4))
                    .cornerRadius(5)
                
            } // Ende Button
            
        }// Ende HStack
        .onAppear(){
            if personPickerTmp.isEmpty {
                personPickerTmp = " " + par1[par2].personNachname + ", " + par1[par2].personVorname + " "
            } // Ende if
        } // Ende onAppear
        
        //.sheet(isPresented: $personEditieren, content: { ShapeViewEditUser(isPresentedShapeViewEditUser: $personEditieren, personPickerTmp: $personPickerTmp, neuePersonTmp: $neuePersonTmp)})
        
        .applyIf(UIDevice.current.userInterfaceIdiom == .phone, apply: { $0.navigationDestination(isPresented: $personEditieren, destination: { ShapeViewEditUser(isPresentedShapeViewEditUser: $personEditieren, personPickerTmp: $personPickerTmp, neuePersonTmp: $neuePersonTmp, tabelleDB: $tabelleDB)
                .navigationBarBackButtonHidden()
                .navigationBarTitleDisplayMode(.large)
        })}, else: {$0.sheet(isPresented: $personEditieren, content: { ShapeViewEditUser(isPresentedShapeViewEditUser: $personEditieren, personPickerTmp: $personPickerTmp, neuePersonTmp: $neuePersonTmp, tabelleDB: $tabelleDB)})})
        
        //} // Ende NavigationStack
    } // Ende var body
} // Ende struct EditVorgang
