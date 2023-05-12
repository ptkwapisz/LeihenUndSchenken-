//
//  ParameterView.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 27.03.23.
//

import SwiftUI
import PhotosUI
import UIKit
import SQLite3

struct ParameterView: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    @State var showParameterHilfe: Bool = false
    @State var showAlerOKButton: Bool = false
    @State var showAlertAbbrechenButton: Bool = false
    @State var showAlertSpeichernButton: Bool = false
    
    @State var showSheetPerson: Bool = false
    @State var showSheetGegenstand: Bool = false
    @State var isParameterBereich: Bool = true
    
    
    @FocusState private var focusedField: Field?
    
    private enum Field: Int, CaseIterable {
        case amount
        case str1 // Für gegenstandbeschreibung
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
    
    //@State var preisWert: String = ""
    
    
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
        germanDateFormatter.dateStyle = .short
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
                if globaleVariable.parameterPerson[globaleVariable.selectedPersonInt] == "Neue Person" {
                   showSheetPerson = true
                   selectedPerson = "Neue Person"
                }else{
                    selectedPerson = globaleVariable.parameterPerson[globaleVariable.selectedPersonInt]
                } // Ende if
            } // Ende set
        ) // Ende let
        
        GeometryReader { geometry in
            VStack {
                
                Form {
                
                    Picker("Gegenstand: ", selection: tapOptionGegenstand, content: {
                        ForEach(0..<$globaleVariable.parameterGegenstand.count, id: \.self) { index in
                            Text("\(globaleVariable.parameterGegenstand[index])").tag(index)
                        } // Ende ForEach
                        
                    }).sheet(isPresented: $showSheetGegenstand, content: { ShapeViewAddGegenstand(isPresented: $showSheetGegenstand, isParameterBereich: $isParameterBereich )})
                    
                    TextEditorWithPlaceholder(text: $globaleVariable.textGegenstandbeschreibung, platz: $platzText1)
                        //.focused($preisWertIsFocused)
                        .focused($focusedField, equals: .str1)
                    
                    HStack {
                        Text("Gegenstandsbild:   ")
                            .frame(height: 60)
                        
                        PhotosSelector()
                        
                        Text(" ")
                        
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
                    
                    HStack {
                        
                        Text("Preis/Wert:  ")
                            .frame(height: 35, alignment: .leading)  // width: 190,
                        
                        Text("                ")
                        TextField("0.00 €", text: $globaleVariable.preisWert)
                        
                            .modifier(TextFieldEuro(textParameter: $globaleVariable.preisWert))
                            .multilineTextAlignment(.trailing)
                            .frame(width: 115, height: 35, alignment: .trailing)
                            .background(Color(.systemGray6))
                            .cornerRadius(5)
                            .font(.system(size: 18, weight: .regular))
                            .keyboardType(.decimalPad)
                            //.focused($preisWertIsFocused)
                            .focused($focusedField, equals: .amount)
                        
                    } // Ende HStack
                 
                    DatePicker("Datum: ", selection: $globaleVariable.datum, displayedComponents: [.date])
                        .accentColor(Color.black)
                        .multilineTextAlignment (.center)
                        .id(calendarId)
                        .onChange(of: globaleVariable.datum, perform: { _ in
                          calendarId += 1
                        }) // Ende onChange...
                        .onTapGesture {
                          calendarId += 1
                        } // Ende onTap....
                                        
                    Picker("Was möchten Sie tun?", selection: $globaleVariable.selectedVorgangInt, content: {
                        ForEach(0..<$globaleVariable.parameterVorgang.count, id: \.self) { index in
                            Text("\(globaleVariable.parameterVorgang[index])")//.tag(index)
                        } // Ende ForEach
                    }) // Picker
                    
                    Picker("Person: ", selection: tapOptionPerson, content: {
                        ForEach(0..<$globaleVariable.parameterPerson.count, id: \.self) { index in
                            Text("\(globaleVariable.parameterPerson[index])")//.tag(index)
                        } // Ende ForEach
                    }) // Picker
                    .sheet(isPresented: $showSheetPerson, content: { ShapeViewAddUser(isPresented: $showSheetPerson, isParameterBereich: $isParameterBereich) })
                    
                    
                    TextEditorWithPlaceholder(text: $globaleVariable.textAllgemeineNotizen, platz: $platzText2)
                        //.focused($preisWertIsFocused)
                        .focused($focusedField, equals: .str2)
                    
                    VStack{
                        Text("").frame(height: 20)
                       
                        HStack {
                                
                            Button(action: {showAlertAbbrechenButton = true}) { Label("Abbrechen", systemImage: "pencil.slash") } .buttonStyle(.bordered).foregroundColor(.blue).font(.system(size: 16, weight: .regular))
                                .alert(isPresented:$showAlertAbbrechenButton) {
                                    Alert(
                                        title: Text("Möchten Sie alle Angaben unwiederfuflich löschen?"),
                                        message: Text("Man kann den Vorgang nicht rückgängich machen!"),
                                        primaryButton: .destructive(Text("Löschen")) {
                                            
                                            // Die Parameterwerte werden gelöscht.
                                            cleanEingabeMaske()
                                            
                                        },
                                        secondaryButton: .cancel(Text("Abbrechen")){
                                            print("Abgebrochen ....")
                                        } // Ende secondary Button
                                    ) // Ende Alert
                                } // Ende alert
                            
                            Button(action: {showAlertSpeichernButton = true}) { Label("Speichern", systemImage: "pencil.and.outline")}.buttonStyle(.borderedProminent).foregroundColor(.white).font(.system(size: 16, weight: .regular))
                                .alert(isPresented:$showAlertSpeichernButton) {
                                    Alert(
                                        title: Text("Möchten Sie alle Angaben speichern?"),
                                        message: Text("Die Daten werden in die Datenbank gespeichert und die Angabemaske wird geleert!"),
                                        primaryButton: .destructive(Text("Speichern")) {
                                            // perKey ist die einmahlige Zahgl zum eindeutigen definieren jeden Datensatzes
                                            
                                            let perKey = erstellePerKey(par1: perKeyFormatter.string(from: globaleVariable.datum))
                                            
                                            let insertDataToDatenbank = "INSERT INTO Objekte(perKey, gegenstand, gegenstandText, gegenstandBild, preisWert, datum, vorgang, personVorname, personNachname, personSex, allgemeinerText) VALUES('\(perKey)','\(selectedGegenstand)', '\(globaleVariable.textGegenstandbeschreibung)','\(globaleVariable.parameterImageString)','\(globaleVariable.preisWert)', '\(dateToString(parDatum: globaleVariable.datum))', '\(globaleVariable.parameterVorgang[globaleVariable.selectedVorgangInt])', '\(globaleVariable.selectedPersonVariable[0].personVorname)', '\(globaleVariable.selectedPersonVariable[0].personNachname)', '\(globaleVariable.selectedPersonVariable[0].personSex)', '\(globaleVariable.textAllgemeineNotizen)')"
                                       
                                            if sqlite3_exec(db, insertDataToDatenbank, nil, nil, nil) !=
                                               SQLITE_OK {
                                                let errmsg = String(cString: sqlite3_errmsg(db)!)
                                                print("error -->: \(errmsg)")
                                                print("Daten wurden nicht hinzugefügt")
                                            }else{
                                                
                                                // Die Parameterwerte werden gelöscht.
                                                cleanEingabeMaske()
                                                
                                                print("Gespeichert...")
                                                
                                            } // End if/else

                                        },
                                        secondaryButton: .cancel(Text("Abbrechen")){
                                            print("Abgebrochen ....")
                                        }
                                    ) // Ende Alert
                                } // Ende alert
                            
                            } // Ende HStack
                    
                    } // Ende VStack
                    .toolbar {ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                        if focusedField == .amount {
                            Button("OK") {
                                //preisWertIsFocused = false
                                focusedField = nil
                                print("OK Button wurde gedrückt!")
                            } // Ende Button
                        }else if focusedField == .str1 {
                            Button("Abbrechen") {
                                //preisWertIsFocused = false
                                globaleVariable.textGegenstandbeschreibung = ""
                                focusedField = nil
                                print("Abbrechen Button Str1 wurde gedrückt!")
                            } // Ende Button
                        }else {
                            Button("Abbrechen") {
                                //preisWertIsFocused = false
                                globaleVariable.textAllgemeineNotizen = ""
                                focusedField = nil
                                print("Abbrechen Button Str2 wurde gedrückt!")
                            } // Ende Button
                            
                        } // Ende if/else
                        
                        } // Ende ItemGroup
                    } // Ende toolbar
                    
                } // Ende Form
                
            } // Ende VStack
            
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
        }) {Image(systemName: "questionmark.circle").imageScale(.large)} )
        .alert("Hilfe zu Angabemaske", isPresented: $showParameterHilfe, actions: {
              Button(" - OK - ") {}
              }, message: { Text("Das ist die Beschreibung für den Bereich Angabemaske.") } // Ende message
            ) // Ende alert
        
    } // Ende var body
    
} // Ende struct


