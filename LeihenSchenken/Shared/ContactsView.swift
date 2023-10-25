//
//  ContactsView.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 16.07.23.
//

import SwiftUI
import Contacts
import Foundation

struct ShapeViewAddUser: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @Binding var isPresented: Bool
    @Binding var isParameterBereich: Bool
    
    @State var showHilfe: Bool = false
    @State var showWarnung: Bool = false
    
    @State var selectedPerson_sexInt: Int = 0
    @State var isPresentedShapeAccessContacts: Bool = false
    
    @State var vorname: String = ""
    @State var name: String = ""
    
    // Das laden der Kontakte erfolgt in .onAppear
    @State var myContactsTmp: [Contact] = []
    
    var myContacts: [Contact] {
        return serchInAdressBookArray(parameter: myContactsTmp)
    } // Ende var
    
    
    @FocusState private var focusedField: Field?
    
    private enum Field: Int, CaseIterable {
        case vornameFokus // Für Vorname
        case nameFokus // Für Nachname
        
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
            globaleVariable.searchTextAdressBook = ""
            print("Disappear in shapeViewAddUser wurde ausgeführt.")
        } // Ende onDisappear
        
    } // Ende Button Label
    } // Ende some View
    

    var body: some View {
        let _ = print("Struct ShapeViewAddUser wird aufgerufen!")
        
        GeometryReader { geometry in
            VStack {
                VStack {
                    Text("")
                    Text("Person eingeben").bold()
                    
                    List {
                        Section() {
                            
                            TextField("Vorname", text: $vorname)
                                .focused($focusedField, equals: .vornameFokus)
                                .padding(5)
                                .background(Color.gray.opacity(0.4))
                                .foregroundColor(.black.opacity(0.4))
                                .cornerRadius(5)
                                .submitLabel(.done)
                                .disableAutocorrection(true)
                            
                            TextField("Name", text: $name)
                                .focused($focusedField, equals: .nameFokus)
                                .padding(5)
                                .background(Color.gray.opacity(0.4))
                                .foregroundColor(.black.opacity(0.4))
                                .cornerRadius(5)
                                .submitLabel(.done)
                                .disableAutocorrection(true)
                            
                            Picker("Geschlecht:", selection: $selectedPerson_sexInt) {
                                
                                ForEach(0..<globaleVariable.parameterPersonSex.count, id: \.self) { index in
                                    Text("\(globaleVariable.parameterPersonSex[index])")
                                    
                                } // Ende ForEach
                            } // Ende Picker
                        } // Ende Section
                        .font(.system(size: 16, weight: .regular))
                        
                        contactsSection()
                        
                        HStack {
                            Spacer()
                            if UIDevice.current.userInterfaceIdiom == .pad {
                               
                                Button(action: {
                                    isPresented = false
                                    globaleVariable.searchTextAdressBook = ""
                                }) {Text("Abbrechen")}
                                    .buttonStyle(.bordered).foregroundColor(.blue).font(.system(size: 16, weight: .regular))
                            } // Ende if
                            
                            Button(action: {
                                if vorname != "" && name != "" {
                                    if isParameterBereich {
                                        
                                        personenDatenInVariableSchreiben(par1: vorname, par2: name, par3: globaleVariable.parameterPersonSex[selectedPerson_sexInt])
                                        // Es wird in der Eingabemaske bei Personen die neue Person ausgewählt
                                        globaleVariable.selectedPersonInt = globaleVariable.personenParameter.count-1
                                        globaleVariable.searchTextAdressBook = ""
                                        print("Person wird in die Auswahl hinzugefügt!")
                                        isPresented = false
                                    }else{
                                        
                                        if pruefenDieElementeDerDatenbank(parPerson: ["\(vorname)","\(name)","\(globaleVariable.parameterPersonSex[selectedPerson_sexInt])"], parGegenstand: "") {
                                            
                                            showWarnung = true
                                            
                                        }else{
                                            
                                            personenDatenInDatenbankSchreiben(par1: vorname, par2: name, par3: globaleVariable.parameterPersonSex[selectedPerson_sexInt])
                                            globaleVariable.personenParameter.removeAll()
                                            globaleVariable.personenParameter = querySQLAbfrageClassPerson(queryTmp: "Select * From Personen", isObjectTabelle: false )
                                            
                                            globaleVariable.searchTextAdressBook = ""
                                            print("Person wurde in die Datenbank hinzugefügt!")
                                            isPresented = false
                                            
                                        } // Ende if/else
                                        
                                    }// Ende if/else
                                    
                                } // Ende if/else
                                
                            }) {
                                
                                Text("Speichern")
                                
                            } // Ende Button
                            .disabled(vorname != "" && name != "" ? false : true)
                            .buttonStyle(.borderedProminent)
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .regular))
                            .cornerRadius(10)
                            Spacer()
                        } // Ende HStack
                        
                        .alert("Warnung zu neuer Person", isPresented: $showWarnung, actions: {
                            Button("OK") {}
                        }, message: { Text("Die Person: '\(vorname)' '\(name)' befindet sich schon in der Datenbank. In der Datenbank können keine Duplikate von Personen gespeichert werden!") } // Ende message
                        ) // Ende alert
                        
                        VStack{
                            if isParameterBereich {
                                
                                Text("Die Taste 'Speichern' wird aktiv, wenn der Vorname und der Nachname erfasst wurden. Beim 'Speichern' werden die Personendaten nur zur Auswahl in der Eingabemaske hinzugefügt. Sie werden nach beenden der App aus der Liste gelöscht. Möchten Sie eine Person dauerhaft zur Auswahl in der Eingabemaske speichern (favoriten Liste), gehen Sie bitte zum Tab 'Personen', dort auf '+' und geben die entsprechenden Persondaten ein.")
                                //.font(.system(size: 12, weight: .regular))
                                //.foregroundColor(.gray)
                            }else{
                                Text("Die Taste 'Speichern' wird aktiv, wenn der Vorname und der Nachname erfasst wurden. Beim  'Speichern' werden alle Daten in die Datenbank dauerhaft hinzugefügt.")
                                //.font(.system(size: 12, weight: .regular))
                                //.foregroundColor(.gray)
                                
                            } // Ende if/else
                        }// Ende Vstack
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.gray)
                        
                        //}// Ende VStack
                        
                    } // Ende List
                    
                    //.scrollDisabled(true)
                } // Ende VStack
                .frame(width: geometry.size.width,height: geometry.size.height * globaleVariable.heightFaktorEbene1, alignment: .center)
                .background(globaleVariable.farbenEbene1)
                .cornerRadius(10)
                
            } // Ende Vstack
            .frame(width: geometry.size.width,height: geometry.size.height * globaleVariable.heightFaktorEbene0, alignment: .center)
            .background(globaleVariable.farbenEbene0)
            .navigationTitle("Neue Person").navigationBarTitleDisplayMode(.large)
            
        } // Ende GeometryReader
        .navigationBarItems(leading: btnBack)
        .interactiveDismissDisabled()  // Disable dismiss with a swipe
        .onAppear{
            
            fetchAllContacts { fetchedContacts in
                myContactsTmp = fetchedContacts
            } // Ende fetchAllContacts
            
        } // Ende onApear
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                if focusedField == .vornameFokus {
                    HStack {
                        
                        Text("\(vorname.count)/15")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.gray)
                            .padding()
                        
                        Spacer()
                        
                        Button("Abbrechen") {
                            //neuePersonTmp[0].personVorname = ""
                            focusedField = nil
                            print("Abbrechen Button Vorname wurde gedrückt!")
                        } // Ende Button
                        
                    } // Ende HStack
                }else if focusedField == .nameFokus  {
                    HStack{
                        
                        Text("\(name.count)/25")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.gray)
                            .padding()
                        
                        Spacer()
                        
                        Button("Abbrechen") {
                            //neuePersonTmp[0].personNachname = ""
                            focusedField = nil
                            print("Abbrechen Button Nachname wurde gedrückt!")
                        } // Ende Button
                        
                    } // Ende HStack
                } // Ende if/else
                
            } // Ende ToolbarItemGroup
            
        } // Ende toolbar
        .font(.system(size: 16, weight: .regular))
        
    } // Ende var body
    
    private func contactsSection() -> some View {
        
        if myContactsTmp.count > 0 {
            return AnyView(
                Section(header: Text("Auswahl aus dem Adressbuch").font(.system(size: 15, weight: .medium)).bold()) {
                    
                    // The search Field for Contacts list
                    SerchFullTextInAdressbook()
                        .if(UIDevice.current.userInterfaceIdiom == .phone) { view in
                            view.frame(height: 20)
                        } // Ende if
                
                    ScrollView {
                        
                        LazyVStack {
                            
                            ForEach(myContacts.indices, id: \.self) { idx in
                                
                                HStack{
                                    
                                    if myContacts[idx].lastName != "" && myContacts[idx].firstName != "" {
                                        Text(myContacts[idx].lastName + ", " + myContacts[idx].firstName)
                                            .font(.system(size: 20, weight: .regular))
                                        
                                        Spacer() // Die Zeilen werden linksbündig
                                        
                                    } // Ende if
                                    
                                } // Ende HStack
                                .background(idx % 2 == 0
                                            ? Color(.systemGray).opacity(0.2)
                                            : Color(.white).opacity(0.2)
                                ) // Ende background
                                .onTapGesture {
                                    name = myContacts[idx].lastName
                                    vorname = myContacts[idx].firstName
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                } // Ende onTapGesture
                                
                            } // Ende ForEach
                            
                            
                        } // Ende LazyStack
                       
                        .padding(5)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        
                    } // Ende ScrollView
                    .frame(height: 150, alignment: .leading)
                    
                } // Ende Section
                   
                
            ) // Ende return AnyView
            
        } else {
            return AnyView(
                Section(header: Text("Auswahl aus dem Adressbuch").font(.system(size: 15, weight: .medium)).bold()) {
                    Text("Auswahl aus dem Adressbuch ist nicht möglich. Enweder gibt es im Adressbuch keine Einträge oder die Zugriffrechte auf das Adressbuch sind in den Einstellungen (das Zahnrad) eingeschränkt. ")
                        .font(.system(size: 16, weight: .regular))
                } // Ende Section
            ) // Ende return AnyView
        } // Ende if/else
    } // Ende private func
    
} // Ende struct







