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
   @Binding var isParameterBereich: Bool
    
   @State var showHilfe: Bool = false
    @State var showWarnung: Bool = false
    
   @State var selectedPerson_sexInt: Int = 0

   @State var vorname: String = ""
   @State var name: String = ""
   @State var spitzname: String = ""

   var body: some View {
       NavigationView {
           Form {
               Section() {
                   
                   TextField("Vorname", text: $vorname)
                       .padding(5)
                       .background(Color(.systemGray6))
                       .cornerRadius(5)
                       .disableAutocorrection(true)
                   
                   TextField("Name", text: $name)
                       .padding(5)
                       .background(Color(.systemGray6))
                       .cornerRadius(5)
                       .disableAutocorrection(true)
                   
                   Picker("Geschlecht:", selection: $selectedPerson_sexInt) {
                       
                       ForEach(0..<globaleVariable.parameterPersonSex.count, id: \.self) { index in
                           Text("\(globaleVariable.parameterPersonSex[index])")
                           
                       } // Ende ForEach
                   } // Ende Picker
               } // Ende Section
               
               Button(action: {
                   if vorname != "" && name != "" {
                       if isParameterBereich {
                           //let tempPerson = name + ", " + vorname
                           //globaleVariable.parameterPerson.append(tempPerson)
                           personenDatenInVariableSchreiben(par1: vorname, par2: name, par3: globaleVariable.parameterPersonSex[selectedPerson_sexInt])
                           // Es wird in der Eingabemaske bei Personen die neue Person ausgewählt
                           //globaleVariable.selectedPersonInt = globaleVariable.parameterPerson.count-1
                           globaleVariable.selectedPersonInt = globaleVariable.personenParameter.count-1
                           print("Person wird in die Auswahl hinzugefügt!")
                           isPresented = false
                       }else{
                           
                           if pruefenDieElementeDerDatenbank(parPerson: ["\(vorname)","\(name)","\(globaleVariable.parameterPersonSex[selectedPerson_sexInt])"], parGegenstand: "") {
                       
                               showWarnung = true
                               
                           }else{
                               
                               personenDatenInDatenbankSchreiben(par1: vorname, par2: name, par3: globaleVariable.parameterPersonSex[selectedPerson_sexInt])
                               //globaleVariable.parameterPerson.removeAll()
                               //globaleVariable.parameterPerson = personenArray()
                               globaleVariable.personenParameter.removeAll()
                               globaleVariable.personenParameter = querySQLAbfrageClassPersonen(queryTmp: "Select * From Personen")
                               
                               
                               print("Person wurde in die Datenbank hinzugefügt!")
                               isPresented = false
                               
                           } // Ende if/else
                           
                       }// Ende if/else
                       
                   } // Ende if/else
               
               }) {
                   HStack {
                       Image(systemName: "square.and.arrow.down.fill")
                           .font(.title3)
                       Text("Person hinzufügen")
                           .fontWeight(.semibold)
                           .font(.title3)
                       
                   } // Ende HStack
                   .padding()
                   .frame(maxWidth: .infinity, alignment: .center)
                   .foregroundColor(.white)
                   .background(Color.blue)
                   .cornerRadius(10)
               } // Ende Button
               .alert("Warnung zu neuer Person", isPresented: $showWarnung, actions: {
                   Button(" - OK - ") {}
               }, message: { Text("Die Person: '\(vorname)' '\(name)' befindet sich schon in der Datenbank. In der Datenbank können keine Duplikate gespeichert werden!") } // Ende message
               ) // Ende alert
               
               
               if isParameterBereich {
                   
                   Text("Mit drücken von 'Person hinzufügen' werden die Personendaten nur zur Auswahl in der Eingabemaske hinzugefügt. Sie werden nach beenden des Programms gelöscht. Möchten Sie eine Person dauerhaft zur Auswahl in der Eingabemaske haben, gehen Sie bitte zum Menue-Punkt 'Hinzufügen/Person' und geben Sie dort die Persondaten ein.")
                       .font(.system(size: 14, weight: .regular))
                       .foregroundColor(.gray)
               }else{
                   Text("Mit drücken von 'Person hinzufügen' werden die Daten in die Datenbank hinzugefügt.")
                       .font(.system(size: 14, weight: .regular))
                       .foregroundColor(.gray)
                   
               } // Ende if/else
               
           } // Ende Form
           .navigationBarItems(trailing:
                                HStack {
               
               Button(action: {showHilfe = true}) {Image(systemName: "questionmark.circle").imageScale(.large)}
               Button(action: {isPresented = false}) { Image(systemName: "figure.walk.circle").imageScale(.large)}
               
           }) // Ende NavigationBarItem
                 .alert("Hilfe zu neuer Benutzer", isPresented: $showHilfe, actions:
                            { Button(" - OK - ") {}
                            }, message: { Text("Das ist die Beschreibung für den Bereich Benutzer hinzufügen.") } ) // Ende alert
       } // Ende NavigationView
   } // Ende var body
} // Ende struct

