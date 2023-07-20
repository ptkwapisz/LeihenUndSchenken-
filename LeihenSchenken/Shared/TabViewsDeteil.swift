//
//  TabViewsDeteil.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 20.07.23.
//

import SwiftUI

struct deteilTab1: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @Binding var sideBarWidth: CGFloat
    
    
    @State var zeile: Int = 0
    @State var showEingabeMaske: Bool = false
    @State private var showAlert = false
    @State private var activeAlert: ActiveAlert = .error
    var body: some View {
        
        
        let tempErgaenzung: String = erstelleTitel(par: globaleVariable.abfrageFilter)
        let objekteTmp = querySQLAbfrageClassObjecte(queryTmp: "SELECT * FROM Objekte")
        let objekte = objekteTmp.sorted {($0.vorgang, $0.personNachname, $0.personVorname) < ($1.vorgang, $1.personNachname, $1.personVorname)}
        let gegVorgang = distingtArray(par1: objekte, par2: "Vorgang") // Leihen, Schänken oder bekommen
        //let gegVorgang = gegVorgang0.sorted()
        let anzahl: Int = objekte.count
        
        
        VStack {
            Text("")
            Text("\(tempErgaenzung)").bold()
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
                                            Text("am")
                                            Text("\(objekte[item].datum)")
                                            
                                            Spacer()
                                            
                                        } // Ende HStack
                                      
                                        .font(.system(size: 16, weight: .medium)).bold()
                                        
                                        HStack {
                                            
                                            NavigationLink(destination: ChartView(par1: objekte, par2: item)) {
                                                
                                                if gegVorgang[idx] == "Bekommen" {
                                                    Text("von")
                                                        //.background(globaleVariable.farbenEbene0).foregroundColor(Color.white)
                                                        //.font(.system(size: 15, weight: .medium)).bold()
                                                } else {
                                                    Text("an")
                                                        //.background(globaleVariable.farbenEbene0).foregroundColor(Color.white)
                                                        //.font(.system(size: 15, weight: .medium)).bold()
                                                } // Ende if/else
                                                
                                                Text(String(objekte[item].personVorname))
                                                    //.background(globaleVariable.farbenEbene0).foregroundColor(Color.white)
                                                    //.font(.system(size: 15, weight: .medium)).bold()
                                                
                                                Text(String(objekte[item].personNachname))
                                                    //.background(globaleVariable.farbenEbene0).foregroundColor(Color.white)
                                                    //.font(.system(size: 15, weight: .medium)).bold()
                                                
                                                Spacer()
                                                
                                                Label{} icon: { Image(systemName: "photo.fill.on.rectangle.fill") .font(.system(size: 16, weight: .medium))
                                                } // Ende Label
                                                .frame(width:35, height: 25, alignment: .center)
                                                .cornerRadius(10)
                                                //.foregroundColor(.white)
                                                // Diese Zeile bewirkt, dass Label rechtsbündig kurz vor dem > erscheint
                                                .frame(maxWidth: .infinity, alignment: .trailing)
                                                
                                                
                                            } // Ende NavigationLink
                                            
                                        } // Ende HStack
                                        //.background(zeilenFarbe(par: item)).foregroundColor(Color.white)
                                        .font(.system(size: 15, weight: .medium)).bold()
                                        
                                    } // Ende VStack
                                    .foregroundColor(Color.white)
                                    .listRowBackground(zeilenFarbe(par: item))
                                } // Ende if gegVorgang
                                  
                            } // Ende ForEach
                            //.listRowBackground(globaleVariable.farbenEbene0)
                            .listRowSeparatorTint(.white)
                            
                            
                        } // Ende Section
                    
                } // Ende ForEach
                
            } // Ende List
            .cornerRadius(10)
            Spacer()
            HStack(alignment: .bottom) {
                
                Button {showEingabeMaske = true
            
                } label: { Label("", systemImage: "rectangle.stack.fill.badge.plus")
                    
                } // Ende Button
                .font(.system(size: 30, weight: .medium))
                .foregroundColor(Color.white)
                .offset(x: 10)
                .alert(isPresented: $showAlert) {
                    switch activeAlert {
                    
                    case .error:
                        // Dummy Alert
                        return Alert(title: Text(""), message: Text(""), dismissButton: .default(Text("OK")))
                    case .delete:
                        // Dummy Alert
                        return Alert(title: Text(""), message: Text(""), dismissButton: .default(Text("OK")))
                    
                    case .information:
                        return Alert(
                            title: Text("Wichtige Information!"),
                            message: Text("Es befinden sich keine Objekte in der Datenbank. Drücken Sie unten links auf den Stappel mit + Zeichen, um ein neues Objekt zu erfassen und in die Datenbank zu speichern."), dismissButton: .default(Text("OK")))
                        
                    } // Ende switch
                } // Ende alert
                
                Text("|")
                    .offset(x:3, y: -7)
                    .foregroundColor(Color.white)
                
            } // Ende HStack
            .frame(width: UIScreen.screenWidth - sideBarWidth, height: 34, alignment: .leading)
            .background(.gray)
            .foregroundColor(Color.black)
            .sheet(isPresented: $showEingabeMaske, content: { EingabeMaskeView() })
            
            
        } // Ende VStack
        .background(globaleVariable.farbenEbene1)
        .cornerRadius(10)
        .onAppear() {
            if objekteTmp.count == 0 {
                // Wenn sich keine Objekte in der Datenbanktabelle befinden
                // wird eine Information gezeigt.
                showAlert = true
                activeAlert = .information
                
            } // Ende if
            
        } // Ende onAppear
        
    } // Ende var body
    
} // Ende struct







