//
//  TabViewsDeteil.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 20.07.23.
//

import SwiftUI

struct deteilTab1: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    //@ObservedObject var alertMessageTexte = AlertMessageTexte.shared
    
    @State var alertMessageTexte = AlertMessageTexte()
    @State var zeile: Int = 0
    @State var showEingabeMaske: Bool = false
    @State var showAlert = false
   
    @State var activeAlertTab1: ActiveAlertTab1 = .leereDBinformationiPhone
    @State var sortObjekte: Bool = true
    
    @State var objectPerKey: String = ""
    
    var body: some View {
        let _ = print("Struct deteilTab1 wird aufgerufen!")
        
        let tempErgaenzung: String = erstelleTitel(par: globaleVariable.abfrageFilter)
        
        let alleObjekte = querySQLAbfrageClassObjecte(queryTmp: "SELECT * FROM Objekte", abfrage: true)
        
        let objektWithFilter = serchObjectArray(parameter: alleObjekte)
        
        let objekte = sortiereObjekte(par1: objektWithFilter, par2: sortObjekte)
        
        let gegVorgang = distingtArray(par1: objekte, par2: "Vorgang") // Leihen, Schänken oder Bekommen
        
        let anzahl: Int = objekte.count
        
        GeometryReader{ geometry in
            VStack {
                Text("")
                HStack {
                    
                    Text("\(tempErgaenzung)").bold()  // arrow.up.arrow.down
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                    if anzahl > 1 {
                        Button() {
                            sortObjekte.toggle()
                            
                        } label: {  Label("", systemImage: "arrow.up.arrow.down")
                            
                        }// Ende Button/label
                        .buttonStyle(.bordered)
                        .font(.system(size: 16, weight: .medium))
                        //.background(Color.blue.opacity(5))
                        .background(globaleVariable.farbenEbene0.opacity(5))
                        .foregroundColor(Color.white)
                        .padding(.leading, 10)
                        .frame(width: 40)
                        .cornerRadius(10)
                        .padding(.trailing, 20)
                    }// Ende if
                }// Ende HStack
                
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
                                                if objekte[item].gegenstandText != "" {
                                                    Text("\(subStringOfTextField(parameter: objekte[item].gegenstandText))")
                                                        .font(.system(size: 16, weight: .medium))//.bold()
                                                    Text("...")
                                                    Spacer()
                                                } // ende if
                                            } // Ende HStack
                                            
                                            HStack {
                                                
                                                NavigationLink(destination: ChartView(par1: objekte, par2: item)
                                                    .applyModifier(UIDevice.current.userInterfaceIdiom == .pad){$0.navigationBarBackButtonHidden()}
                                                ) {
                                                    
                                                    let textPrefix = vorgangPrefixDeklination(vorgang:gegVorgang[idx] )
                                                    Text("\(textPrefix)")
                                                    
                                                    Text(truncateString(String(objekte[item].personVorname)))
                                                    
                                                    Text(truncateString(String(objekte[item].personNachname)))
                                                    
                                                    Spacer()
                                                    
                                                    Label{} icon: { Image(systemName: "photo.fill.on.rectangle.fill") .font(.system(size: 16, weight: .medium))
                                                    } // Ende Label
                                                    .frame(width:35, height: 25, alignment: .center)
                                                    .cornerRadius(10)
                                                    // Diese Zeile bewirkt, dass Label rechtsbündig kurz vor dem > erscheint
                                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                                    
                                                } // Ende NavigationLink
                                                
                                            } // Ende HStack
                                            //.background(zeilenFarbe(par: item)).foregroundColor(Color.white)
                                            .font(.system(size: 15, weight: .medium)).bold()
                                            
                                        } // Ende VStack
                                        .foregroundColor(Color.white)
                                        .listRowBackground(zeilenFarbe(par: item))
                                        .swipeActions (edge: .trailing) {
                                            Button{
                                                showAlert = true
                                                activeAlertTab1 = .deleteObject
                                                objectPerKey = objekte[item].perKey
                                            } label: {
                                                Label("Löschen", systemImage: "trash.fill")
                                            } // Ende Button Label
                                            
                                        } // Ende swipeAction
                                        .tint(.red)
                                        
                                    } // Ende if gegVorgang
                                    
                                } // Ende ForEach
                                .listRowSeparatorTint(.white)
                                
                            } // Ende Section
                        
                    } // Ende ForEach
                    
                } // Ende List
                .cornerRadius(10)
                Spacer()
                
                // Wenn es keine Objekte gibt wird auch keine Suchzeile angezeigt.
                if alleObjekte.count > 1 {
                    HStack(alignment: .bottom) {
                        
                        // Wenn es keine Objekte gibt wird auch keine Suchzeile angezeigt.
                        //if alleObjekte.count > 0 {
                     serchFullTextInObjekten()
                        //}// Ende if
                        
                    } // Ende HStack
                    .frame(width: geometry.size.width, height: GlobalStorage.bottonToolBarHight, alignment: .leading)
                    .background(Color(UIColor.lightGray))
                    .foregroundColor(Color.black)
                }// Ende if
            
            } // Ende VStack
            .background(globaleVariable.farbenEbene1)
            .cornerRadius(10)
            .onAppear() {
                print ("Run onApear from struct deteilTab1")
                
                performeAction(alleObjekte: alleObjekte)
                
            } // Ende onAppear
            .alert(isPresented: $showAlert) {
                switch activeAlertTab1 {
                        
                    case .leereDBinformationiPhone:
                        return Alert(
                            title: Text("Wichtige Information!"),
                            message: Text("\(AlertMessageTexte.leereDbMessageTextiPhone)"), dismissButton: .default(Text("OK")))
                    case .leereDBinformationiPad:
                        return Alert(
                            title: Text("Wichtige Information!"),
                            message: Text("\(AlertMessageTexte.leereDbMessageTextiPad)"), dismissButton: .default(Text("OK")))
                    case .deleteObject:
                        return Alert(
                            title: Text("Wichtige Information!"),
                            message: Text("Das Objekt wird unwiederuflich gelöscht! Man kann diesen Vorgang nicht rückgängich machen!"),
                            primaryButton: .destructive(Text("Löschen")){
                                
                                deleteItemsFromDatabase(tabelle: "Objekte", perKey: objectPerKey)
                                print("\(objectPerKey) wurde gelöscht: \(alleObjekte.count)")
                                
                                refreshAllViews()

                            },
                            secondaryButton: .cancel(Text("Abbrechen")){
                                
                                print("\(objectPerKey) wurde nicht gelöscht")
                            })
                } // Ende switch
            } // Ende alert
            
        } // Ende GeometryReader
        //.sheet(isPresented: $showEingabeMaske, content: { EingabeMaskePhoneAndPadView() })
        .applyModifier(UIDevice.current.userInterfaceIdiom == .phone) {
            $0.navigationDestination(isPresented: $showEingabeMaske, destination: { EingabeMaskePhoneAndPadView()
                
            })
        } // Ende applyModifier
    
    } // Ende var body
    
    func performeAction(alleObjekte: [ObjectVariable]) {
        
        if alleObjekte.count == 0  {
            // Wenn sich keine Objekte in der Datenbanktabelle befinden
            // wird eine Information gezeigt.
            showAlert = true
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                activeAlertTab1 = .leereDBinformationiPhone
            }else{
                activeAlertTab1 = .leereDBinformationiPad
            } // Ende if/else
            
        } // Ende if
        
        
    } // Ende func
    
    
} // Ende struct