struct TextEditorWithPlaceholder: View {
        @Binding var text: String
        @Binding var platz: String
    
        @State var totalCHarsText: Int = 100
        @State var lastText: String = ""
       
        @FocusState private var textIsFocussed: Bool
    
        var body: some View {
            
                ZStack(alignment: .leading) {
                    if text.isEmpty {
                        VStack {
                            Text("\(platz)")
                                .padding(.top, 10)
                                .padding(.leading, 6)
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(Color.black)
                                .opacity(0.6)
                            Spacer()
                        } // Ende VStack
                    } // Ende if
                    
                    VStack {
                        TextField("\(platz)", text: $text, axis: .vertical)
                            .focused($textIsFocussed)
                            .font(.system(size: 16, weight: .regular))
                            .cornerRadius(5)
                            .disableAutocorrection(true)
                            .lineLimit(3, reservesSpace: true)
                            .textFieldStyle(.roundedBorder)
                            .submitLabel(.done)
                            .onChange(of: text, perform: { newValue in
                                if newValue.count <= 50 {
                                    lastText = newValue
                                }else{
                                    self.text = lastText
                                } // Ende else
    
                                guard let newValueLastChar = newValue.last else { return }
                                        
                                if newValueLastChar == "\n" {
                                    text.removeLast()
                                    textIsFocussed = false
                                } // Ende if
                                        
                            }) // Ende onChange
                                    
                    } // Ende VStack
                } // Ende ZStack
            
        }// Ende var body
    }// Ende struckt


