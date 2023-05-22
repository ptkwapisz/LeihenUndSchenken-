//
//  Test.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 20.05.23.
//
import SwiftUI
import Foundation


// Sachen zum abarbeite:

/*
- Abragen speichern
OK - Sprache für den PrintController
- Button aus dem PrintController entfernen
OK - Sprache bei dem DatePicker (Monat erscheint auf English)
- Centrieren der Buttons auf der Eingabemaske
*/



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
        }
    } // Ende var body
        
} // Ende struct


// Wird aus der DetailView aufgerufen
func printingFile() {
    
    let pdfPath = Bundle.main.url(forResource: "L&S Handbuch", withExtension: "pdf")
    
    if UIPrintInteractionController.canPrint(pdfPath!) {
        
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


func abfrage(par: String){
    
    print(par)
}
