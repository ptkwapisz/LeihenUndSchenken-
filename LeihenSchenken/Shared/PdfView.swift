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
    @ObservedObject var sheredData = SharedData.shared
    @State private var versionCounter: Int = 0
    
    var url: URL
    var tabNumber: Int
    
    var body: some View {
        let _ = print("Struct PDFKitView wird aufgerufen!")
        
        GeometryReader { geometry in
            VStack{
                
                // PDF-Objektenliste wird gezeigt
                if tabNumber == 4 {
                    
                    let tempErgaenzung: String = erstelleTitel()
                    Text("")
                    Text("\(tempErgaenzung)").bold()
                    
                    PDFKitRepresentedView(url, versionCounter: versionCounter)
                    
                }else{
                    // Handbuch wird gezeigt
                    
                    PDFKitRepresentedView(url, versionCounter: 1)
                    //PDFKitRepresentedView(url)
                } // Ende if/else
                
            } // Ende VStack
            .background(globaleVariable.farbEbene1)
            .cornerRadius(10)
            .onChange(of: sheredData.didSave) {
                // This will run every time "didSave" changes.
                // You can place your logic here as a substitute to .onAppear().
                //sheredData.didSave.toggle()
                versionCounter += 1
                print("Das ist die Anzahl von onChange: \(versionCounter) aus PDFKitView")
                
            }// Ende onChange
            
            .onAppear() {
                if tabNumber == 4 { // Objektenliste
                    
                    versionCounter += 1
                    print("Das ist die Anzahl von versionCounter in onAppear in PDFKitView: \(versionCounter)")
                    
                } // Ende if
            }
        } // Ende GeometryReader
        
    } // Ende var body

} // Ende struct

struct PDFKitRepresentedView: UIViewRepresentable {
    //@ObservedObject var sheredData = SharedData.shared
    
    let url: URL
    
    // Introduce a state dependency, e.g., a version counter.
    // This should be incremented whenever the content of the PDF changes.
    // It is nessesery to show the Row1 and Row2 if they changed in the List
    
    var versionCounter: Int
    
    init(_ url: URL, versionCounter: Int) {
    //init(_ url: URL) {
        self.url = url
        self.versionCounter = versionCounter
    } //Ende init
    
    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
        let _ = print("Funktion makeUIView() wird von Struct PDFKitRepresentedView aufgerufen!")
        
        let pdfView = PDFView(frame: CGRect(x: 0, y: 0, width: UIScreen.screenWidth, height: UIScreen.screenHeight))
        loadPDF(into: pdfView)
        if UIDevice.current.userInterfaceIdiom == .phone {
            pdfView.displayDirection = .vertical
            pdfView.autoScales = true
            pdfView.minScaleFactor = 0.5
            pdfView.maxScaleFactor = 5.0
        } else {
            pdfView.maxScaleFactor = 0.8
        } // Ende if/else
        return pdfView
    } // Ende func
    
    func updateUIView(_ uiView: PDFView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
        let _ = print("Funktion updateUIView() wird von Struct PDFKitRepresentedView aufgerufen!")
        loadPDF(into: uiView)
    } // Ende func
    
    private func loadPDF(into pdfView: PDFView) {
        let _ = print("Funktion loadPDF() wird von Struct PDFKitRepresentedView aufgerufen!")
        fetchPDFData { data in
            if let data = data {
                pdfView.document = PDFDocument(data: data)
                if UIDevice.current.userInterfaceIdiom == .phone {
                    pdfView.displayDirection = .vertical
                    pdfView.autoScales = true
                    pdfView.minScaleFactor = 0.5
                    pdfView.maxScaleFactor = 5.0
                } else {
                    pdfView.maxScaleFactor = 0.8
                } // Ende if/else
                print("Pdf wurde geladen von Funktion loadPDF 'PDFKitRepresentedView'")
            } // Ende if let
        } // Ende fetchPDFData
    } // Ende private func
    
    private func fetchPDFData(completion: @escaping (Data?) -> Void) {
        let _ = print("Funktion fetchPDFData() wird von Struct PDFKitRepresentedView aufgerufen!")
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: url.path) {
           print("-----------------------------------Exist----------------------")
            URLSession.shared.dataTask(with: self.url) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        completion(data)
                    } // Ende DispatchQueue
                } else {
                    print("Failed to fetch PDF-Data: \(error?.localizedDescription ?? "Unknown error")")
                    completion(nil)
                } // Ende if/else
            }.resume()
            
        }else{
           print("-----------------------------------not Exist ------------------------")
            
            
        }// Ende if
        
    } // Ende private func
    
} // Ende struct


/*
struct PDFKitView: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @ObservedObject var sheredData = SharedData.shared
    @ObservedObject var progressTracker = ProgressTracker.shared
    
    @State private var isSheetPresented: Bool = false
    @State private var showEingabeMaske: Bool = false
    // VersionCounter bewirkt, dass die View neu gezeichnet wird
    // Das ist der Fall, wenn die Positionen der Liste hinzugefügt oder gelöscht werden
    @State private var versionCounter: Int = 0
    //@State private var showProgress = false
    
    var url: URL
    var tabNumber: Int
    
    var body: some View {
        let _ = print("Struct PDFKitView wird aufgerufen!")
        
        
        GeometryReader { geometry in
            VStack{
                // PDF-Objektenliste wird gezeigt
                if tabNumber == 4 {
                    
                    let tempErgaenzung: String = erstelleTitel(par: globaleVariable.abfrageFilter)
                    Text("")
                    Text("\(tempErgaenzung)").bold()
                    
                    PDFKitRepresentedView(url, versionCounter: versionCounter)
                    /*
                    .overlay(
                        
                            progressTracker.progress < 1.0 ? ProgressViewModalLinear() : nil
                        
                    ) // Ende overlay
                      */
                }else{
                    // Handbuch wird gezeigt
                    
                    PDFKitRepresentedView(url, versionCounter: 1)
                    //PDFKitRepresentedView(url)
                } // Ende if/else
                
            } // Ende VStack
            .background(GlobalStorage.farbEbene1)
            .cornerRadius(10)
            
            .onChange(of: sheredData.didSave) {
                // This will run every time "didSave" changes.
                // You can place your logic here as a substitute to .onAppear().
                //let _: Bool = createObjektenListe(parTitel: sheredData.titel, parUnterTitel: sheredData.unterTitel)
                sheredData.didSave.toggle()
                //versionCounter += 1
                //print("Das ist die Anzahl von onChange: \(versionCounter) aus PDFKitView")
                
            }// Ende onChange
            
            .onAppear() {
                
                if tabNumber == 4 { // Objektenliste

                    let _: Bool = createObjektenListe(parTitel: sheredData.titel, parUnterTitel: sheredData.unterTitel)
                    versionCounter += 1
                    print("Das ist die Anzahl von onAppear in PDFKitView: §§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§")
                  
                } // Ende if
              
            } // Ende on Appear
        
        } // Ende GeometryReader
        
    } // Ende var body
    
} // Ende struct
*/