struct deteilTab2: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @Binding var sideBarWidth: CGFloat
    
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
            Text("Favoritenliste").bold()
            
            List(gegenstaende, id: \.gegenstandName, selection: $selectedType) { index in
                Text(index.gegenstandName)
                
            } // Ende List
            .cornerRadius(10)
            
            HStack(alignment: .bottom) {
                
                Button {
                    gegenstandHinzufuegen = true
                    
                } label: {
                    Label("", systemImage: "rectangle.stack.fill.badge.plus")
                    
                } // Ende Button
                .font(.system(size: 30, weight: .medium))
                .foregroundColor(Color.white)
                .offset(x: 10)
                
                Text("|")
                    .offset(x:3, y: -7)
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
                .font(.system(size: 30, weight: .medium))
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
                            ) // Ende Alert
                    case .information:
                        return Alert(title: Text("Wichtige Information"), message: Text(errorMessageText), dismissButton: .default(Text("OK")))
                    } // Ende switch
                } // Ende alert
                
                Text("|")
                    .offset(x:3, y: -7)
                    .foregroundColor(Color.white)
            } // Ende HStack
            .frame(width: UIScreen.screenWidth - sideBarWidth, height: 34, alignment: .leading)
            .background(.gray)
            .foregroundColor(Color.black)
            .sheet(isPresented: $gegenstandHinzufuegen, content: { ShapeViewAddGegenstand(isPresented: $gegenstandHinzufuegen, isParameterBereich: $isParameterBereich) })
            
        } // Ende Vstack
        .background(globaleVariable.farbenEbene1)
        .cornerRadius(10)
        //.shadow(radius: 10)
        
    }// Ende var body
    
} // Ende struct

struct deteilTab3: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @Binding var sideBarWidth: CGFloat
    
    @State var isParameterBereich: Bool = false
    @State var personHinzufuegen: Bool = false
    @State var errorMessageText = ""
    
    @State var selectedPickerTmp: String = ""
    
    @State var selectedPicker: String?
    
    @State private var showAlert = false
    @State private var activeAlert: ActiveAlert = .error
    @State var showInfoText: Bool = false
    
    @State var selectedType: String? = ""
    
    var body: some View {
      
        let person = querySQLAbfrageClassPerson(queryTmp: "Select * from Personen", isObjectTabelle: false)
        
        
        VStack {
            Text("")
            Text("Favoritenliste").bold()
            
            List(person, id: \.personPicker, selection: $selectedType) { index in
                
                Text(index.personPicker)
                
            } // Ende List
            .cornerRadius(10)
            
            HStack(alignment: .bottom) {
                Button {
                    personHinzufuegen = true
                } label: {
                    Label("",systemImage: "person.fill.badge.plus")
                } // Ende Button/label
                .font(.system(size: 30, weight: .medium))
                .foregroundColor(Color.white)
                .offset(x: 10)
                
                Text("|")
                    .offset(x:3, y: -7)
                    .foregroundColor(Color.white)
                Button {
                    
                    selectedPickerTmp = "\(selectedPicker ?? "N/A")"
                    
                    //print("\(selectedPickerTmp ?? "N/A")")
                    
                    if selectedPickerTmp == "N/A" {
                        errorMessageText = "Bitte markieren Sie zuerst eine Person, die Sie löschen möchten. Das tun sie durch das Klicken auf die entsprechende Zeile. Danach betätigen Sie noch mal das Minuszeichen, um die markierte Person zu löschen ."
                        
                        showAlert = true
                        activeAlert = .error
                    }else{
                        
                        showAlert = true
                        activeAlert = .delete
                        
                        
                    }// Ende if/else
                } label: {
                    
                    Label("",systemImage: "person.fill.badge.minus")
                    
                } // Ende Button/label
                .font(.system(size: 30, weight: .medium))
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
                        ) // Ende Alert
                    case .information:
                        return Alert(
                            title: Text("Wichtige Information!"),
                            message: Text("Es befinden sich keine Personen in der Datenbank. Drücken Sie unten links auf das Männchen mit + Zeichen, um eine neue Person in diese Liste hinzufügen."), dismissButton: .default(Text("OK")))
                        
                    } // Ende switch
                } // Ende alert
                
                Text("|")
                    .offset(x:3, y: -7)
                    .foregroundColor(Color.white)
                
            } // Ende HStack
            .frame(width: UIScreen.screenWidth - sideBarWidth, height: 34, alignment: .leading)
            .background(.gray)
            .foregroundColor(Color.black)
            .sheet(isPresented: $personHinzufuegen, content: {ShapeViewAddUser(isPresented: $personHinzufuegen, isParameterBereich: $isParameterBereich)})
            
            
        } // Ende Vstack
        .background(globaleVariable.farbenEbene1)
        .cornerRadius(10)
        .onAppear() {
            if person.count == 0 {
                // Wenn sich keine Personen in der Datenbanktabelle befinden
                // wird eine Information gezeigt.
                showAlert = true
                activeAlert = .information
                
            } // Ende if
            // Wenn die Datenbank nicht leer ist:
            // wird der Wert zugewiesen damit in der Liste die erste Zeile markiert wird
            if person.count != 0 {
                selectedType = person[0].personPicker
            } // Ende if
        } // Ende onAppear
    
    }// Ende var body
    
} // Ende struct
