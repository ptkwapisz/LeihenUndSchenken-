//
//  PhoneViews.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 01.05.23.
//

import SwiftUI
import Foundation



struct IphoneTable1: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    var body: some View {
        
        let tempErgaenzung: String = erstelleTitel(par: globaleVariable.abfrageFilter)
        
        let objekte = querySQLAbfrageClassObjecte(queryTmp: "SELECT * FROM Objekte")
        
        let gegVorgang = distingtArray(par1: objekte, par2: "Vorgang") // Leihen oder Schänken
        
        //var tempErgaenzung = ""
        
        let anzahl: Int = objekte.count
      
            VStack {
                Text("")
                Text("Alle Vorgänge" + "\(tempErgaenzung)").bold()
                    .frame(maxWidth: .infinity, alignment: .center)
                
                    List {
                        
                            ForEach(gegVorgang.indices, id: \.self) { idx in
                            
                                Section(header: Text("Vorgang: " + "\(gegVorgang[idx])")
                                    .font(.system(size: 15, weight: .medium)).bold()) {
                          
                                        ForEach(0..<anzahl, id: \.self) { item in
                                            
                                            if gegVorgang[idx] == objekte[item].vorgang {
                                                
                                                VStack() {
                                        
                                                    
                                                    HStack {
                                                        
                                                        Text("\(objekte[item].gegenstand)")
                                                        Text(" am ")
                                                        Text("\(objekte[item].datum)")
                                                        
                                                        Spacer()
                                                        
                                                    } // Ende HStack
                                                    .background(globaleVariable.farbenEbene0).foregroundColor(Color.white)
                                                    .font(.system(size: 18, weight: .medium)).bold()
                                                    
                                                    HStack {
                                                        NavigationLink(destination: ChartView(par1: objekte, par2: item)) {
                                                            
                                                            
                                                            Text(String(objekte[item].personVorname))
                                                                .background(globaleVariable.farbenEbene0).foregroundColor(Color.white)
                                                                .font(.system(size: 15, weight: .medium)).bold()
                                                            
                                                            Text(String(objekte[item].personNachname))
                                                                .background(globaleVariable.farbenEbene0).foregroundColor(Color.white)
                                                                .font(.system(size: 15, weight: .medium)).bold()
                                                            
                                                            Spacer()
                                                            
                                                            Label{} icon: { Image(systemName: "photo.fill.on.rectangle.fill") .font(.system(size: 16, weight: .medium))
                                                            } // Ende Label
                                                            .frame(width:35, height: 25, alignment: .center)
                                                            //.background(.gray)
                                                            .cornerRadius(10)
                                                            .foregroundColor(.white)
                                                            // Diese Zeile bewirkt, dass Label rechtsbündig kurz vor dem > erscheint
                                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                                            
                                                            
                                                        } // Ende NavigationLink
                                                    
                                                    } // Ende HStack
                                                    
                                                } // Ende VStack
                                                
                                            } // Ende if blutKat1
                                        } // Ende ForEach
                                        .listRowBackground(globaleVariable.farbenEbene0)
                                        .listRowSeparatorTint(.white)
                                        
                                   } // Ende Section
                                
                            } // Ende ForEach
                        
                    } // Ende List
                    .cornerRadius(10)
                   
            } // Ende VStack
            //.frame(width: 360, height: 570)
            .background(globaleVariable.farbenEbene1)
            .cornerRadius(10)
            .shadow(radius: 10)
       
    } // Ende var body
    
} // Ende struct

