//
//  PdfView.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 19.05.23.
//


import Foundation
import SwiftUI
import PDFKit

struct PDFKitRepresentedView: UIViewRepresentable {
    
    let url: URL
    
    // Introduce a state dependency, e.g., a version counter.
    // This should be incremented whenever the content of the PDF changes.
    
    var version: Int
    
    init(_ url: URL, version: Int) {
        self.url = url
        self.version = version
    } //Ende init
    
    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
        let _ = print("Function makeUIView() wird von Struct PDFKitRepresentedView aufgerufen!")
        
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
        let _ = print("Function updateUIView() wird von Struct PDFKitRepresentedView aufgerufen!")
        loadPDF(into: uiView)
    } // Ende func
    
    private func loadPDF(into pdfView: PDFView) {
        let _ = print("Function loadPDF() wird von Struct PDFKitRepresentedView aufgerufen!")
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
        let _ = print("Function fetchPDFData() wird von Struct PDFKitRepresentedView aufgerufen!")
        URLSession.shared.dataTask(with: self.url) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    completion(data)
                } // Ende DispatchQueue
            } else {
                print("Failed to fetch PDF data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            } // Ende if/else
        }.resume()
    } // Ende private func
} // Ende struct


struct PDFKitView: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @ObservedObject var data = SharedData.shared
    
    @State private var isSheetPresented: Bool = false
    
    @State var showEingabeMaske: Bool = false
    
    @State var versionCounter: Int = 0
    
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
                                            
                }else{
                    // Handbuch wird gezeigt
                    
                    PDFKitRepresentedView(url, version: 1)
                } // Ende if/else
                
                if tabNumber == 4 {
                    HStack(alignment: .bottom) {
                        
                        Button {isSheetPresented.toggle()
                            
                        } label: { Label("", systemImage: "pencil.and.outline")
                            
                        } // Ende Button
                        .font(.system(size: 30, weight: .medium))
                        .foregroundColor(Color.white)
                        .offset(x: 10)
                        
                        Text("|")
                            .offset(x:3, y: -7)
                            .foregroundColor(Color.white)
                        
                    } // Ende HStack
                    .frame(width: geometry.size.width, height: GlobalStorage.bottonToolBarHight, alignment: .leading)
                    .background(Color(UIColor.lightGray))
                    .foregroundColor(Color.black)
                    .sheet(isPresented: $isSheetPresented, content: { ObjektListeParameter(data: data, isPresented: $isSheetPresented)})
                    .onChange(of: data.didSave) {
                               // This will run every time "didSave" changes.
                               // You can place your logic here as a substitute to .onAppear().
                                versionCounter += 1
                        print("Das ist die Anzahl von onChange: \(versionCounter)")
                        let _: Bool = createObjektenListe(parTitel: data.titel, parUnterTitel: data.unterTitel)
                           }// Ende onChange
                    
                } // Ende if tabNummer
                
            } // Ende VStack
            .background(globaleVariable.farbenEbene1)
            .cornerRadius(10)
            .onAppear() {
                if tabNumber == 4 { // Objektenliste
                    versionCounter += 1
                    print("Das ist die Anzahl von onAppear in PDFKitView: \(versionCounter)")
                    let _: Bool = createObjektenListe(parTitel: data.titel, parUnterTitel: data.unterTitel)
                }
            } // Ende on Appear

        } // Ende GeometryReader
        
    } // Ende var body
    
} // Ende struct

// Diese Funktion generiert eine PDF File from ObjektenListe
// Call fom func createObjektListe

func generatePDF(pageHeader: String, objektenArray: [ObjectVariable]) {
    let _ = print("Function generatePDF() wird aufgerufen!")
    
    //@ObservedObject var globaleVariable = GlobaleVariable.shared
    
    // Create an instance of the PrintPageRenderer with the provided items and header.
    let renderer = PrintPageRenderer(items: objektenArray, headerText: pageHeader)
    
    // Create a mutable data object to store the PDF data.
    let pdfData = NSMutableData()
    
    // Define the bounds for the PDF based on a standard A4 size.
    let pdfBounds = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4 size in points
    
    // Start the PDF context.
    UIGraphicsBeginPDFContextToData(pdfData, pdfBounds, nil)
    
    // Render each page.
    for i in 0..<renderer.numberOfPages {
        UIGraphicsBeginPDFPage()
        
        // Invoke the methods to draw the header, footer, and content for each page.
        renderer.drawHeaderForPage(at: i, in: CGRect(x: 0, y: 0, width: pdfBounds.width, height: renderer.headerHeight))
        renderer.drawFooterForPage(at: i, in: CGRect(x: 0, y: pdfBounds.height - renderer.footerHeight, width: pdfBounds.width, height: renderer.footerHeight))
        renderer.drawContentForPage(at: i, in: pdfBounds.insetBy(dx: 0, dy: renderer.headerHeight))
    } // Ende for i
    
    // End the PDF context.
    UIGraphicsEndPDFContext()
    
    // Save the PDF data to the Document directory.
    if let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let pdfPath = docDir.appendingPathComponent("objektenListe.pdf")
        pdfData.write(to: pdfPath, atomically: true)
        print("PDF saved at path: \(pdfPath)")
        //globaleVariable.pdfFileVersion += 1
    } // Ende if let
} // Ende func