struct deteilTab2: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    @FocusState var focused: Bool
    
    @State var selectedRow: String? = ""
    
    @State var editedName: String = ""
    @State var editedNewName: String = ""
    @State var showEditGegenstand: Bool = false
    @State var gegenstandPerKey: String = ""
    
    
    let gegenstaende = querySQLAbfrageClassGegenstaende(queryTmp: "Select * FROM Gegenstaende")
    
    var body: some View {
        
        GeometryReader { geometry in
            
                VStack {
                    Text("")
                    Text("Favoritenliste").bold()
                    
                    List(gegenstaende, id: \.gegenstandName, selection: $selectedRow) { index in
                        Text(index.gegenstandName)
                            .swipeActions (edge: .leading) {
                                if selectedRow == index.gegenstandName && index.gegenstandName != "Buch" && index.gegenstandName != "CD/DVD" && index.gegenstandName != "Geld" && index.gegenstandName != "Werkzeug"{
                                    Button{
                                        showEditGegenstand = true
                                        editedName = index.gegenstandName
                                        //editedNewName = index.gegenstandName
                                        gegenstandPerKey = index.perKey
                                    } label: {
                                        Label("Bearbeiten", systemImage: "pencil")
                                    } // Ende Button Label
                                } // Ende if
                            } // Ende swpeAction
                            .tint(.blue)
                    } // Ende List
                    .cornerRadius(10)
                    .onChange(of: selectedRow){
                        GlobalStorage.selectedGegenstandTab2 = selectedRow!
                    } // Ende onChange
                    
                    
                } // Ende Vstack
                .background(globaleVariable.farbenEbene1)
                .cornerRadius(10)
                .onAppear() {
                    // Wenn die Datenbank nicht leer ist:
                    // wird der Wert zugewiesen damit in der Liste die erste Zeile markiert wird
                    if gegenstaende.count != 0 {
                        selectedRow = gegenstaende[0].gegenstandName
                    } // Ende if
                } // Ende onAppear
            
        } // Ende GeometryReader
        .applyIf(UIDevice.current.userInterfaceIdiom == .phone,
                 apply: {$0.navigationDestination(isPresented: $showEditGegenstand, destination: { ShapeViewEditGegenstand(isPresented: $showEditGegenstand, gegenstandAlt: $editedName, gegenstandPerKey: $gegenstandPerKey  )
                .navigationBarBackButtonHidden()
                .navigationBarTitleDisplayMode(.inline)
        }) },
                 else: {
            
            $0.sheet(isPresented: $showEditGegenstand, content: { ShapeViewEditGegenstand(isPresented: $showEditGegenstand, gegenstandAlt: $editedName, gegenstandPerKey: $gegenstandPerKey )})
        } // Ende else
        ) // Ende applyIf
        
    } // Ende var body
    
} // Ende struct



