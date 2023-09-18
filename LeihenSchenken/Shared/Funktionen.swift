//
//  Funktionen.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 27.03.23.
//


import Foundation
import SwiftUI
import SQLite3

// Das Löschen/Zurücksetzen der UserDefaults wird hier durch das Zuweisen der Standardswerte vollzogen.
func deleteUserDefaults() {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    //@ObservedObject var userSettingsDefaults = UserSettingsDefaults.shared
    let colorData = ColorData()
    
    //userSettingsDefaults.selectedSprache = 0
    globaleVariable.farbenEbene0 = Color.blue
    globaleVariable.farbenEbene1 = Color.green
    colorData.saveColor(color0: globaleVariable.farbenEbene0, color1: globaleVariable.farbenEbene1)
    refreshAllViews()
    
} // Ende func

// Diese Funktion ist notwändig, weil die UserDefaults bei Veränderung des Wertes
// die Views nicht nachzeichnen. Bei der Änderung der Werte der GlobalenVariablen werden
// die Views neu gezeichnet.
func refreshAllViews() {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    if globaleVariable.refreshViews == true {
        globaleVariable.refreshViews = false
    }else{
        globaleVariable.refreshViews = true
    } // Ende if/else
} // Ende func

// Diese Funktion erstellt aus Datum einen String mit Datum und Zeit mit Secunden im Format "20230427201567"
// Dieser einmaliger String wird als perKey in der SQLite DB Gespeichert.
func erstellePerKey(par1: String) -> String {
    
    let removeCharacters: Set<Character> = [" ", ",", ":"]
    var result = par1
    
    result.removeAll(where: { removeCharacters.contains($0) } )
    
    let nowDate = Date()
    let nowSeconds = (Calendar.current.component(.second, from: nowDate))
    result = result + String(nowSeconds)
    
return result
    
} // Ende func

// In dieser Funktion werden verdichtete Werte aus dem Array (distinct) erstellt
// Erster Parameter ist Array
// Zweiter Parameter ist String für die Verdichtung
func distingtArray(par1: [ObjectVariable], par2: String) -> [String]{
    
    var resultat: [String] = [""]
    
    switch par2 {
        
    case "Vorgang" :
        resultat = Array(Set(par1.compactMap { $0.vorgang }))
        
    case "Gegenstand" :
         resultat = Array(Set(par1.compactMap { $0.gegenstand }))
    
    default:
        print("Default")
    } // Ende Switch
    
    resultat.sort()
    
    return resultat
} // Ende func

 
func distingtArrayStatistiken(par1: [Statistiken], par2: String) -> [String]{
    
    var resultat: [String] = [""]
    
    switch par2 {
        
    case "stGruppe" :
        resultat = Array(Set(par1.compactMap { $0.stGruppe }))
        
    default:
        print("Default")
    } // Ende Switch
    
    return resultat
} // Ende func


// Das ist die funktion zum Bereinigen der Eingabemaske
func cleanEingabeMaske () {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    globaleVariable.parameterImageString = "Kein Bild"
    globaleVariable.selectedGegenstandInt = 0
    globaleVariable.selectedVorgangInt = 0
    globaleVariable.selectedPersonInt = 0
    globaleVariable.textGegenstandbeschreibung = ""
    globaleVariable.preisWert = ""
    globaleVariable.datum = Date()
    globaleVariable.textAllgemeineNotizen = ""
    globaleVariable.personenParameter.removeAll()
    globaleVariable.personenParameter = querySQLAbfrageClassPersonen(queryTmp: "Select * From Personen")
    
    
    print("Die Eingabe-Variablen wurden zurückgesetzt.")
    
} // Ende func

// Diese Funktion dekliniert das Verb für die Objektliste
func vorgangDeklination(vorgang: String)-> String {
    var resultat: String = ""
    
    switch vorgang {
            
        case "Verleihen":
            resultat = "verleiht"
        case "Verschenken":
            resultat = "verschenkt"
        case "Bekommen":
            resultat = "bekommen"
        case "Aufbewahren":
            resultat = "erhalten"
        case "Geschenkidee":
            resultat = "für"
        default:
            print(vorgang)
            print("Keine übereinstimmung")
            
    }// Ende switch
    
    return resultat
}// Ende func

