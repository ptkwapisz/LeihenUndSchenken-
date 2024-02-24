
//  GlobaleVariablen.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 27.03.23.
//


import Foundation
import SwiftUI

class GlobaleVariable: ObservableObject {
    static let shared = GlobaleVariable()
    
    //@Published var parameterVorgang: [String] =  ["Verleihen", "Verschenken", "Bekommen", "Aufbewahren", "Geschenkidee"]
    @Published var parameterGegenstand: [String] = querySQLAbfrageArray(queryTmp: "select gegenstandName FROM Gegenstaende")
    
    @Published var searchTextObjekte: String = ""
    @Published var searchTextAdressBook: String = ""
    
    @Published var abfrageFilter: Bool = false
    @Published var abfrageQueryString: String = ""
    
    @Published var parameterDatum: Date = Date()
    @Published var parameterImageString: String = "Kein Bild"
    
    @Published var personenParameter: [PersonClassVariable] = querySQLAbfrageClassPerson(queryTmp: "Select * From Personen", isObjectTabelle: false )
   
    //@Published var navigationTabView = 1
    
    @Published var refreshViews: Bool = false
    
    @Published var selectedGegenstand: String = "Neuer ..."
    @Published var selectedGegenstandInt: Int = 0
    @Published var textGegenstandbeschreibung: String = ""
    @Published var selectedVorgangInt: Int = 0
    @Published var selectedPersonInt: Int = 0
    
    @Published var preisWert: String = ""
    @Published var textAllgemeineNotizen: String = ""
    @Published var datum: Date = Date()
    
    @Published var preisOderWert: Bool = false
   
    @Published var columnVisibility = NavigationSplitViewVisibility.all
    
} // ende class

// Wird in der ObjektenListParameter struct aufgerufen
class SharedData: ObservableObject {
    static let shared = SharedData()
    