struct deteilTab3: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared

    @State private var showAlert = false
    @State var showingEditPersonView: Bool = false
    @State var selectedType: String? = GlobalStorage.selectedPersonPickerTab3
    
    @State var personPickerTmp: String = "Nachname, Vorname"
    @State var tabelleDB: String = "Personen"
    @State var neuePersonTmp: [PersonClassVariable] = [PersonClassVariable(perKey: "", personPicker: "", personVorname: "", personNachname: "", personSex: "")]
    
    var body: some View {
      
        let person = querySQLAbfrageClassPerson(queryTmp: "Select * from Personen", isObjectTabelle: true)
       
        
        //NavigationStack {
            GeometryReader { geometry in
                
                VStack {
                    Text("")
                    Text("Favoritenliste").bold()
                    
                    List(person, id: \.personPicker, selection: $selectedType) { index in
                        HStack{
                            Text(index.personPicker)
                            Spacer()
                            genderSymbol(par: index.personSex)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                            
                        } // Ende HStack
                        .swipeActions (edge: .leading) {
                           // if ...
                                Button{
                                    neuePersonTmp[0].perKey = index.perKey
                                    neuePersonTmp[0].personVorname = index.personVorname
                                    neuePersonTmp[0].personNachname = index.personNachname
                                    neuePersonTmp[0].personSex = index.personSex
                                    showingEditPersonView = true
                                    
                                } label: {
                                    Label("Bearbeiten", systemImage: "pencil")
                                } // Ende Button Label
                           // } // Ende if
                        } // Ende swpeAction
                        .tint(.blue)
                        
                    } // Ende List
                    .cornerRadius(10)
                    .onChange(of: selectedType){
                        GlobalStorage.selectedPersonPickerTab3 = selectedType!
                        
                    } // Ende onChange
                    
                    
                } // Ende Vstack
                .background(globaleVariable.farbenEbene1)
                .cornerRadius(10)
                .onAppear() {
                    
                    performAction(person: person)
                    
                } // Ende onAppear
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Wichtige Information!"),
                        message: Text("Es befinden sich keine Personen in der Datenbank. Drücken Sie oben rechts auf das '+' Zeichen, um eine neue Person in die Favoritenliste hinzufügen."), dismissButton: .default(Text("OK")))
                    
                } // Ende alert
            } // Ende GeometryReader
            .applyIf(UIDevice.current.userInterfaceIdiom == .phone, apply: { $0.navigationDestination(isPresented: $showingEditPersonView, destination: { ShapeViewEditUser(isPresentedShapeViewEditUser: $showingEditPersonView, personPickerTmp: $personPickerTmp, neuePersonTmp: $neuePersonTmp, tabelleDB: $tabelleDB)
                    .navigationBarBackButtonHidden()
                    .navigationBarTitleDisplayMode(.large)
            })}, else: {$0.sheet(isPresented: $showingEditPersonView, content: { ShapeViewEditUser(isPresentedShapeViewEditUser: $showingEditPersonView, personPickerTmp: $personPickerTmp, neuePersonTmp: $neuePersonTmp, tabelleDB: $tabelleDB)})})
        
       // } // Ende NAvigationStack
    
    }// Ende var body
    
    func performAction(person: [PersonClassVariable]) {
        if person.count == 0 {
            // Wenn sich keine Personen in der Datenbanktabelle befinden
            // wird eine Information gezeigt.
            showAlert = true
            
        } else {// Ende if
            // Wenn die Datenbank nicht leer ist:
            // wird der Wert zugewiesen damit in der Liste die erste Zeile markiert wird
            
            selectedType = person[0].personPicker
        } // Ende if
        
    } // Ende func
    
    
} // Ende struct
