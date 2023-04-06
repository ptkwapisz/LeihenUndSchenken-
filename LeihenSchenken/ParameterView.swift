//
//  ParameterView.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 27.03.23.
//

import SwiftUI

struct ParameterView: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @State var showParameterHilfe: Bool = false
    @FocusState var isFocused: Bool
    
    @State private var datum = Date()
    @State var gegenstand: String = ""
    @State var gegenstandText: String = ""
    @State var gegenstandPreis: Double = 0.0
    @State var textGegenstandbeschreibung: String = ""
   
    @State var textAllgemeineNotizen: String = ""
    
    @State var platzText1: String = "Gegenstandbeschreibung"
    @State var platzText2: String = "Allgemeine Notizen"
    @State var selectedArtInt: Int = 0
    @State var selectedGegenstandInt: Int = 0
    @State var selectedPersonInt: Int = 0
    
    @State private var text: String = ""
    @State private var platz: String = ""
    
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
                        ForEach(0..<$globaleVariable.gegenstand.count, id: \.self) { index in
                            Text("\(globaleVariable.gegenstand[index])")//.tag(index)
                        } // Ende ForEach
                    })
                    
                    TextEditorWithPlaceholder(text: $textGegenstandbeschreibung, platz: $platzText1)
        
                    HStack {
                        
                        Text("Preis/Wert:  ")
                            .frame(width: 195, height: 35, alignment: .leading)
                        
                        TextField("0.00", value: $gegenstandPreis, formatter: numberFormatter)
                            .frame(width: 115, height: 35, alignment: .trailing)
                            .background(Color(.systemGray6))
                            .cornerRadius(5)
                            .font(.system(size: 18, weight: .regular))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment (.center)
                        
                        
                    } // Ende HStack
                    
                    DatePicker("Datum: ", selection: $datum, displayedComponents: [.date])
                        .accentColor(Color.black)
                        .multilineTextAlignment (.center)
                    
                    Picker("Was soll passieren?", selection: $selectedArtInt, content: {
                        ForEach(0..<$globaleVariable.art.count, id: \.self) { index in
                            Text("\(globaleVariable.art[index])")//.tag(index)
                        } // Ende ForEach
                    }) // Picker
                    
                    Picker("Person: ", selection: $selectedPersonInt, content: {
                        ForEach(0..<$globaleVariable.person.count, id: \.self) { index in
                            Text("\(globaleVariable.person[index])")//.tag(index)
                        } // Ende ForEach
                    }) // Picker
                    
                    TextEditorWithPlaceholder(text: $textAllgemeineNotizen, platz: $platzText2)
                    
                    VStack{
                        Text("").frame(height: 100)
                        
                        HStack {
                            
                            Button(action: {}) { Label(" OK  ", systemImage: "pencil.and.outline")}.buttonStyle(.borderedProminent).foregroundColor(.white)
                            Button(action: {}) { Label("Abbrechen", systemImage: "pencil.slash") } .buttonStyle(.bordered).foregroundColor(.blue)
                            
                        } // Ende HStack
                        
                    } // Ende VStack
                    
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
                        TextEditor(text: $text)
                            .background(Color(.systemGray6))
                            .font(.system(size: 16, weight: .regular))
                            .frame(minHeight: 100, maxHeight: 100)
                            .cornerRadius(5)
                            .disableAutocorrection(true)
                            .opacity(text.isEmpty ? 0.85 : 1)
                            .onChange(of: text, perform: { text in
                                totalCHarsText = text.count
                                
                                if totalCHarsText <= 100 {
                                    lastText = text
                                }else{
                                    self.text = lastText
                                } // Ende else
                                
                            }) // Ende onChange
                        
                        //Spacer()
                    } // Ende VStack
                } // Ende ZStack
            
        }// Ende var body
    }// Ende struckt
