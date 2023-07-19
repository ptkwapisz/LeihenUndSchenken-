//
//  Funktionen.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 27.03.23.
//

import Foundation
import SwiftUI
import SQLite3

// Das Löschen/Zurücksetzen der UserDefaults wird hier durch zuweisen der Standardswerte vollzogen.
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
    //globaleVariable.selectedPersonVariable.removeAll()
    //globaleVariable.parameterPerson.removeAll()
    //globaleVariable.parameterPerson = personenArray()
    globaleVariable.personenParameter.removeAll()
    globaleVariable.personenParameter = querySQLAbfrageClassPersonen(queryTmp: "Select * From Personen")
    
    
    print("Die Eingabe-Variablen wurden zurückgesetzt.")
    
} // Ende func

func vorgangDeklination(vorgang: String)-> String {
    var resultat: String = ""
    
    switch vorgang {
            
        case "Verleihen":
            resultat = "verleiht"
        case "Verschenken":
            resultat = "verschenkt"
        case "Bekommen":
            resultat = "bekommen"
        default:
            print(vorgang)
            print("Keine übereinstimmung")
            
    }// Ende switch
    
    return resultat
}// Ende func

/*
// Aus der Datenbanktabelle Personen werden die Personendaten geladen, die bei Eingabemaske angezeigt werden.
// Dabei wird das Format "Name, Vorname" erstellt.
func personenArray() -> [String] {
    var resultat: [String] = [""]
    
    var tempPicker: [String]
    var tempNachUndVor: String
    
    tempPicker = querySQLAbfrageArray(queryTmp: "Select personPicker from Personen")
    
    if tempPicker.count > 0 {
        for n in 0...tempPicker.count - 1 {
            
            tempNachUndVor = tempPicker[n]
            
            resultat.append("\(tempNachUndVor)")
            
        } // Ende for n
    } // Ende if tempNachname
    
    resultat[0] = "Neue Person"
    
    return resultat.unique()
} // Ende func

*/


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

func dateToString(parDatum: Date) -> String {
    
    var result: String = ""
    
    let inputDateString = parDatum

    let germanDateFormatter = DateFormatter()
    germanDateFormatter.locale = .init(identifier: "de")
    germanDateFormatter.dateFormat = "d MMM yyyy"
    germanDateFormatter.dateStyle = .short
    germanDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

    //if inputDateString != nil {

        result = germanDateFormatter.string(from: inputDateString)

        print(result) //16.08.19, 07:04:12
    //}else{
        
      //  result = "Keine umwandlung"
    //} // Ende if/else
    
    return result
} // Ende func

func stringToDate(parDatum: String) -> Date {
    
    var result: Date
    
    let inputDateString = parDatum
    
    let germanDateFormatter = DateFormatter()
    germanDateFormatter.locale = .init(identifier: "de")
    germanDateFormatter.dateFormat = "d MMM yyyy"
    germanDateFormatter.dateStyle = .short
    germanDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    
    result = germanDateFormatter.date(from: inputDateString)!
    
    print(result) //16.08.19, 07:04:12
    
    return result
} // Ende func


func stringToDate2(parameter1: [ObjectVariable] , parameter2: Int) -> Date {
    
    var result: Date
    
    let inputDateString = parameter1[parameter2].datum
    
    let germanDateFormatter = DateFormatter()
    germanDateFormatter.locale = .init(identifier: "de")
    germanDateFormatter.dateFormat = "d MMM yyyy"
    germanDateFormatter.dateStyle = .short
    germanDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    
    result = germanDateFormatter.date(from: inputDateString)!
    
    print(result) //16.08.19, 07:04:12
    
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
func printingFile() {
    
    let pdfPath = Bundle.main.url(forResource: "L&S Handbuch", withExtension: "pdf")
    
    if UIPrintInteractionController.canPrint(pdfPath!) {
        
        //notificationCenter.addObserver(self, selector: #selector(self.downloadFile), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.jobName = "Drucke Handbuch!"
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


func ladeStatistiken() -> [Statistiken] {
    var resultat: [Statistiken] = [Statistiken(stGruppe: "", stName: "", stWert: "")]
    resultat.removeAll()
    
    let z1s0: String = "Objekte"
    let z1s1: String = "Alle Objekte:"
    let z1S2: [String]  = querySQLAbfrageArray(queryTmp: "Select count() From Objekte")
    
    
    
    let z2s0: String = "Objekte"
    let z2s1: String = "Verschenkte Objekte:"
    let z2S2: [String]  = querySQLAbfrageArray(queryTmp: "Select count() From Objekte Where vorgang = 'Verschenken'")
    
    let z3s0: String = "Objekte"
    let z3s1: String = "Verliehene Objekte:"
    let z3S2: [String]  = querySQLAbfrageArray(queryTmp: "Select count() From Objekte Where vorgang = 'Verleihen'")
    
    let z4s0: String = "Objekte"
    let z4s1: String = "Erhaltene Objekte:"
    let z4S2: [String]  = querySQLAbfrageArray(queryTmp: "Select count() From Objekte Where vorgang = 'Bekommen'")
    
    
    resultat.append(Statistiken(stGruppe: z1s0, stName: z1s1, stWert: z1S2.count == 0 ? "0" : z1S2[0]))
    resultat.append(Statistiken(stGruppe: z2s0, stName: z2s1, stWert: z2S2.count == 0 ? "0" : z2S2[0]))
    resultat.append(Statistiken(stGruppe: z3s0, stName: z3s1, stWert: z3S2.count == 0 ? "0" : z3S2[0]))
    resultat.append(Statistiken(stGruppe: z4s0, stName: z4s1, stWert: z4S2.count == 0 ? "0" : z4S2[0]))
    
    
    let tmp0 = querySQLAbfrageArray(queryTmp: "Select distinct(gegenstand) From Objekte")
    
    if tmp0.count != 0 {
        
        for n in 0...tmp0.count - 1 {
            
            let tmp1 = querySQLAbfrageArray(queryTmp: "Select count() gegenstand From Objekte Where gegenstand = '\(tmp0[n])'")
            
            if Int("\(tmp1[0])") != 0 {
                
                resultat.append(Statistiken(stGruppe: "Gegenstände", stName: "\(tmp0[n])", stWert: tmp1[0]))
                
            } // Ende if
            
        }// Ende for
        
    }else{
        
        // Wenn Tabelle Objekte leer ist:
        resultat.append(Statistiken(stGruppe: "Gegenstände", stName: "Anzahl der Gegenstände", stWert: "0"))
        
    } // Ende if/else
    
    return resultat
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
