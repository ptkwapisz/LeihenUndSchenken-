//
//  GlobaleVariablen.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 27.03.23.
//

import Foundation
import SwiftUI

class GlobaleVariable: ObservableObject {
    static let shared = GlobaleVariable()
    
    @Published var parameterPersonSex: [String] =  ["Frau", "Mann", "Divers"]
    @Published var parameterVorgang: [String] =  ["Leihen", "Schänken"]
    @Published var parameterGegenstand: [String] =  ["Neuer Gegenstand", "Geld", "Buch", "CD/DVD", "Werkzeug"]
    @Published var parameterDatum: Date = Date()
    @Published var parameterImageString: String = ""
    
    @Published var parameterPerson: [String] = ["Neue Person", "Kwapisz, Piotr","Stehle, Angelika","Stehle, Elena","Kwapisz, Zofia","Hanisch, Witold"]
    
    @Published var navigationTabView = 1
    @Published var farbenEbene0: Color = loadColor0A()
    @Published var farbenEbene1: Color = loadColor1B()
    
    @Published var heightFaktorEbene0: Double = 0.99
    
    @Published var heightFaktorEbene1: Double = 0.97
    @Published var widthFaktorEbene1: Double = 0.97
    
    @Published var refreshViews: Bool = false
    
    @Published var selectedGegenstand = "Neuer Gegenstand"
    
    
} // ende class

class UserSettingsDefaults: ObservableObject {
    static let shared = UserSettingsDefaults()
    
    @Published var selectedSprache: Int {
        didSet {
            UserDefaults.standard.set(selectedSprache, forKey: "selectedSprache")
        } // Ende didSet
    } // Ende @Published
    
    init() {
        
        self.selectedSprache = UserDefaults.standard.object(forKey: "selectedSprache") as? Int ?? 0
        
    } // Ende init
} // Ende class

// Address Book Tutorial in Swift and iOS
// https://www.kodeco.com/1786-address-book-tutorial-in-swift-and-ios

class GegenstaendeVariable: Identifiable {
    //static let shared = UserSettingsDefaults()
    
    @Published var perKey: String
    @Published var gegenstand: String
    @Published var gegenstandText: String
    @Published var gegenstandBild: String
    @Published var preisWert: String
    @Published var datum: Date
    @Published var vorgang: String
    @Published var personSpitzname: String
    @Published var personVorname: String
    @Published var personNachname: String
    @Published var personSex: String
    @Published var allgemeinerText: String

    init(perKey: String, gegenstand: String, gegenstandTex: String, gegenstandBild: String, preisWert: String, datum: Date, vorgang: String, personSpitzname: String, personVorname: String, personNachname: String, personSex: String, allgemeinerText: String) {
        
        self.perKey = perKey
        self.gegenstand = gegenstand
        self.gegenstandText = gegenstandTex
        self.gegenstandBild = gegenstandBild
        self.preisWert = preisWert
        self.datum = datum
        self.vorgang = vorgang
        self.personSpitzname = personSpitzname
        self.personVorname = personVorname
        self.personNachname = personNachname
        self.personSex = personSex
        self.allgemeinerText = allgemeinerText
        
    } // Ende init

    
} // Ende class

class Person: Identifiable {
    @Published var perKey: String
    @Published var personSpitzname: String
    @Published var personVorname: String
    @Published var personNachname: String
    @Published var personsex: String
    
    init(perKey: String, personSpitzname: String, personenVorname: String, personenNachname: String, personenSex: String) {
        
        self.perKey = perKey
        self.personSpitzname = personSpitzname
        self.personVorname = personenVorname
        self.personNachname = personenNachname
        self.personsex = personenSex
        
    } // Ende init
    
} // Ende class
