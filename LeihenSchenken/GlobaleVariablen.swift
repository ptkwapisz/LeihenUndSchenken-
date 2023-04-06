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
    
    @Published var person_sex: [String] =  ["Frau", "Mann", "Divers"]
    @Published var art: [String] =  ["Leihen", "Schänken"]
    @Published var gegenstand: [String] =  ["Neuer Gegenstand", "Geld", "Buch", "CD/DVD", "Werkzeug"]
    
    @Published var person: [String] = ["Neue Person", "Kwapisz, Piotr","Stehle, Angelika","Stehle, Elena","Kwapisz, Zofia","Hanisch, Witold"]
    
    @Published var navigationTabView = 1
    @Published var farbenEbene0: Color = loadColor0A()
    @Published var farbenEbene1: Color = loadColor1B()
    
    @Published var heightFaktorEbene0: Double = 0.99
    
    @Published var heightFaktorEbene1: Double = 0.97
    @Published var widthFaktorEbene1: Double = 0.97
    
    @Published var refreshViews: Bool = false
    
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