// Das ist die View für den Full Search in den Objekten
// Aufgerufen in der Tab1 View
struct SerchFullTextInAdressbook: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    @FocusState var isInputActive: Bool
    
    var body: some View {
        let _ = print("Struct SerchFullTextInAdressbook wird aufgerufen!")
        
        TextField("", text: $globaleVariable.searchTextAdressBook)
            .focused($isInputActive)
            .frame(height: GlobalStorage.bottonToolBarHight - 36)
            .font(.system(size: 18, weight: .medium))
            .disableAutocorrection (true)
            .submitLabel(.done)
            .foregroundColor(.white)
            .padding()
            .background(Color(.lightGray))
            .cornerRadius(10)
            .padding(.horizontal, 15)
            .padding(.vertical, 5)
            .overlay(
                Group{
                    HStack {
                        if globaleVariable.searchTextAdressBook.isEmpty && isInputActive == false {
                            
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 20)
                        }else{
                            if !globaleVariable.searchTextAdressBook.isEmpty {
                                
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.white)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                                    .padding(.trailing, 20)
                                    .onTapGesture {
                                        self.globaleVariable.searchTextAdressBook = ""
                                        self.isInputActive = false
                                        print("Button X gedrückt!")
                                    } // Ende onTapgesture
                                
                            } // Ende if
                        } // Ende if/else
                    }// Ende HStack
                }// Ende Group
            )// Ende .overlay
            .onTapGesture {
                
                isInputActive = true
                
            } // Ende onTapGesture
        
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    if isInputActive {
                        HStack {
                            Text("")
                            Spacer()
                            Button("Abbrechen") {
                                self.globaleVariable.searchTextAdressBook = ""
                                self.isInputActive = false
                                
                            } // Ende Button
                            .buttonStyle(.bordered).foregroundColor(.blue).font(.system(size: 16, weight: .regular))
                            
                        } // Ende HStack
                        .font(.system(size: 16, weight: .regular))
                    }// Ende if
                    
                } // Ende ToolbarItemGroup
            } // Ende toolbar
        
        
        
    } // Ende var body
    
} // Ende struct


