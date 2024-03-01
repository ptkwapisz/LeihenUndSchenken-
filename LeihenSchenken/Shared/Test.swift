//
//  Test.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 20.05.23.
//

import SwiftUI
import Swift
import Foundation
import PDFKit

// Höhe des oberen Fulltext-Serch Feldes in der ersten Tab (Objekte)
func tabViewBottomToolbarHight() -> CGFloat {
    let _ = print("Funktion detailViewBottomToolbarHight() wird aufgerufen!")
    var resultat: CGFloat = 0.0
    
    if UIDevice.current.userInterfaceIdiom == .phone {
        resultat =  36.0
    }else{
        resultat =  50.0
    } // Ende if/else
    
    return resultat
    
}// Ende func


// Zweite Zeile bei der Liste der Objekte
func subStringOfTextField(parameter: String) -> String {
    //let _ = print("Funktion subStringOfTextField() wird aufgerufen!")
    var resultat: String = ""
    
    if UIDevice.current.userInterfaceIdiom == .phone {
        
       resultat = String(parameter.prefix(30))
        
    } else {
        
        resultat = String(parameter.prefix(50))
        
    } // Ende if/else
    
    return resultat
} // Ende func

// Das ist die View für den Full Search in den Objekten
// Aufgerufen in der Tab1 View
struct SerchFullTextInObjekten: View {

    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @FocusState var isInputSarchFullTextInObjektenActive: Bool
    
    var body: some View {
        let _ = print("Struct SerchFullTextInObjekten: wird aufgerufen!")
        TextField("", text: $globaleVariable.searchTextObjekte)
            .focused($isInputSarchFullTextInObjektenActive)
            .frame( height: tabViewBottomToolbarHight() - 36)
            .font(.system(size: 18, weight: .medium))
            .disableAutocorrection (true)
            .submitLabel(.done)
            .foregroundColor(.white)
            .padding()
            .background(Color.gray)
            .cornerRadius(10)
            .onTapGesture {
                isInputSarchFullTextInObjektenActive = true
                
            } // Ende onTapGesture
            .padding(.horizontal, 15)
            .padding(.vertical, 5)
            .overlay(
                Group{
                    HStack {
                        if globaleVariable.searchTextObjekte.isEmpty && isInputSarchFullTextInObjektenActive == false{
                            
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 20)
                        }else{
                            if !globaleVariable.searchTextObjekte.isEmpty {
                                Button(action: {
                                    globaleVariable.searchTextObjekte = ""
                                    //isInputSarchFullTextInObjektenActive = false
                                    
                                }) {
                                    
                                    Image(systemName: "multiply.circle.fill")
                                        .foregroundColor(.white)
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                                        .padding(.trailing, 20)
                                }// Button Image
                            }
                        } // Ende if/else
                    } // Ende HStack
                } // Ende Group
            )
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    if isInputSarchFullTextInObjektenActive {
                        HStack {
                            Text("")
                            Spacer()
                            Button("Abbrechen") {
                                self.globaleVariable.searchTextObjekte = ""
                                isInputSarchFullTextInObjektenActive = false
                                
                            } // Ende Button
                            .buttonStyle(.bordered).foregroundColor(.blue).font(.system(size: 16, weight: .regular))
                           
                        } // Ende HStack
                        .font(.system(size: 16, weight: .regular))
                    }// Ende if
                    
                } // Ende ToolbarItemGroup
            } // Ende toolbar
            
    } // Ende var body
    
} // Ende struct

