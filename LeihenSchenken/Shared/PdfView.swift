//
//  PdfView.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 19.05.23.
//


import Foundation
import SwiftUI
import PDFKit

struct PDFKitView: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @ObservedObject var data = SharedData.shared
   
    @State private var isSheetPresented: Bool = false
    @State var showEingabeMaske: Bool = false
    @State var versionCounter: Int = 0
    @State private var showProgress = false
    
    var url: URL
    var tabNumber: Int

    var body: some View {
        let _ = print("Struct PDFKitView wird aufgerufen!")
        
        let tempErgaenzung: String = erstelleTitel(par: globaleVariable.abfrageFilter)
        
        GeometryReader { geometry in
            VStack{
                Text("")
                Text("\(tempErgaenzung)").bold()
                
                if tabNumber == 4 {
                    // Objektenliste pdf wird gezeigt
                    
                    PDFKitRepresentedView(url, version: versionCounter)
                    // Sobald die PDF-Erstellung abgeschlossen ist, schließen Sie das Modal
                    
                                            
                }else{
                    // Handbuch wird gezeigt
                    
                    PDFKitRepresentedView(url, version: 1)
                } // Ende if/else
                
            } // Ende VStack
            .background(globaleVariable.farbenEbene1)
            .cornerRadius(10)
            .onChange(of: data.didSave) {
                // This will run every time "didSave" changes.
                // You can place your logic here as a substitute to .onAppear().
                versionCounter += 1
                print("Das ist die Anzahl von onChange: \(versionCounter)")
                let _: Bool = createObjektenListe(parTitel: data.titel, parUnterTitel: data.unterTitel)
            }// Ende onChange
            .onAppear() {
                
                if tabNumber == 4 { // Objektliste
                    versionCounter += 1
                    print("Das ist die Anzahl von onAppear in PDFKitView: \(versionCounter)")
                    
                    // Display the ProgressView
                    showProgress = true
                    
                    let _: Bool = createObjektenListe( parTitel: data.titel, parUnterTitel: data.unterTitel)
                    
                    // Schedule to hide the ProgressView after 2 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // Delay for at least 3 seconds
                        // Hide the ProgressView
                        showProgress = false
                        
                    } // Ende DispatchQueue
                    
                } // Ende if
                
            } // Ende on Appear
            .overlay(
                showProgress ? ProgressViewModal() : nil
            )
            
        } // Ende GeometryReader
        
    } // Ende var body
    
} // Ende struct