    @Published var titel: String = "Erste Zeile"
    @Published var unterTitel: String = "Zweite Zeile"
    @Published var didSave: Bool = false

}// Ende class

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
    
    @Published var iCloudSwitch: Bool {
        didSet {
            UserDefaults.standard.set(iCloudSwitch, forKey: "iCloudSwitch")
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
        self.iCloudSwitch = UserDefaults.standard.object(forKey: "iCloudSwitch") as? Bool ?? false
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

class HilfeTexte {
    
    // Aus dem Parameterbereich
    static var allgemeineAppInfo: String = "Das ‚Schenk und Leih‘ App (eigentlich‚ Verschenk und Verleih‘ App) ist für die einfache Verwaltung von verliehenen, verschenkten oder auch erhaltenen Gegenständen konzipiert. Mit dieser App können sie auch die Geschenkideen oder Dinge, die Sie aufbewahren erfassen. Diese App soll dabei helfen, mit Hilfe der Zuordnung zu festgelegten Personen, den Überblick über Ihre Gegenstände zu behalten. Informationen, wie: Gegenstandsbeschreibung, Gegenstandsbild, den Preis, das Datum können eingegeben und verwaltet werden. So hat man immer einen Überblick über alles, was man verliehen, verschenkt oder bekommen hat."
    
    static var eingabeMaske: String = "Die App beginnt mit der Eingabemaske, wo Sie z. B. verschenkte, verliehene oder erhaltene Gegenstände, wie Bücher, CDs, Werkzeuge oder Geld, erfassen können. Vier Standardgegenstände sind voreingestellt, aber Sie können auch eigene hinzufügen. Für zusätzliche Informationen nutzen Sie das Feld 'Gegenstandsbeschreibung', z.B. ISBN oder Genre bei Büchern. Fotos von Gegenständen lassen sich aus Ihrer iPhone-Mediathek ins Feld 'Gegenstandsbild' importieren. Geben Sie den ausgegebenen Betrag oder den verliehenen Geldbetrag im Feld 'Preis/Wert' ein. Im Feld 'Datum' vermerken Sie, wann Sie den Gegenstand verschenkt oder verliehen haben. Wählen Sie im Feld 'Was möchten Sie tun?' zwischen 'verschenken', 'verleihen' oder 'bekommen'. Geben Sie im Feld 'Person' ein, wer den Gegenstand erhalten hat. Im Feld 'Allgemeine Notizen' können Sie den Anlass oder die Situation beschreiben. Durch Abbrechen können Sie die Eingabemaske leeren und neu beginnen."
    
    static var tabObjektenListe: String = "In diesem Fenster sehen sie alle von Ihnen erfasten Objekte, gruppiert nach den Vorgängen, wie 'verlien', 'verschenkt', 'bekommen', 'aufbewahren' oder die 'Ideenliste'. Sie können jede Zeile anklicken, um in die Deteilsicht des Objektes zu gelangen. Um ein neues Objekt hinzufügen drücken Sie den Button mit dem Stappel (und dem + Zeichen) unten Links."
    
    static var tabGegenstandListe: String = "In diesem Fenster können Sie die Favoritenliste Ihrer Gegenstände verwalten. Sie können die Gegenstände löschen (das Icon mit dem Mühleimer) oder neue Gegenstände eingeben (das Icon mit dem Pluszeichen. Um ein Gegenstand zu bearbeiten markieren sie den gewünschten Gegenstand und wischen nach rechts. Diese Favoritenliste erscheint in der Eingabemaske, wenn Sie ein Gegenstand eingeben möchten. Die vier Standardgegenstände, das Buch, das Werkzeug, das Geld und die CD/DVD können nicht gelöscht und können nicht bearbeiten werden."
    
    static var tabPersonenListe: String = "In diesem Fenster können Sie die Favoritenliste der Personen verwalten. Sie können die Personen löschen (das Icon mit dem Mühleimer) oder neue Personen eingeben (das Icon mit dem Pluszeichen). Um eine Person zu bearbeiten markieren sie diese Person und wischen nach rechts. Diese Favoritenliste erscheint in der Eingabemaske, wenn Sie eine Person eingeben möchten."
    
    static var tabObjektPDFListe: String = "In diesem Fenster wird die Objektenliste gezeigt, die Sie auch von hier drucken können. Die Kopfzeilen können Sie anpassen indem Sie den Button mit dem Stift oben rechts anklicken."
    
    static var tabStatistiken: String = "In diesem Fenster werden die Anzahl allen Gegenstände und die Anzahl der Vorgänge angezeigt. Die zahlen sind ungefiltert, das heißt, dass Sie den gesamten Bestand also alle Objekte, die in dem Datenbank gespeichert sind, sehen."
    
    static var tabHandbuch: String = "Das Handbuch beinhaltet alle Hilfetexte von dieser App und zusätzliche Informationen. Mann kann es auf Ihrem Gerät lesen oder es auch ausdrucken."
    
} // Ende class

class AlertMessageTexte  {
    
    // Menuepunkt: "Parameter zurücksetzen" in DeteilView
    static var showSetupResetMessageText: String = "Durch das Zurücksetzen der Parameter werden alle Einstellungen auf die Standardwerte zurückgesetzt. Standardwerte sind: Farbe Ebene 0: blau, Farbe Ebene1: grün"
    
    static var showDBResetMessageText: String = "Durch das Zurücksetzen der Datenbank werden die Datenbank und alle Tabellen gelöscht. Dabei gehen alle gespeicherte Daten verloren. Dies kann nicht rückgängig gemacht werden! Dann werden die Datenbank und alle Tabellen neu erstellt."
    
    //@Published var showExportToCSVMessageText: String = "Alle Objekte aus der Datenbank werden in dem Format SCV in die Datei 'LeiheUndSchenkeDB.CSV' exportiert. Diese Datei überschreibt die letzte Exportversion falls vorhanden!"
    
    static var showDBSichernMessageText: String = "Die Datenbank inclusiwe aller Tabellen wird gesichert. Diese Sicherung überschreibt die letzte Sicherungsversion falls vorhanden!"
    
    static var showDBLadenMessageText: String = "Die Datenbank inklusiwe aller Tabellen wird zurückgeladen. Diese Rücksicherung überschreibt unwiederuflich die jetzige Datenbank und ihre alle Tabellen, wie Objekte, Personen und Gegenstände. Dieser Vorgang kann nicht rückgängig gemacht Werden."
    
    static var leereDbMessageTextiPhone: String = "Es befinden sich keine Objekte in der Datenbank. Drücken Sie unten links auf den Stappel mit + Zeichen, um ein neues Objekt zu erfassen und dann in die Datenbank zu speichern."
   
    static var leereDbMessageTextiPad: String = "Es befinden sich keine Objekte in der Datenbank. Bitte erfassen Sie ein neues Objekt in der Eingabemaske und speichern es in die Datenbank."
    
    static var alertTextForEingabemaske: String = ""
    
    init() {
        if UIDevice.current.userInterfaceIdiom == .phone {
            AlertMessageTexte.alertTextForEingabemaske = "Wenn Sie 'Abbrechen' drücken bleiben Sie bei der Eingabemaske. Wenn Sie 'Verlassen' drücken, werden alle Angaben, fall Sie welche gemacht haben gelöscht. Sie verlassen dann die Eingabemaske und kehren zurück zu der Objekentliste."
        } else {
            AlertMessageTexte.alertTextForEingabemaske = "Wenn Sie 'Abbrechen' drücken können Sie weiter Ihre Daten auf der Eingabemaske einfügen. Wenn Sie 'Löschen' drücken, werden alle Felder der Eingabemaske gelöscht und Sie können mit der Eingabe neu anfangen."
        } // Ende if/else
    } // Ende init
    
} // Ende class

/*
// This class will be used in Eingabemaske by Picker for Personen
class PersonPickerWithGender: Identifiable {
    var id = UUID()
    var picker: String
    var personSex: String
    var gender: String
    
    init(id: UUID = UUID(), picker: String, personSex: String, gender: String) {
        self.id = UUID()
        self.picker = picker
        self.personSex = personSex
        self.gender = gender
    } // Ende init
} // Ende class

*/

class Contact: Identifiable {
    var id = UUID()
    var firstName: String //= "No firstName"
    var lastName: String //= "No lastName"
    
    init(id: UUID = UUID(), firstName: String, lastName: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
    } // Ende init
    
} // Ende class

// Diese enum wird für Alertmeldung bei der Tab Gegenstand aufgerufen
enum ActiveAlert {
    case error, delete, information
} // Ende enum

// Diese enum wird für Alertmeldung bei der Tab Personne aufgerufen
enum ActiveAlertTab3 {
    case error, delete
} // Ende enum


// Diese enum wird für Alertmeldung bei der Tab1 (Objektenliste) aufgerufen, wenn db leer ist
// oder wenn bei löschen durch swip nach links
enum ActiveAlertTab1 {
    case leereDBinformationiPad, leereDBinformationiPhone, deleteObject
} // Ende enum


// Diese Class definiert globale Variable bei denen die Änderung des Wertes keinen Refresh/Redraw der Views verursacht
class GlobalStorage {
    
    static var widthFaktorEbene1: Double = 0.97
    //static var bottonToolBarHight: Double = tabViewBottomToolbarHight()
    static var selectedGegenstandTab2: String = ""
    static var selectedPersonPickerTab3: String = ""
    static var numberOfObjectsFree: Int = 10
    // Number of Objects that is fitered by abfrage
    static var numberOfObjectsFiltered: Int = 0
    
    // The Number of selected TabView
    static var navigationTabView: Int = 1
    
    static var farbEbene0: Color = loadColor0A()
    static var farbEbene1: Color = loadColor1B()
    
    static var heightFaktorEbene0: Double = 0.99
    static var heightFaktorEbene1: Double = 0.97
    
    static var numberOfObjects: Int = anzahlDerDatensaetze(tableName: "Objekte")
    
    static var parameterPersonSex: [String] =  ["Frau", "Mann", "Divers"]
    static var parameterVorgang: [String] =  ["Verleihen", "Verschenken", "Bekommen", "Aufbewahren", "Geschenkidee"]
    
   
} // Ende class
