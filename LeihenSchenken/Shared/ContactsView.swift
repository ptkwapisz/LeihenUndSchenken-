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
    
    var body: some View {
        
        let myContacts = serchInAdressBookArray(parameter: myContactsTmp)
        
        NavigationStack {
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
                .font(.system(size: 16, weight: .regular))
                
                if myContactsTmp.count > 0 {
                    Section(header: Text("Auswahl aus dem Adressbuch").font(.system(size: 15, weight: .medium)).bold()) {
                        
                        // The search Field for Contacts list
                        // The .if modyfier define the hieght between iPhone and iPad
                        SerchFullTextInAdressbook()
                        .if(UIDevice.current.userInterfaceIdiom == .phone) { view in
                            view.frame(height: 20)
                        } // Ende .if
                        
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
                                    )
                                    .onTapGesture {
                                        name = myContacts[idx].lastName
                                        vorname = myContacts[idx].firstName
                                        // Here we dismiss the kayboard by tap a name in the list
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                    } // Ende onTapGesture
                                    
                                } // Ende ForEach
                                
                            }// Ende LazyVStack - NavigationStack
                            .padding(5)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            
                        } // Ende Scrollview
                        .frame(height: 200, alignment: .leading)
                        
                    }// Ende Section
                    
                }else{
                    Section(header: Text("Auswahl aus dem Adressbuch").font(.system(size: 15, weight: .medium)).bold()) {
                        Text("Auswahl aus dem Adressbuch ist nicht möglich. Enweder gibt es im Adressbuch keine Einträge oder die Zugriffrechte auf das Adressbuch sind in den Einstellungen (das Zahnrad) eingeschränkt. ")
                            .font(.system(size: 16, weight: .regular))
                    }// Ende Section
                } // Ende if/else
  //--------------------------------------------------
                VStack{
                    HStack {
                        Spacer()
                        Button(action: {
                            isPresented = false
                            globaleVariable.searchTextAdressBook = ""
                        }) {Text("Abbrechen")}
                            .buttonStyle(.bordered).foregroundColor(.blue).font(.system(size: 16, weight: .regular))
                        
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
                                        //globaleVariable.parameterPerson.removeAll()
                                        //globaleVariable.parameterPerson = personenArray()
                                        globaleVariable.personenParameter.removeAll()
                                        globaleVariable.personenParameter = querySQLAbfrageClassPersonen(queryTmp: "Select * From Personen")
                                        
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
                }// Ende VStack
                
            } // Ende Form
            .navigationTitle("Neue Person").navigationBarTitleDisplayMode(.inline)
            //.scrollDisabled(true)
            
        } // Ende NavigationStack
        .onAppear{
            
            fetchAllContacts { fetchedContacts in
                    myContactsTmp = fetchedContacts
                } // Ende fetchAllContacts
            
        } // Ende onApear
        .interactiveDismissDisabled()  // Disable dismiss with a swipe
        
    } // Ende var body
    
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
            .frame(height: detailViewBottomToolbarHight() - 36)
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
