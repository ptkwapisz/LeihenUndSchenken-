//
//  Test.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 20.05.23.
//
import SwiftUI
import Foundation

struct EmptyView: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    var breite: CGFloat = 370
    var hoehe: CGFloat = 320
    
    var body: some View {
        ZStack{
            VStack{
                Text("Info zu Tabellen").bold()
                    .font(.title2)
                    .frame(alignment: .center)
                
                Divider().background(Color.black)
                Text("")
                Text("Die Tabellen können nur dann angezeigt werden, wenn mindestens ein Gegenstand gespeichert wurde. Gehen Sie bitte zu Eingabemaske zurück und geben sie den ersten Gegenstand ein. Bitte vergessen Sie nicht dann Ihre Eingaben zu speichern. Danach können Sie die Tabellen sehen.")
                    .font(.system(size: 18))
                Spacer()
                
            } // Ende Vstack
            //.frame(width: breite, height: hoehe, alignment: .leading)
            .padding(EdgeInsets(top: 40, leading: 20, bottom: 30, trailing: 20))
            .frame(width: breite, height: hoehe, alignment: .leading)
            .background(Color.gray.gradient)
            .cornerRadius(10.0)
            .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 15.0)
        } // Ende ZStack
    } // Ende var body
    
} // Ende struct


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



// Diese Funktion wird in der struc ShapeViewAbfrage (ShapeView) aufgerufen, um den input field 3
// in Abhängigkeit von der Eingabe im field 1 zu erstellen.
// Diese funktion wird aus den Bereichen onAppear und onChange aufgerufen

func abfrageField3(field1: String)->[String] {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    var result: [String] = []

    switch field1 {
            
        case "Gegenstand":
            result = querySQLAbfrageArray(queryTmp: "SELECT DISTINCT Gegenstand FROM Objekte ORDER BY Gegenstand")
            //print("Gegenstand " + "\(selectedAbfrageFeld3)")
        case "Vorgang":
            result = globaleVariable.parameterVorgang
            //print("Vorgang " + "\(selectedAbfrageFeld3)")
        case "Name":
            result = querySQLAbfrageArray(queryTmp: "SELECT DISTINCT personNachname FROM Objekte ORDER BY personNachname")
            //print("Nachname " + "\(selectedAbfrageFeld3)")
        case "Vorname":
            result = querySQLAbfrageArray(queryTmp: "SELECT DISTINCT personVorname FROM Objekte ORDER BY personVorname")
            //print("Vorname " + "\(selectedAbfrageFeld3)")
        default:
            print("Keine Wahl")
    } // Ende switch

    return result
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
    
    resultat.append(Statistiken(stGruppe: z1s0, stName: z1s1, stWert: z1S2[0]))
    resultat.append(Statistiken(stGruppe: z2s0, stName: z2s1, stWert: z2S2[0]))
    resultat.append(Statistiken(stGruppe: z3s0, stName: z3s1, stWert: z3S2[0]))
    resultat.append(Statistiken(stGruppe: z4s0, stName: z4s1, stWert: z4S2[0]))
    
    let tmp0 = querySQLAbfrageArray(queryTmp: "Select distinct(gegenstand) From Objekte")
    
    for n in 0...tmp0.count - 1 {
        
        let tmp1 = querySQLAbfrageArray(queryTmp: "Select count() gegenstand From Objekte Where gegenstand = '\(tmp0[n])'")
        
        if Int("\(tmp1[0])") != 0 {
            
            resultat.append(Statistiken(stGruppe: "Gegenstände", stName: "\(tmp0[n])", stWert: tmp1[0]))
            
        } // Ende if
        
    }// Ende for
    
    return resultat
} // Ende func