struct PhotosSelector: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedPhotoData: Data?
    let filter: PHPickerFilter = .not(.all(of: [
        .videos,
        .slomoVideos,
        .bursts,
        .livePhotos,
        .screenRecordings,
        .cinematicVideos,
        .timelapseVideos
    ]))
    
    var body: some View {
        
        PhotosPicker(selection: $selectedItem, matching: filter, photoLibrary: .shared()) {
                    Image(systemName: "photo.fill.on.rectangle.fill")
                        .symbolRenderingMode(.multicolor)
                        .font(.system(size: 30))
                        .foregroundColor(.accentColor)
                } // Ende PhotoPicker
                .buttonStyle(.borderless)
                .onChange(of: selectedItem) { newItem in
                    Task {
                        
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                           selectedPhotoData = data
                           
                        } // Ende if let
                        
                        if let selectedPhotoData, let _ = UIImage(data: selectedPhotoData) {
                            // Transferiere Photo in ein jpgPhoto
                            let tmpPhoto = UIImage(data: selectedPhotoData)?.jpegData(compressionQuality: 0.5)
                            // transferiere jpgPhoto in String
                            globaleVariable.parameterImageString = tmpPhoto!.base64EncodedString()
                         
                            print("Photo wurde ausgewählt")
                        } // Ende if
                        
                    } // Ende Task
                } // Ende onChange
    } // Ende var body
} //Ende struckt PhotoSelector


struct TextFieldEuro: ViewModifier {
    @Binding var textParameter: String
   
    func body(content: Content) -> some View {
        HStack {
            content
            if !textParameter.isEmpty {
                Text("€")
                    .foregroundColor(Color(UIColor.opaqueSeparator))
                    
            } //Ende if !text
        } // Ende HStack
    } // Ende func body
} // Ende struc



