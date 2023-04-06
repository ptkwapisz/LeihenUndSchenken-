//
//  ShapeViews.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 27.03.23.
//

import Foundation
import SwiftUI


struct ShapeViewAddUser: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @Binding var isPresented: Bool
    
    @State var showSettingsHilfe: Bool = false
    
    @State var selectedPerson_sexInt: Int = 0
    //@State private var date = Date()
    
    @State var vorName: String = ""
    @State var name: String = ""
    @State var spitzname: String = ""
   // @State var geburtstag: String = ""
    
    var body: some View {
        
        
        NavigationView {
            
            Form {
                Section(){
                    TextField("Spitzname", text: $spitzname)
                        .padding(5)
                        .background(Color(.systemGray6))
                        .cornerRadius(5)
                        .disableAutocorrection(true)
                    
                    TextField("Vorname", text: $vorName)
                        .padding(5)
                        .background(Color(.systemGray6))
                        .cornerRadius(5)
                        .disableAutocorrection(true)
                    
                    TextField("Name", text: $name)
                        .padding(5)
                        .background(Color(.systemGray6))
                        .cornerRadius(5)
                        .disableAutocorrection(true)
                    
                    Picker("Geschlecht:", selection: $selectedPerson_sexInt, content: {
                        ForEach(0..<$globaleVariable.person_sex.count, id: \.self) { index in
                            Text("\(globaleVariable.person_sex[index])")//.tag(index)
                        } // Ende ForEach
                        
                    })
                    
                   
                    
                            
                } // Ende Section
        
                Button(action: {
                    print("Benutzer hinzufügen!")
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.down.fill")
                            .font(.title3)
                        Text("Benutzer hinzufügen")
                            .fontWeight(.semibold)
                            .font(.title3)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                
            } // Ende Form
            .scrollContentBackground(.hidden)
            .navigationBarItems(trailing: Button( action: {
                isPresented = false
                
            }) {Image(systemName: "x.circle.fill")
                .imageScale(.large)
            } )
            .navigationBarItems(trailing: Button( action: {
                showSettingsHilfe = true
            }) {Image(systemName: "questionmark.circle.fill")
                .imageScale(.large)
            } )
            .alert("Hilfe zu neuer Benutzer", isPresented: $showSettingsHilfe, actions: {
                Button(" - OK - ") {}
            }, message: { Text("Das ist die Beschreibung für den Bereich Benutzer hinzufügen.") } // Ende message
            ) // Ende alert
            
            
        } // Ende NavigationView
    
    } // Ende var body
} // Ende struct ShapeViewAddUser


struct ShapeViewSettings: View {
    //@Environment(\.presentationMode) var presentationMode
    @Binding var isPresented: Bool
    
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @ObservedObject var userSettingsDefaults = UserSettingsDefaults.shared
    
    @State var showSettingsHilfe: Bool = false
    
    @State var colorData = ColorData()
    
    
    var body: some View {
        
        
        NavigationView {
            
            Form {
                
                 Section(header: Text("Farbeinstellung")) {
                    ColorPicker("Farben für Ebene 0", selection:  $globaleVariable.farbenEbene0, supportsOpacity: false)
                        .onAppear ( perform: {globaleVariable.farbenEbene0 = colorData.loadColor0()})
                        .frame(width: 300, height: 40)
                        
                    ColorPicker("Farben für Ebene 1", selection: $globaleVariable.farbenEbene1, supportsOpacity: false)
                        .onAppear ( perform: {globaleVariable.farbenEbene1 = colorData.loadColor1()})
                        .frame(width: 300, height: 40)
                    
                }// Ende Section Farben
                
            } // Ende Form
            .navigationBarItems(trailing: Button( action: {
            
                colorData.saveColor(color0: globaleVariable.farbenEbene0, color1: globaleVariable.farbenEbene1)
                //presentationMode.wrappedValue.dismiss()
                isPresented = false
                
            }) {Image(systemName: "x.circle.fill").imageScale(.large)} )
            .navigationBarItems(trailing: Button( action: {
                showSettingsHilfe = true
            }) {Image(systemName: "questionmark.circle.fill").imageScale(.large)} )
            .alert("Hilfe zu Settings", isPresented: $showSettingsHilfe, actions: {
                  Button(" - OK - ") {}
                  }, message: { Text("Das ist die Beschreibung für den Bereich Settings.") } // Ende message
                ) // Ende alert
            
            
        } // Ende NavigationView
    } // Ende var body
} // Ende struct ShapeViewSettings
