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
    
    var result: [String] = []

    switch field1 {
            
        case "Gegenstand":
            result = querySQLAbfrageArray(queryTmp: "SELECT DISTINCT Gegenstand FROM Objekte ORDER BY Gegenstand")
            //print("Gegenstand " + "\(selectedAbfrageFeld3)")
        case "Vorgang":
            result = ["Leihen", "Schenken"]
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
    
    resultat.append(Statistiken(stGruppe: z1s0, stName: z1s1, stWert: z1S2[0]))
    resultat.append(Statistiken(stGruppe: z2s0, stName: z2s1, stWert: z2S2[0]))
    resultat.append(Statistiken(stGruppe: z3s0, stName: z3s1, stWert: z3S2[0]))
    
    let tmp0 = querySQLAbfrageArray(queryTmp: "Select distinct(gegenstand) From Objekte")
    
    for n in 0...tmp0.count - 1 {
        
        let tmp1 = querySQLAbfrageArray(queryTmp: "Select count() gegenstand From Objekte Where gegenstand = '\(tmp0[n])'")
        
        if Int("\(tmp1[0])") != 0 {
            
            resultat.append(Statistiken(stGruppe: "Gegenstände", stName: "\(tmp0[n])", stWert: tmp1[0]))
            
        } // Ende if
        
    }// Ende for
    
    return resultat
} // Ende func



struct ShapeViewObjectEdit: View {
    //@Environment(\.presentationMode) var presentationMode
    @Binding var isPresented: Bool
    @Binding var alterWert: String
    
    
    
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @ObservedObject var userSettingsDefaults = UserSettingsDefaults.shared
    
    @State var showSettingsHilfe: Bool = false
    
    @State var colorData = ColorData()
    
    
    var body: some View {
        
        
        NavigationView {
            
            Form {
                
                Section(header: Text("Alter Wert")) {
                    Text("\(alterWert)")
                    
                }// Ende Section Farben
                
                Section(header: Text("Neuerer Wert")) {
                    
                    
                }// Ende Section Farben
                
                
                
                
            } // Ende Form
            .navigationBarItems(trailing: Button( action: {
            
                //presentationMode.wrappedValue.dismiss()
                isPresented = false
                
            }) {Image(systemName: "figure.walk.circle").imageScale(.large)} )
            .navigationBarItems(trailing: Button( action: {
                showSettingsHilfe = true
            }) {Image(systemName: "questionmark.circle.fill").imageScale(.large)} )
            .alert("Hilfe zu Objekt bearbeiten", isPresented: $showSettingsHilfe, actions: {
                Button(" - OK - ") {}
            }, message: { Text("Das ist die Beschreibung für den Bereich Objekt bearbeiten.") } // Ende message
            ) // Ende alert
            
            
        } // Ende NavigationView
    } // Ende var body
} // Ende struct ShapeViewSettings



struct EditFields: ViewModifier {
    func body(content: Content) -> some View {
        content
            .disableAutocorrection (true)
            .frame(width: 180, height: 30)
            //.border(.black)
            .font(.system(size: 16, weight: .regular))
            .background(Color.blue)
            .cornerRadius(5)
            .opacity(0.6)
            .textFieldStyle(.roundedBorder)
    } // Ende func
} // Ende struct


extension View {
    func modifierEditFields() -> some View {
        modifier(EditFields())
    }// Ende func
} // Ende extension