struct ShapeViewAddGegenstand: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @Binding var isPresented: Bool
    @Binding var isParameterBereich: Bool
    
    @State var showHilfe: Bool = false
    @State var showWarnung: Bool = false
    
    @State var gegenstandNeu: String = ""
    
    var body: some View {
        
        NavigationView {
            
            Form {
                Section(){
                    TextField("Gegenstand", text: $gegenstandNeu)
                        .padding(5)
                        .background(Color(.systemGray6))
                        .cornerRadius(5)
                        .disableAutocorrection(true)
                    
                } // Ende Section
        
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
                    HStack {
                        Image(systemName: "square.and.arrow.down.fill")
                            .font(.title3)
                        Text("Gegenstand hinzufügen")
                            .fontWeight(.semibold)
                            .font(.title3)
                    } // Ende HStack
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                } // Ende Button
                .alert("Warnung zu neuem Gegenstand", isPresented: $showWarnung, actions: {
                    Button(" - OK - ") {}
                }, message: { Text("Der Gegenstand: '\(gegenstandNeu)' befindet sich schon in der Datenbank. In der Datenbank können keine Duplikate gespeichert werden!") } // Ende message
                ) // Ende alert
                
                
                if isParameterBereich {
                    Text("Mit drücken von 'Gegenstand hinzufügen' wird der neue Gegenstand in die Auswahl hinzugefügt.")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                }else{
                    Text("Mit drücken von 'Gegenstand hinzufügen' wird der neue Gegenstand in die Datenbank hinzugefügt.")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                    
                } // Ende if/else
                
            } // Ende Form
            .scrollContentBackground(.hidden)
            .navigationBarItems(trailing: Button( action: {
                isPresented = false
                
            }) {Image(systemName: "figure.walk.circle")
                .imageScale(.large)
            } )
            .navigationBarItems(trailing: Button( action: {
                showHilfe = true
            }) {Image(systemName: "questionmark.circle")
                .imageScale(.large)
            } )
            .alert("Hilfe zu neuer Gegenstand", isPresented: $showHilfe, actions: {
                Button(" - OK - ") {}
            }, message: { Text("Das ist die Beschreibung für den Bereich Gegenstand hinzufügen.") } // Ende message
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
                
                Toggle("Zeige Handbuch", isOn: $userSettingsDefaults.showHandbuch ).toggleStyle(SwitchToggleStyle(tint: .blue))
                
            } // Ende Form
            .navigationBarItems(trailing: Button( action: {
            
                colorData.saveColor(color0: globaleVariable.farbenEbene0, color1: globaleVariable.farbenEbene1)
                //presentationMode.wrappedValue.dismiss()
                isPresented = false
                
            }) {Image(systemName: "figure.walk.circle").imageScale(.large)} )
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


struct ShapeViewAbfrage: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @ObservedObject var userSettingsDefaults = UserSettingsDefaults.shared
    
    @Binding var isPresented: Bool
    
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
            Text("")
            Text("Abfragefilter").bold()
            Form {
                Section(header: Text("Bedingung")) {
                    Picker("Wenn ", selection: $selectedAbfrageFeld1, content: {
                        ForEach(abfrageFeld1, id: \.self, content: { index1 in
                            Text(index1)
                        })
                    })
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
                        
                        Picker("", selection: $selectedAbfrageFeld2, content: {
                            ForEach(abfrageFeld2, id: \.self, content: { index2 in
                                Text(index2)
                            })
                        })
                        //.pickerStyle(.inline)
                        .frame(height: 30)
                        
                    } // Ende HStack
                    
                    Picker("", selection: $selectedAbfrageFeld3, content: {
                        ForEach(abfrageFeld3, id: \.self, content: { index3 in
                            Text(index3)
                        })
                        
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
                
                Section(header: Text("Filteraktivierung")) {
                    Toggle("Filterschalter:", isOn: $globaleVariable.abfrageFilter ).toggleStyle(SwitchToggleStyle(tint: .blue))
                    
                } // Ende Section
                
                
                HStack {
                    Spacer()
                    
                    Button(action: {showAlertSpeichernButton = true}) { Label("Abfrage verlassen.", systemImage: "pencil.and.outline")}.buttonStyle(.borderedProminent).foregroundColor(.white).font(.system(size: 16, weight: .regular))
                        .alert(isPresented:$showAlertSpeichernButton) {
                            Alert(
                                title: Text("Möchten Sie diese Abfrage speichern?"),
                                message: Text("Die Abfrage und der Zustand der Filteraktivierung werden bis zum nächsten Aufruf dieser Seite gespeichert."),
                                primaryButton: .destructive(Text("Speichern")) {
                                    
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
                                    
                                    // Tab1 Objektliste wird gezeigt
                                    globaleVariable.navigationTabView = 1
                                    
                                    isPresented = false
                                },
                                secondaryButton: .cancel(Text("Abbrechen")){
                                    print("Abgebrochen ....")
                                    isPresented = false
                                }
                            ) // Ende Alert
                        } // Ende alert
                    Spacer()
                } // Ende HStack
                
                Section {
                    Text("Hier können Sie die Abfrage für Darstellung Ihrer Objektenabelle definieren und speichern. Die Abfrage behält ihre Gültigkeit bis zum erneutem Start dieser Darstellung.")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                    
                } // Ende Section
            } // Ende Form
            .background(globaleVariable.farbenEbene1)
            .cornerRadius(10)
            
        } // Ende VStack
    } // Ende var body
} // Ende struct
