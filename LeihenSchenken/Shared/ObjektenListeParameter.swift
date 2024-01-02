//
//  ObjektenListeParameter.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 26.12.23.
//

import SwiftUI

struct ObjektListeParameter: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @ObservedObject var sheredData = SharedData.shared
    @Binding var isPresented: Bool
    
    @State var tmpTitel: String = ""
    @State var tmpUnterTitel: String = ""
    // Diese Variable zeigt, ob man die View mit dem 'Daten übernehmen' Taste verläst.
    // Wenn man die View mit der Taste 'Zurück' (var btnBack) verlässt werden die Änderungen verworfen
    @State var endeSaveButton: Bool = false
    
    @FocusState private var focusedFields: Field?
    
    private enum Field: Int, CaseIterable {
        case titel // Für titel
        case unterTitel // Für Untertitel
        
    } // Ende private enum
    
    // Das ist eigenes Button
    // Ohne dieses Button wird der Name der View angezeigt (Gegenstandsname)
    // Wenn man aber den Gegenstandsname ändert bleibt es in der Anzeige als zurück der alte Name.
    var btnBack : some View { Button(action: {
        isPresented = false
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
            if !endeSaveButton {
                sheredData.titel = tmpTitel
                sheredData.unterTitel = tmpUnterTitel
            }
            print("Disappear in ObjektListeParameter wurde ausgeführt.")
            
        } // Ende onDisappear
    } // Ende Button Label
    } // Ende some View
    
    
    var body: some View {
        let _ = print("Struct ObjektListParameter wird aufgerufen!")
        
        GeometryReader { geometry in
            
            VStack {
                VStack {
                    Text("")
                    Text("Parameter").bold()
                    List {
                        Section(header: Text("Kopfzeilen der Liste").foregroundColor(.gray).font(.system(size: 16, weight: .regular))) {
                            
                            
                            CustomTextField(text: $sheredData.titel, isMultiLine: false, placeholder: "Listentitel")
                                .focused($focusedFields, equals: .titel)
                            
                            
                            CustomTextField(text: $sheredData.unterTitel, isMultiLine: false, placeholder: "Listenuntertitel")
                                .focused($focusedFields, equals: .unterTitel)
                            
                        }// Ende Section
                        .font(.system(size: 16, weight: .regular))
                        
                        Section {
                            Toggle("Das Feld Preis/Wert:", isOn: $globaleVariable.preisOderWert ).toggleStyle(SwitchToggleStyle(tint: .blue)).font(.system(size: 16, weight: .regular))
                        } footer: {
                            
                            Text("Beim Einschalten wird das Feld Preis/Wert falls vorhanden, neben dem Gegenstand auf der Liste mitangezeigt.").font(.system(size: 12, weight: .regular))
                            
                        } // Ende Section
                        
                        HStack {
                            Spacer()
                            
                            Button {
                                print("Titel und Untertitel wurden übernohmen!")
                                // Is defined in GlobaleVariablen
                               
                                endeSaveButton = true
                                
                                isPresented.toggle()
                                
                            } label: {
                                Label("Daten übernehmen", systemImage: "arrowshape.turn.up.backward.circle")
                                
                            } // Ende Button
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color.white)
                            .buttonStyle(.borderedProminent)
                            .cornerRadius(10)
                            .disabled(sheredData.titel.isEmpty && sheredData.unterTitel.isEmpty)
                            
                            Spacer()
                        } // Ende HStack
                        .padding()
                        
                        Text("Beim Drücken auf 'Daten übernehmen' wird das Fenster geschloßen und die einzehlen Parameter werden gespeichert.")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.gray)
                        
                    } // Ende List
                    
                    
                } // Ende VStack
                .frame(width: geometry.size.width,height: geometry.size.height * globaleVariable.heightFaktorEbene1, alignment: .center)
                .background(globaleVariable.farbenEbene1)
                .cornerRadius(10)
                
            } // Ende VStack
            .frame(width: geometry.size.width,height: geometry.size.height * globaleVariable.heightFaktorEbene0, alignment: .center)
            .background(globaleVariable.farbenEbene0)
            .navigationTitle("PDF Objektliste").navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden()
            .navigationBarItems(leading: btnBack)
            
            
        } // Ende GeometryReader
        .interactiveDismissDisabled()  // Disable dismiss with a swipe
        .onAppear {
            
            tmpTitel = sheredData.titel
            tmpUnterTitel = sheredData.unterTitel
            
        } // Ende onAppear
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                
                if focusedFields == .titel {
                    HStack{
                        Spacer()
                        Button("Abbrechen") {
                            
                            print("Abbrechen Button titel wurde gedrückt!")
                            focusedFields = nil
                        } // Ende Button
                    } // Ende HStack
                }else if focusedFields == .unterTitel {
                    HStack{
                        Spacer()
                        Button("Abbrechen") {
                            
                            print("Abbrechen Button unterTitel wurde gedrückt!")
                            focusedFields = nil
                        } // Ende Button
                    } // Ende HStack
                    
                } // Ende if/else
                
            } // Ende ToolbarItemGroup
        }// Ende toolbar
        
    } // Ende var body
    
} // Ende struct

