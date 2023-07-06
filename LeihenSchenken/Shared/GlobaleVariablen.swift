
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
    @Published var parameterVorgang: [String] =  ["Verleihen", "Verschenken", "Bekommen"]
    @Published var parameterGegenstand: [String] = querySQLAbfrageArray(queryTmp: "select gegenstandName FROM Gegenstaende")
    
    
    @Published var abfrageFilter: Bool = false
    @Published var abfrageQueryString: String = ""
    
    @Published var parameterDatum: Date = Date()
    @Published var parameterImageString: String = "Kein Bild"
    
    @Published var personenParameter: [PersonClassVariable] = querySQLAbfrageClassPersonen(queryTmp: "Select * From Personen")
   
    
    @Published var navigationTabView = 1
    @Published var farbenEbene0: Color = loadColor0A()
    @Published var farbenEbene1: Color = loadColor1B()
    
    @Published var heightFaktorEbene0: Double = 0.99
    
    @Published var heightFaktorEbene1: Double = 0.97
    @Published var widthFaktorEbene1: Double = 0.97
    
    @Published var refreshViews: Bool = false
    
    @Published var selectedGegenstand: String = "Neuer Gegenstand"
    @Published var selectedGegenstandInt: Int = 0
    @Published var textGegenstandbeschreibung: String = ""
    @Published var selectedVorgangInt: Int = 0
    @Published var selectedPersonInt: Int = 0
    
    @Published var preisWert: String = ""
    @Published var textAllgemeineNotizen: String = ""
    @Published var datum: Date = Date()
    
    
} // ende class

class UserSettingsDefaults: ObservableObject {
    static let shared = UserSettingsDefaults()
    
    @Published var selectedSprache: Int {
        didSet {
            UserDefaults.standard.set(selectedSprache, forKey: "selectedSprache")
        } // Ende didSet
    } // Ende @Published
    
    @Published var showHandbuch: Bool {
        didSet {
            UserDefaults.standard.set(showHandbuch, forKey: "showHandbuch")
        } // Ende didSet
    } // Ende @Published
    
    
    @Published var selectedFilterField1: String {
        didSet {
            UserDefaults.standard.set(selectedFilterField1, forKey: "selectedFilterField1")
        } // Ende didSet
    } // Ende @Published
    
    
    @Published var selectedFilterField2: String {
        didSet {
            UserDefaults.standard.set(selectedFilterField2, forKey: "selectedFilterField2")
        } // Ende didSet
    } // Ende @Published
    
    @Published var selectedFilterField3: String {
        didSet {
            UserDefaults.standard.set(selectedFilterField3, forKey: "selectedFilterField3")
        } // Ende didSet
    } // Ende @Published
    
    
    init() {
        
        self.selectedSprache = UserDefaults.standard.object(forKey: "selectedSprache") as? Int ?? 0
        self.showHandbuch = UserDefaults.standard.object(forKey: "showHandbuch") as? Bool ?? true
        self.selectedFilterField1 = UserDefaults.standard.object(forKey: "selectedFilterField1") as? String ?? "Gegenstand"
        self.selectedFilterField2 = UserDefaults.standard.object(forKey: "selectedFilterField2") as? String ?? "gleich"
        self.selectedFilterField3 = UserDefaults.standard.object(forKey: "selectedFilterField3") as? String ?? "Buch"
        
    } // Ende init
} // Ende class

class ObjectVariable: Identifiable {
    //static let shared = UserSettingsDefaults()
    
    @Published var perKey: String
    @Published var gegenstand: String
    @Published var gegenstandText: String
    @Published var gegenstandBild: String
    @Published var preisWert: String
    @Published var datum: String
    @Published var vorgang: String
    @Published var personVorname: String
    @Published var personNachname: String
    @Published var personSex: String
    @Published var allgemeinerText: String
    
    init(perKey: String, gegenstand: String, gegenstandTex: String, gegenstandBild: String, preisWert: String, datum: String, vorgang: String, personVorname: String, personNachname: String, personSex: String, allgemeinerText: String) {
        
        self.perKey = perKey
        self.gegenstand = gegenstand
        self.gegenstandText = gegenstandTex
        self.gegenstandBild = gegenstandBild
        self.preisWert = preisWert
        self.datum = datum
        self.vorgang = vorgang
        self.personVorname = personVorname
        self.personNachname = personNachname
        self.personSex = personSex
        self.allgemeinerText = allgemeinerText
        
    } // Ende init
    
} // Ende class


class GegenstandVariable: Identifiable {
    
    @Published var perKey: String
    @Published var gegenstandName: String
    