// Filter für die Fulltextsuche der Objekte
// Diese func war notwändig weil if-Abfrage in der View nicht zuläsig ist.
// Diese Funktion wird in der Tab1 View aufgerufen
// Bei der Suche werden von der Variable "globaleVariable.searchTextObjekte" alle leerzeichen,
// die sich am Anfang oder am Ende befinden, gelöscht.
func serchObjectArray(parameter: [ObjectVariable]) -> [ObjectVariable]{
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    let _ = print("Funktion serchObjectArray() wird aufgerufen!")
    var resultat: [ObjectVariable] = []
    
    var temp: String = globaleVariable.searchTextObjekte
    temp = temp.trimmingCharacters(in: .whitespacesAndNewlines)
    
    if globaleVariable.searchTextObjekte.isEmpty {
        resultat = parameter
        
    }else{
        
        resultat = parameter.filter {
            $0.gegenstandText.localizedCaseInsensitiveContains(temp) ||
            $0.allgemeinerText.localizedCaseInsensitiveContains(temp) ||
            $0.datum.localizedCaseInsensitiveContains(temp) ||
            //$0.preisWert.localizedCaseInsensitiveContains(temp) ||
            $0.gegenstand.localizedCaseInsensitiveContains(temp) ||
            $0.personVorname.localizedCaseInsensitiveContains(temp) ||
            $0.personNachname.localizedCaseInsensitiveContains(temp)
            
        } // Ende par.filter
        
    } // Ende if/else
    
    return resultat
} // Ende func

// Funktion für die sortierung der Objekte nach Datum
// Par1: Objektvariable mit gefilterten objekten
// Per2: Logischer Operator true: aufsteigend, false: absteigend
func sortiereObjekte(par1: [ObjectVariable], par2: Bool ) -> [ObjectVariable] {
    //@ObservedObject var globaleVariable = GlobaleVariable.shared
    let _ = print("Funktion sortiereObjekte() wird aufgerufen!")
    var resultat: [ObjectVariable] = []
    
    let sortDateFormatter: DateFormatter
    
    sortDateFormatter = DateFormatter()
    sortDateFormatter.locale = .init(identifier: "de")
    sortDateFormatter.dateFormat = "d MMM yyyy"
    sortDateFormatter.dateStyle = .short
    
    if par2 == true {
        
        //resultat = par1.sorted {($0.vorgang, sortDateFormatter.date(from: $0.datum)!) < ($1.vorgang, sortDateFormatter.date(from: $1.datum)!)}
        
        resultat = par1.sorted {
            if $0.vorgang == $1.vorgang {
                return sortDateFormatter.date(from: $0.datum)! < sortDateFormatter.date(from: $1.datum)!
                
            } // Ende if
            return $0.vorgang < $1.vorgang
        } // Ende resultat
        
        //print("Sortiert True")
    }else{
        
        //resultat = par1.sorted {($0.vorgang, sortDateFormatter.date(from: $0.datum)!) > ($1.vorgang, sortDateFormatter.date(from: $1.datum)!)}
        
        resultat = par1.sorted {
            if $0.vorgang == $1.vorgang {
                return sortDateFormatter.date(from: $0.datum)! > sortDateFormatter.date(from: $1.datum)!
                
            }
            return $0.vorgang > $1.vorgang
        } // Ende resultat
        
        //print("Sortiert False")
    } // Ende if/else
    
    return resultat
} // Ende func

// ----------------------------------------- Pdfkit


/*
struct PDFViewWrapper: View {
    let url: URL
    
    var body: some View {
        PDFKitRepresentedView2(url: url)
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct PDFKitRepresentedView2: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        loadPDF(into: pdfView)
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        loadPDF(into: uiView)
    }
    
    private func loadPDF(into pdfView: PDFView) {
        if let document = PDFDocument(url: url) {
            pdfView.document = document
            pdfView.displayMode = .singlePageContinuous
            pdfView.autoScales = true
            pdfView.maxScaleFactor = 5.0
            print("PDF wurde geladen von Funktion loadPDF 'PDFKitRepresentedView'")
        } else {
            print("Fehler: PDF-Dokument konnte nicht geladen werden.")
        }
    }
}
*/

/*
func existPdfList()-> Bool {
    
    print("Funktion deletPdfList wird aufgerufen")
    var resultat: Bool
    
    let fileManager = FileManager.default
    var objektenListeURL: URL
    
    let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
    objektenListeURL = documentsUrl!.appendingPathComponent("ObjektenListe.pdf")
    
    if fileManager.fileExists(atPath: objektenListeURL.path) {
        resultat = true
    }else{
        resultat = false
    } // Ende if
    
    return resultat
    
} // Ende existPdfList
*/