struct IphoneTable2: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @State var isParameterBereich: Bool = false
    @State var gegenstandHinzufuegen: Bool = false
    @State var errorMessageText = ""
    @State var selectedTypeTmp = ""
    
    @State private var selectedType: String? = "Buch"
    
    @State private var showAlert = false
    @State private var activeAlert: ActiveAlert = .error
    
    var body: some View {
      
      let gegenstaende = querySQLAbfrageClassGegenstaende(queryTmp: "Select * FROM Gegenstaende")
        
        VStack {
            Text("")
            Text("Gegenstände").bold()
            
            List(gegenstaende, id: \.gegenstandName, selection: $selectedType) { index in
                Text(index.gegenstandName)
                
            } // Ende List
           
            HStack(alignment: .bottom) {
                
                Button {
                    gegenstandHinzufuegen = true
                    
                } label: {
                    Label("", systemImage: "rectangle.stack.fill.badge.plus")
                    
                } // Ende Button
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color.white)
                .offset(x: 10)
                
                Text("|")
                    .offset(x:3, y: -3)
                    .foregroundColor(Color.white)
                
                Button() {
                    
                    selectedTypeTmp = "\(selectedType ?? "N/A")"
                    print("\(selectedType ?? "N/A")")
                    
                    if selectedTypeTmp == "Buch" || selectedType == "Geld" || selectedType == "CD/DVD" || selectedType == "Werkzeug"{
                        errorMessageText = "Standard Gegenstände, wie Buch, Geld, CD/DVD und Werkzeug können nicht gelöscht werden!"
                        
                        showAlert = true
                        activeAlert = .error
                        
                    }else{
                        
                        showAlert = true
                        activeAlert = .delete
                    }// Ende if/else
                } label: {
                    Label("", systemImage: "rectangle.stack.fill.badge.minus")
                } // Ende Button
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color.white)
                .offset(x: 10)
                .alert(isPresented: $showAlert) {
                    switch activeAlert {
                        case .error:
                            return Alert(title: Text("Wichtige Information"), message: Text(errorMessageText), dismissButton: .default(Text("OK")))
                        case .delete:
                            return Alert(
                                title: Text("Wichtige Information!"),
                                message: Text("Der Gegenstand: \(selectedTypeTmp) wird unwiederfuflich gelöscht! Man kann den Vorgang nicht rückgängich machen!"),
                                primaryButton: .destructive(Text("Löschen")) {
                                    
                                    let perKeyTmp = perKeyBestimmenGegenstand(par: selectedTypeTmp)
                                    deleteItemsFromDatabase(tabelle: "Gegenstaende", perKey: perKeyTmp[0])
                                    print("\(selectedTypeTmp)" + " wurde gelöscht")
                                    refreshAllViews()
                                    
                                },
                                secondaryButton: .cancel(Text("Abbrechen")){
                                    print("Abgebrochen ....")
                                } // Ende secondary Button
                            ) // Ende Aler
                    } // Ende switch
                } // Ende alert
                
                Text("|")
                    .offset(x:3, y: -3)
                    .foregroundColor(Color.white)
            }
            .frame(width: UIScreen.screenWidth, height: 25, alignment: .leading)
            .background(.gray)
            .foregroundColor(Color.black)
            .sheet(isPresented: $gegenstandHinzufuegen, content: { ShapeViewAddGegenstand(isPresented: $gegenstandHinzufuegen, isParameterBereich: $isParameterBereich) })
            
        
        } // Ende Vstack
        .background(globaleVariable.farbenEbene1)
        //.cornerRadius(10)
        .shadow(radius: 10)
        
    }// Ende var body
    
} // Ende struct