    init(perKey: String, gegenstandName: String) {
        
        self.perKey = perKey
        self.gegenstandName = gegenstandName
        
    } // Ende init
    
} // Ende class


class Statistiken: Identifiable {
    
    @Published var stGruppe: String
    @Published var stName: String
    @Published var stWert: String
    
    
    init(stGruppe: String, stName: String, stWert: String) {
        
        self.stGruppe = stGruppe
        self.stName = stName
        self.stWert = stWert
        
    } // Ende init
    
} // Ende class


class PersonClassVariable: Identifiable {
    
    @Published var perKey: String
    @Published var personPicker: String
    @Published var personVorname: String
    @Published var personNachname: String
    @Published var personSex: String
    
    init(perKey: String, personPicker: String, personVorname: String, personNachname: String, personSex: String) {
        
        self.perKey = perKey
        self.personPicker = personPicker
        self.personVorname = personVorname
        self.personNachname = personNachname
        self.personSex = personSex
        
    } // Ende init
    
} // Ende class

class HilfeTexte: ObservableObject  {
    static let shared = HilfeTexte()
    
    // Aus dem Parameterbereich
    @Published var allgemeineAppInfo: String = "Das ‚Schenk und Leih‘ App (eigentlich ‚Verschenk und Verleih‘ App) ist für die einfache Verwaltung von verliehenen, verschenkten oder auch erhaltenen Gegenstände konzipiert. Sie soll dabei helfen, mit Hilfe der Zuordnung zu festgelegten Personen, den Überblick über diese Gegenstände zu behalten. Informationen, wie: Gegenstandsbeschreibung, Gegenstandsbild, den Preis, das Datum können eingegeben und verwaltet werden. So hat man immer einen Überblick über alles, was man verliehen, verschenkt oder bekommen hat."
    
    @Published var eingabeMaske: String = "Die App beginnt mit der Eingabemaske, wo Sie verschenkte, verliehene oder erhaltene Gegenstände, wie Bücher, CDs, Werkzeuge oder Geld, erfassen können. Vier Standardgegenstände sind voreingestellt, aber Sie können auch eigene hinzufügen. Für zusätzliche Informationen nutzen Sie das Feld 'Gegenstandsbeschreibung', z.B. ISBN oder Genre bei Büchern. Fotos von Gegenständen lassen sich aus Ihrer iPhone-Mediathek ins Feld 'Gegenstandsbild' importieren. Geben Sie den ausgegebenen Betrag oder den verliehenen Geldbetrag im Feld 'Preis/Wert' ein. Im Feld 'Datum' vermerken Sie, wann Sie den Gegenstand verschenkt oder verliehen haben. Wählen Sie im Feld 'Was möchten Sie tun?' zwischen 'verschenken', 'verleihen' oder 'bekommen'. Geben Sie im Feld 'Person' ein, wer den Gegenstand erhalten hat. Im Feld 'Allgemeine Notizen' können Sie den Anlass oder die Situation beschreiben. Durch Abbrechen können Sie die Eingabemaske leeren und neu beginnen."
    
    @Published var tabObjektenListe: String = "In diesem Fenster sehen sie alle Ihre erfasten Objekte gruppiert nach den Vorgängen, wie 'verlien', 'verschenkt' oder 'bekommen'. Sie können jede Zeile anklicken, um in die Deteilsicht des Objektes zu gelangen. "
    
    @Published var tabGegenstandListe: String = "In diesem Fenster können Sie Ihre Gegenstande verwalten. Hier können Sie die Gegenstände löschen (das Icon mit dem Minuszeichen) oder neue Gegenstände eingeben (das Icon mit dem Pluszeichen. Diese Liste erscheint dann auch in der Eingabemaske, wenn Sie ein Gegenstand eingeben möchten. Die vier Standardgegenstände, wie Buch, Werkzeug, Geld ... können nicht gelöscht werden."
    
    @Published var tabPersonenListe: String = "In diesem Fenster können Sie die Personen verwalten, die Sie beschänken, an die Sie Sachen verleihen und von denen Sie Geschänke erhalten. Sie können die Personen löschen (das Icon mit dem Minuszeichen oder neue Personen eingeben (das Icon mit dem Pluszeichen). Diese Personenliste erscheint dann auch in der Eingabemaske, wenn Sie eine Person eingeben möchten."
    
    @Published var tabStatistiken: String = "In diesem Fenster werden die Anzahl alle Gegenstände und die Anzahl der Vorgänge angezeigt. Die zahlen sind ungefiltert, das heißt das sie den gesamten Bestand des Datenbankes zeigen."
    
    @Published var tabHandbuch: String = "Hilfe für das Handbuch"
    
} // Ende class
