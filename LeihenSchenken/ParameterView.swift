//
//  ParameterView.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 27.03.23.
//

import SwiftUI
import PhotosUI
import UIKit

struct ParameterView: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @State var showParameterHilfe: Bool = false
    @State var showAlerOKButton: Bool = false
    @State var showAlertAbbrechenButton: Bool = false
    @State var showAlertSpeichernButton: Bool = false
    
    //@FocusState var datumIsFocused: Bool
    //@FocusState var preisWertIsFocused: Bool
    
    @FocusState private var focusedField: Field?
    private enum Field: Int, CaseIterable {
        case amount
        case str1
        case str2
    } // Ende private enum
    
    @State private var datum = Date()
 
    @State private var calendarId: Int = 0
    //@State var gegenstand: String = ""
    //@State var gegenstandText: String = ""
    @State var gegenstandPreis: Double = 0.0
    @State var textGegenstandbeschreibung: String = ""
   
    @State var textAllgemeineNotizen: String = ""
    
    @State var platzText1: String = "Gegenstandbeschreibung"
    @State var platzText2: String = "Allgemeine Notizen"
    @State var selectedVorgangInt: Int = 0
    @State var selectedGegenstandInt: Int = 0
    @State var selectedPersonInt: Int = 0
    
    @State private var text: String = ""
    @State private var platz: String = ""
    
    @State var imageData = UIImage()
    
    @State var exampleText: String = ""
    
    private let numberFormatter: NumberFormatter
        
    init() {
          numberFormatter = NumberFormatter()
          numberFormatter.numberStyle = .currency
          numberFormatter.maximumFractionDigits = 2
        
    } // Ende init
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                
                Form {
                    
                    Picker("Gegenstand: ", selection: $selectedGegenstandInt, content: {
                        ForEach(0..<$globaleVariable.parameterGegenstand.count, id: \.self) { index in
                            Text("\(globaleVariable.parameterGegenstand[index])")//.tag(index)
                        } // Ende ForEach
                    })
                    
                    TextEditorWithPlaceholder(text: $textGegenstandbeschreibung, platz: $platzText1)
                        //.focused($preisWertIsFocused)
                        .focused($focusedField, equals: .str1)
                    
                    HStack {
                        Text("Gegenstandsbild:   ")
                            .frame(height: 60)
                        
                        PhotosSelector()
                        
                        Text(" ")
                        
                        if globaleVariable.parameterImageString != "" {
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
                        TextField("0.00 €", text: $exampleText)
                        
                                                .modifier(TextFieldClearButton(textParameter: $exampleText))
                                                .multilineTextAlignment(.trailing)
                                                .frame(width: 115, height: 35, alignment: .trailing)
                                                .background(Color(.systemGray6))
                                                .cornerRadius(5)
                                                .font(.system(size: 18, weight: .regular))
                                                .keyboardType(.decimalPad)
                                                //.focused($preisWertIsFocused)
                                                .focused($focusedField, equals: .amount)
                        /*
                                                .toolbar {ToolbarItemGroup(placement: .keyboard) {
                                                        Spacer()
                                                    if focusedField == .amount {
                                                        Button("OK") {
                                                            //preisWertIsFocused = false
                                                            focusedField = nil
                                                            print("OK Button wurde gedrückt!")
                                                        } // Ende Button
                                                    }else{
                                                        Button("Abbrechen") {
                                                            //preisWertIsFocused = false
                                                            focusedField = nil
                                                            print("OK Button wurde gedrückt!")
                                                        } // Ende Button
                                                        
                                                    }
                                                    
                                                    } // Ende ItemGroup
                                                } // Ende toolbar
                        
                    */
                        
                    } // Ende HStack
                 
                    
                    DatePicker("Datum: ", selection: $datum, displayedComponents: [.date])
                        .accentColor(Color.black)
                        .multilineTextAlignment (.center)
                        .id(calendarId)
                        .onChange(of: datum, perform: { _ in
                          calendarId += 1
                        }) // Ende onChange...
                        .onTapGesture {
                          calendarId += 1
                        } // Ende onTap....
                    
                    
                    Picker("Was möchten Sie tun?", selection: $selectedVorgangInt, content: {
                        ForEach(0..<$globaleVariable.parameterVorgang.count, id: \.self) { index in
                            Text("\(globaleVariable.parameterVorgang[index])")//.tag(index)
                        } // Ende ForEach
                    }) // Picker
                    
                    Picker("Person: ", selection: $selectedPersonInt, content: {
                        ForEach(0..<$globaleVariable.parameterPerson.count, id: \.self) { index in
                            Text("\(globaleVariable.parameterPerson[index])")//.tag(index)
                        } // Ende ForEach
                    }) // Picker
                    
                    TextEditorWithPlaceholder(text: $textAllgemeineNotizen, platz: $platzText2)
                        //.focused($preisWertIsFocused)
                        .focused($focusedField, equals: .str2)
                    
                    VStack{
                        Text("----------").frame(height: 50)
                        
                        HStack {
                                
                            Button(action: {showAlertSpeichernButton = true}) { Label("Speichern", systemImage: "pencil.and.outline")}.buttonStyle(.borderedProminent).foregroundColor(.white).font(.system(size: 16, weight: .regular))
                                .alert(isPresented:$showAlertSpeichernButton) {
                                            Alert(
                                                title: Text("Möchten Sie alle Angaben speichern?"),
                                                message: Text("Die Daten werden in die Datenbank gespeichert!"),
                                                primaryButton: .destructive(Text("Speichern")) {
                                                    // Hier kommt speicher Routine
                                                    print("Gespeichert...")
                                                },
                                                secondaryButton: .cancel(Text("Abbrechen")){
                                                    print("Abgebrochen ....")
                                                }
                                            ) // Ende Alert
                                        } // Ende alert
                                
                            Button(action: {showAlertAbbrechenButton = true}) { Label("Abbrechen", systemImage: "pencil.slash") } .buttonStyle(.bordered).foregroundColor(.blue).font(.system(size: 16, weight: .regular))
                                .alert(isPresented:$showAlertAbbrechenButton) {
                                            Alert(
                                                title: Text("Möchten Sie alle Angaben unwiederfuflich löschen?"),
                                                message: Text("Man kann den Vorgang nicht rückgängich machen!"),
                                                primaryButton: .destructive(Text("Löschen")) {
                                                    globaleVariable.parameterImageString = ""
                                                    selectedGegenstandInt = 0
                                                    selectedVorgangInt = 0
                                                    selectedPersonInt = 0
                                                    textGegenstandbeschreibung = ""
                                                    gegenstandPreis = 0.0
                                                    exampleText = ""
                                                    datum = Date()
                                                    textAllgemeineNotizen = ""
                                                    
                                                    // Hier kommt löschen der Angaben Routine
                                                    print("Gelöscht...")
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
                                textGegenstandbeschreibung = ""
                                focusedField = nil
                                print("Abbrechen Button Str1 wurde gedrückt!")
                            } // Ende Button
                        }else {
                            Button("Abbrechen") {
                                //preisWertIsFocused = false
                                textAllgemeineNotizen = ""
                                focusedField = nil
                                print("Abbrechen Button Str2 wurde gedrückt!")
                            } // Ende Button
                            
                        } // Ende if/else
                        
                        } // Ende ItemGroup
                    } // Ende toolbar
                    
                } // Ende Form
                
            } // Ende VStack
            
        } // Ende GeometryReader
        .navigationTitle("Parameter")
        .toolbar {ToolbarItem(placement: .navigationBarLeading) {
            
            if UIDevice.current.userInterfaceIdiom == .phone {
        
                NavigationLink(destination: DeteilView()){
                    Label("Test", systemImage: "sidebar.left")
                    
                } // Ende NavigationLink
                
           } // Ende UIDevice
                
         } // Ende ToolbarItem
        
         } // Ende toolbar
        .navigationBarItems(trailing: Button( action: {
            showParameterHilfe = true
        }) {Image(systemName: "questionmark.circle").imageScale(.large)} )
        .alert("Hilfe zu Parameter", isPresented: $showParameterHilfe, actions: {
              Button(" - OK - ") {}
              }, message: { Text("Das ist die Beschreibung für den Bereich Parameter.") } // Ende message
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
    
    var body: some View {
        
        PhotosPicker(selection: $selectedItem, matching: .any(of: [.images, .not(.screenshots)]), photoLibrary: .shared()) {
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
                        
                        if let selectedPhotoData,
                           let _ = UIImage(data: selectedPhotoData) {
                         
                               globaleVariable.parameterImageString = selectedPhotoData.base64EncodedString ()
                         
                                print("Photo ausgewählt")
                            } // Ende let
                        
                    } // Ende Task
                } // Ende onChange
    } // Ende var body
} //Ende struckt PhotoSelector


struct TextFieldClearButton: ViewModifier {
    @Binding var textParameter: String
   
    func body(content: Content) -> some View {
        HStack {
            content
            
            if !textParameter.isEmpty {
                /*
                Button(
                    action: { self.textParameter = "" },
                    label: {
                        Image(systemName: "delete.left")
                            .foregroundColor(Color(UIColor.opaqueSeparator))
                    } // Ende label
                ) // Ende Button
                */
                Text("€")
                    .foregroundColor(Color(UIColor.opaqueSeparator))
                    
            } //Ende if !text
        } // Ende HStack
    } // Ende func body
} // Ende struc
