//
//  ShapeViews.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 27.03.23.
//

import Foundation
import SwiftUI

/*
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
                        ForEach(0..<$globaleVariable.parameterPersonSex.count, id: \.self) { index in
                            Text("\(globaleVariable.parameterPersonSex[index])")//.tag(index)
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
*/

struct ShapeViewAddUser: View {
   @ObservedObject var globaleVariable = GlobaleVariable.shared
   @Binding var isPresented: Bool
   @Binding var isParameterBereich: Bool
    
   @State var showSettingsHilfe: Bool = false

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
                   if isParameterBereich {
                       
                       if vorname != "" && name != "" {
                           let tempPerson = name + ", " + vorname
                           globaleVariable.parameterPerson.append(tempPerson)
                           personenDatenInVariableSchreiben(par1: vorname, par2: name, par3: globaleVariable.parameterPersonSex[selectedPerson_sexInt])
                           print("Person wird in die Auswahl hinzugefügt!")
                           isPresented = false
                       }else{
                           
                           print("Person wurde in die Auswahl nicht hinzugefügt!")
                       } // Ende if/else
                   }else{
                       
                       if vorname != "" && name != ""{
                           //let tempPerson = name + ", " + vorname
                           //globaleVariable.parameterPerson.append(tempPerson)
                           personenDatenInDatenbankSchreiben(par1: vorname, par2: name, par3: globaleVariable.parameterPersonSex[selectedPerson_sexInt])
                           print("Person wird in die Datenbank hinzugefügt!")
                           isPresented = false
                       }else{
                           print("Person wurde in die Datenbank nicht hinzugefügt!")
                       } // Ende if/else
                       
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
               
               Button(action: {showSettingsHilfe = true}) {Image(systemName: "questionmark.circle.fill").imageScale(.large)}
               Button(action: {isPresented = false}) { Image(systemName: "figure.walk.circle").imageScale(.large)}
               
           }) // Ende NavigationBarItem
                 .alert("Hilfe zu neuer Benutzer", isPresented: $showSettingsHilfe, actions:
                            { Button(" - OK - ") {}
                            }, message: { Text("Das ist die Beschreibung für den Bereich Benutzer hinzufügen.") } ) // Ende alert
       } // Ende NavigationView
   } // Ende var body
} // Ende struct