// Filter für die Fulltextsuche im Adressbook
// Diese func war notwändig weil if abfrage in der View nicht zuläsig ist.
// Diese Funktion wird in dem ShapeViewAddUser aufgerufen
func serchInAdressBookArray(parameter:  [Contact]) ->  [Contact]{
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    let _ = print("Funktion serchInAdressBookArray() wird aufgerufen!")
    var resultat:  [Contact] = []
    
    if globaleVariable.searchTextAdressBook.isEmpty {
        resultat = parameter
    }else{
        resultat = parameter.filter {
            $0.firstName.localizedCaseInsensitiveContains(globaleVariable.searchTextAdressBook) ||
            $0.lastName.localizedCaseInsensitiveContains(globaleVariable.searchTextAdressBook)
            
        }// Ende par.filter
    }// Ende if/else
    
    return resultat
}// Ende func

func fetchAllContacts(completion: @escaping ([Contact]) -> Void) {
    DispatchQueue.global(qos: .background).async {
        var contacts = [Contact]()
        let store = CNContactStore()
        let keys: [CNKeyDescriptor] = [CNContactGivenNameKey, CNContactFamilyNameKey] as [CNKeyDescriptor]
        let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
        
        do {
            try store.enumerateContacts(with: fetchRequest) { contact, _ in
                if !contact.givenName.isEmpty || !contact.familyName.isEmpty {
                    contacts.append(Contact(firstName: contact.givenName, lastName: contact.familyName))
                } // Ende if
            } // Ende try
            
            let filteredContacts = contacts.filter {$0.firstName != "" && $0.lastName != ""}
            let sortedContacts = filteredContacts.sorted(by: { $0.lastName < $1.lastName })
            
            DispatchQueue.main.async {
                completion(sortedContacts)
            }
        } catch {
            print("Error fetching contacts: \(error)")
            DispatchQueue.main.async {
                completion([])
            }// Ende DispatchQueue
        } // Ende catch
    } // Ende DispatchQueue
}// Ende func