// Diese Funktion dekliniert das Verb für die Objektliste
func vorgangPrefixDeklination(vorgang: String)-> String {
    var resultat: String = ""
    
    switch vorgang {
            
        case "Bekommen":
            resultat = "von"
        case "Erhalten":
            resultat = "von"
        case "Geschenkidee":
            resultat = "für"
        case "Verschenken":
            resultat = "an"
        case "Aufbewahren":
            resultat = "von"
        default:
            resultat = "an"
    }// Ende Switch
    
    return resultat
}// Ende func


// Diese Funktion speichert die Personendaten in die Datenbank in die Tabelle Personen
// par1 = Vorname
// par2 = Nachname
// par3 = Geschlecht
func personenDatenInDatenbankSchreiben(par1: String, par2: String, par3: String){
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    let perKeyFormatter: DateFormatter
    perKeyFormatter = DateFormatter()
    perKeyFormatter.dateFormat = "y MM dd, HH:mm"
    
    let perKey = erstellePerKey(par1: perKeyFormatter.string(from: globaleVariable.datum))
    let personPickerTemp: String = par2 + ", " + par1
    
    let insertDataToDatenbank = "INSERT INTO Personen(perKey, personPicker, personVorname, personNachname, personSex) VALUES('\(perKey)', '\(personPickerTemp)', '\(par1)', '\(par2)', '\(par3)')"

    if sqlite3_exec(db, insertDataToDatenbank, nil, nil, nil) !=
       SQLITE_OK {
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("error -->: \(errmsg)")
        print("Personendaten wurden nicht hinzugefügt")
    } // End if

    // globaleVariable.parameterPerson.removeAll()
    // globaleVariable.parameterPerson = personenArray()
    globaleVariable.personenParameter.removeAll()
    globaleVariable.personenParameter = querySQLAbfrageClassPersonen(queryTmp: "Select * From Personen")
    
    print("Personendaten wurden in die Tabelle gespeichert...")
    
} // Ende func

// Diese Funktion speichert die Personendaten in die Variable
// par1 = Vorname
// par2 = Nachname
// par3 = Geschlecht
func personenDatenInVariableSchreiben(par1: String, par2: String, par3: String){
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    globaleVariable.personenParameter.removeAll()
    
    globaleVariable.personenParameter.append(contentsOf: [PersonClassVariable(perKey: "0000000000000", personPicker: "Neue Person", personVorname: "Neue Person", personNachname: "Neue Person", personSex: "Mann")])
    let pickerTemp: String = par2 + ", " + par1
    globaleVariable.personenParameter.append(contentsOf: [PersonClassVariable(perKey: "0000000000001", personPicker: pickerTemp, personVorname: par1, personNachname: par2, personSex: par3)])
    
    print("Personendaten wurden in die Variable gespeichert...")
    
} // Ende func

// Diese Funktion speichert die Gegenstaende in die Datenbank in die Tabelle Gegenstaende
func gegenstaendenInDatenbankSchreiben(par1: String, par2: String) {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    let perKeyFormatter: DateFormatter
    perKeyFormatter = DateFormatter()
    perKeyFormatter.dateFormat = "y MM dd, HH:mm"
    
    let perKey = erstellePerKey(par1: perKeyFormatter.string(from: globaleVariable.datum))
    
    let insertDataToDatenbank = "INSERT INTO gegenstaende(perKey, gegenstandName) VALUES('\(perKey)','\(par1)')"

    if sqlite3_exec(db, insertDataToDatenbank, nil, nil, nil) !=
       SQLITE_OK {
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("error -->: \(errmsg)")
        print("Personendaten wurden nicht hinzugefügt")
    } // End if

    print("Personendaten wurden gespeichert...")
    
} // Ende func