struct IphoneTable3: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    @State var isParameterBereich: Bool = false
    @State var personHinzufuegen: Bool = false
    //@State var showAlert = false
    @State var errorMessageText = ""
    
    @State var selectedPickerTmp: String = ""
    
    //@State var person = querySQLAbfrageClassPerson(queryTmp: "Select * from Personen")
    @State var selectedPicker: String?
    
    @State private var showAlert = false
    @State private var activeAlert: ActiveAlert = .error
    
    var body: some View {
      
        let person = querySQLAbfrageClassPerson(queryTmp: "Select * from Personen", isObjectTabelle: false)
        
        VStack {
            Text("")
            Text("Personen").bold()
            
            List(person, id: \.personPicker, selection: $selectedPicker) { index in
                
                Text(index.personPicker)
                
            } // Ende List
            
            HStack(alignment: .bottom) {
                Button {
                    personHinzufuegen = true
                } label: {
                    Label("",systemImage: "person.fill.badge.plus")
                } // Ende Button/label
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color.white)
                .offset(x: 10)
                
                Text("|")
                    .offset(x:3, y: -3)
                    .foregroundColor(Color.white)
                Button {
                    
                    selectedPickerTmp = "\(selectedPicker ?? "N/A")"
                    
                    //print("\(selectedPickerTmp ?? "N/A")")
                    
                    if selectedPickerTmp == "N/A" {
                        errorMessageText = "Bitte suchen Sie zuerst eine Person die Sie löschen möchten aus. Dann markieren sie durch das Klicken die entsprechende Zeile. Danach betätigen Sie noch mal das Minuszeichen."
                        
                        showAlert = true
                        activeAlert = .error
                    }else{
                        
                        showAlert = true
                        activeAlert = .delete
                        
                        
                    }// Ende if/else
                } label: {
                    
                    Label("",systemImage: "person.fill.badge.minus")
                    
                } // Ende Button/label
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color.white)
                .offset(x: 10)
                .alert(isPresented: $showAlert) {
                    switch activeAlert {
                        case .error:
                            return Alert(title: Text("Wichtige Information"), message: Text(errorMessageText), dismissButton: .default(Text("OK")))
                        case .delete:
                            return Alert(
                                title: Text("Wichtige Information!"),
                                message: Text("Die Person: \(selectedPickerTmp) wird unwiederfuflich gelöscht! Man kann diesen Vorgang nicht rückgängich machen!"),
                                primaryButton: .destructive(Text("Löschen")) {
                                    
                                    let perKeyTmp = perKeyBestimmenPerson(par: selectedPickerTmp)
                                    deleteItemsFromDatabase(tabelle: "Personen", perKey: perKeyTmp[0])
                                    print("\(selectedPickerTmp)" + " wurde gelöscht")
                                    print(perKeyTmp)
                                    
                                    refreshAllViews()
                                },
                                secondaryButton: .cancel(Text("Abbrechen")){
                                    print("\(selectedPickerTmp)" + " wurde nicht gelöscht")
                                    print("Abgebrochen ....")
                                } // Ende secondary Button
                            ) // Ende Aler
                    } // Ende switch
                } // Ende alert
               
                Text("|")
                .offset(x:3, y: -3)
                .foregroundColor(Color.white)
                
            } // Ende HStack
            .frame(width: UIScreen.screenWidth, height: 25, alignment: .leading)
            .background(.gray)
            //.cornerRadius(10)
            .foregroundColor(Color.black)
            .sheet(isPresented: $personHinzufuegen, content: {ShapeViewAddUser(isPresented: $personHinzufuegen, isParameterBereich: $isParameterBereich)})
            
            
        } // Ende Vstack
        .background(globaleVariable.farbenEbene1)
        //.cornerRadius(10)
        .shadow(radius: 10)
    
    }// Ende var body
    
} // Ende struct

func perKeyBestimmenGegenstand(par: String) -> [String] {
    var result: [String] = [""]
    
    if par != "N/A" {
        result = querySQLAbfrageArray(queryTmp: "SELECT perKey FROM Gegenstaende WHERE gegenstandName = '\(par)'")
    }else{
        result = [""]
    } // Ende if/else

    return result
} // Ende func



func perKeyBestimmenPerson(par: String) -> [String] {
    var result: [String] = [""]
    
    if par != "N/A" {
        result = querySQLAbfrageArray(queryTmp: "SELECT perKey FROM Personen WHERE personPicker = '\(par)'")
    }else{
        result = [""]
    } // Ende if/else

    return result
} // Ende func


// Diese enum wird für Alertmeldung benutzt
enum ActiveAlert {
    case error, delete
} // Ende enum