struct ShapeViewAddGegenstand: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @Binding var isPresented: Bool
    @Binding var isParameterBereich: Bool
    
    @State var showSettingsHilfe: Bool = false
    
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
                            print("Gegenstand in die Auswahl hinzufügen!")
                        }else{
                            print("Gegenstand in die Datenbank hinzufügen!")
                        } // Ende if/else
                        
                        isPresented = false
                        
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
                showSettingsHilfe = true
            }) {Image(systemName: "questionmark.circle.fill")
                .imageScale(.large)
            } )
            .alert("Hilfe zu neuer Gegenstand", isPresented: $showSettingsHilfe, actions: {
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
    //@ObservedObject var userSettingsDefaults = UserSettingsDefaults.shared
    
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
    @Binding var isPresented: Bool
    
    @State var showAlertAbbrechenButton: Bool = false
    @State var showAlertSpeichernButton: Bool = false
    
    @State var operatorZeichen: [String] = ["gleich", "ungleich"]
    @State private var selectedOperatorZeichen = "gleich"
    
    @State var tabellenFeld1: [String] = ["Gegenstand", "Vorgang","Name", "Vorname"]
    @State private var selectedTabellenFeld1 = "Gegenstand"
    
    //@State var tabellenFeld2: [String] = ["Buch", "Geld","CD/DVD", "Werkzeug"]
    
    @State var tabellenFeld2: [String] = querySQLAbfrageArray(queryTmp: "SELECT DISTINCT gegenstand FROM Objekte ORDER BY gegenstand")
    @State var selectedTabellenFeld2: String = extrahierenString(arrayTemp: querySQLAbfrageArray(queryTmp: "SELECT DISTINCT gegenstand FROM Objekte ORDER BY gegenstand"))
    
    var body: some View {
        
        VStack {
            Text("Filter").bold()
            Form {
                Section(header: Text("Bedingung")) {
                    Picker("Wenn ", selection: $selectedTabellenFeld1, content: {
                        ForEach(tabellenFeld1, id: \.self, content: { index1 in
                            Text(index1)
                        })
                    })
                    .frame(height: 30)
                    .onChange(of: selectedTabellenFeld1, perform: { _ in
                        
                        switch selectedTabellenFeld1 {
                                
                            case "Gegenstand":
                                tabellenFeld2 = querySQLAbfrageArray(queryTmp: "SELECT DISTINCT gegenstand FROM Objekte ORDER BY gegenstand")
                                selectedTabellenFeld2 = tabellenFeld2[0]
                                print("Gegenstand")
                            case "Vorgang":
                                tabellenFeld2 = ["Leihen", "Schänken"]
                                selectedTabellenFeld2 = "Leihen"
                                print("Vorgang")
                            case "Name":
                                tabellenFeld2 = querySQLAbfrageArray(queryTmp: "SELECT DISTINCT personNachname FROM Objekte ORDER BY personNachname")
                                selectedTabellenFeld2 = tabellenFeld2[0]
                                print("Nachname")
                            case "Vorname":
                                tabellenFeld2 = querySQLAbfrageArray(queryTmp: "SELECT DISTINCT personVorname FROM Objekte ORDER BY personVorname")
                                selectedTabellenFeld2 = tabellenFeld2[0]
                                print("Vorname")
                            default:
                                print("Keine Wahl")
                        } // Ende switch
                        
                    }) // Ende onChange...
                    
                    HStack{
                        Text("ist  ")
                        Picker("", selection: $selectedOperatorZeichen, content: {
                            ForEach(operatorZeichen, id: \.self, content: { index2 in
                                Text(index2)
                            })
                        })
                        .pickerStyle(.wheel)
                        .frame(height: 50)
                        
                    } // Ende HStack
                    
                    Picker("", selection: $selectedTabellenFeld2, content: {
                        ForEach(tabellenFeld2, id: \.self, content: { index3 in
                            Text(index3)
                        })
                    })
                    .frame(height: 30)
                } // Ende Section
                
                Section(header: Text("Abfragenparameter")) {
                    Toggle("Filteraktivirung:", isOn: $globaleVariable.abfrageFilter ).toggleStyle(SwitchToggleStyle(tint: .blue))
                } // Ende Section
                
                
                HStack {
                        
                    Button(action: {showAlertAbbrechenButton = true}) { Label("Abbrechen", systemImage: "pencil.slash") } .buttonStyle(.bordered).foregroundColor(.blue).font(.system(size: 16, weight: .regular))
                        .alert(isPresented:$showAlertAbbrechenButton) {
                            Alert(
                                title: Text("Möchten Sie abbrechen und die Abfrage zurücksetzen?"),
                                message: Text("Die Abfrage und die Filteraktivierung werden zurückgesetzt"),
                                primaryButton: .destructive(Text("Zurücksetzen")) {
                                    globaleVariable.abfrageFilter = false
                                    globaleVariable.abfrageQueryString = ""
                                    isPresented = false
                                    
                                },
                                secondaryButton: .cancel(Text("Abbrechen")){
                                    print("Abgebrochen ....")
                                } // Ende secondary Button
                            ) // Ende Alert
                        } // Ende alert
                    
                    Button(action: {showAlertSpeichernButton = true}) { Label("Speichern", systemImage: "pencil.and.outline")}.buttonStyle(.borderedProminent).foregroundColor(.white).font(.system(size: 16, weight: .regular))
                        .alert(isPresented:$showAlertSpeichernButton) {
                            Alert(
                                title: Text("Möchten Sie diese Abfrage speichern?"),
                                message: Text("Die Abfrage und der Zustand der Filteraktivierung werden gespeichert."),
                                primaryButton: .destructive(Text("Speichern")) {
                                    var tmpFeld1 = ""
                                    if globaleVariable.abfrageFilter == true {
                                        if selectedTabellenFeld1 == "Name" {
                                           tmpFeld1 = "personNachname"
                                        }
                                        if selectedTabellenFeld1 == "Vorname" {
                                           tmpFeld1 = "personVorname"
                                        }
                                        if selectedTabellenFeld1 == "Gegenstand" || selectedTabellenFeld1 == "Vorgang" {
                                           tmpFeld1 = selectedTabellenFeld1
                                        }
                                        
                                       let temp = " WHERE " + "\(tmpFeld1)" + " = " + "'" + "\(selectedTabellenFeld2)" + "'"
                                        globaleVariable.abfrageQueryString = temp
                                        
                                    }else{
                                        globaleVariable.abfrageQueryString = ""
                                    } // Ende if
                                    
                                    isPresented = false
                                },
                                secondaryButton: .cancel(Text("Abbrechen")){
                                    print("Abgebrochen ....")
                                    //isPresented = false
                                }
                            ) // Ende Alert
                        } // Ende alert
                    
                    } // Ende HStack
            
            } // Ende Form
            .background(globaleVariable.farbenEbene1)
            .cornerRadius(10)
            //.frame(width: 360, height: 570)
                           
        } // Ende VStack
    } // Ende var body
} // Ende struct