// Wird benutzt in den Eingabemasken für iPad und iPhone
func dateToString(parDatum: Date) -> String {
    
    var resultat: String = ""
    let calendar = Calendar(identifier: .gregorian)
    let inputDateString = parDatum

    let germanDateFormatter = DateFormatter()
    germanDateFormatter.locale = .init(identifier: "de")
    germanDateFormatter.dateFormat = "d MMM yyyy"
    germanDateFormatter.dateStyle = .short
    //germanDateFormatter.dateFormat = "d MMM yyyy HH:mm:ss:Z"
    //germanDateFormatter.dateStyle = .medium
    //germanDateFormatter.timeStyle = .short
    germanDateFormatter.timeZone = calendar.timeZone
    
    resultat = germanDateFormatter.string(from: inputDateString)
        
    return resultat
} // Ende func


// Wird benutzt bei Alert bei zurückspieleung der Datnensicherung
func dateToStringWithTime(parDatum: Date) -> String {
    
    var resultat: String = ""
    let calendar = Calendar(identifier: .gregorian)
    let inputDateString = parDatum

    let germanDateFormatter = DateFormatter()
    germanDateFormatter.locale = .init(identifier: "de")
    germanDateFormatter.dateFormat = "d MMM yyyy HH:mm:ss:Z"
    germanDateFormatter.dateStyle = .medium
    germanDateFormatter.timeStyle = .short
    germanDateFormatter.timeZone = calendar.timeZone
    
    resultat = germanDateFormatter.string(from: inputDateString)
        
    return resultat
} // Ende func


// Wird benutzt bei editieren des Objekts-Datums
func stringToDate(parDatum: String) -> Date {
    let calendar = Calendar(identifier: .gregorian)
    var result: Date
    
    let inputDateString = parDatum
    
    let germanDateFormatter = DateFormatter()
    germanDateFormatter.locale = .init(identifier: "de")
    germanDateFormatter.dateFormat = "d MMM yyyy"
    germanDateFormatter.dateStyle = .short
    germanDateFormatter.timeZone = calendar.timeZone
    
    result = germanDateFormatter.date(from: inputDateString)!
    
    //print(result) //16.08.19, 07:04:12
    
    return result
} // Ende func


// Diese Funktion erstellt den Titel mit dem hinweis
// ob der Abfragefilter ein- oder ausgeschaltet ist.
func erstelleTitel(par: Bool) -> String {
    var resultat: String = ""
    
        if par == true {
            resultat = "Die Objekte sind gefiltert"
        }else{
            resultat = "Alle Objekte ungefiltert"
        } // Ende if/else
    
    return resultat
    
}// Ende func


// Wird aus der DetailView aufgerufen
func printingHandbuchFile(pdfPath: URL, pdfName: String) {
    
    if UIPrintInteractionController.canPrint(pdfPath) {
        
        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.jobName = "Drucke \(pdfName)!"
        printInfo.outputType = UIPrintInfo.OutputType.general
        printInfo.duplex = UIPrintInfo.Duplex.longEdge
        printInfo.accessibilityViewIsModal = true
        
        
        let printController = UIPrintInteractionController.shared
        printController.printInfo = printInfo
        printController.showsNumberOfCopies = true
        printController.printingItem = pdfPath
        printController.present(animated: true, completionHandler: nil)
        
    } // Ende if
    
    // https://nshipster.com/uiprintinteractioncontroller/
    
} // Ende func


// Zeilenfarbe der Objektliste im ersten Tab
func zeilenFarbe(par: Int) -> Color {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    var zeilenFarbe: Color
    if par % 2 == 0 {
        zeilenFarbe = globaleVariable.farbenEbene0
        
    }else{
        zeilenFarbe = globaleVariable.farbenEbene0.opacity(0.5)
        
    } // Ende if/else
   
    return zeilenFarbe
    
} // Ende func


func parameterCheck(parGegenstand: String, parPerson: String) -> Bool {
    var resultat: Bool = true
    if parGegenstand == "Neuer Gegenstand" || parPerson == "Neue Person" {
        resultat = true
        
    }else{
        resultat = false
        
    }// Ende if/else

    return resultat
} // Ende func


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

