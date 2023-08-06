//
//  PdfView.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 19.05.23.
//

import Foundation
import SwiftUI
import PDFKit


import PDFKit

struct PDFKitRepresentedView: UIViewRepresentable {
    let url: URL

    init(_ url: URL) {
        self.url = url
    } // Ende init

    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
        // Create a `PDFView` and set its `PDFDocument`.
        let pdfView = PDFView(frame: CGRect(x: 0, y: 0, width: UIScreen.screenWidth, height: UIScreen.screenHeight)) // frame ist wigtig um Fehler zu verhindern
        pdfView.document = PDFDocument(url: self.url)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            pdfView.displayDirection = .vertical
            pdfView.autoScales = true
            pdfView.minScaleFactor = 0.5 // 0.65 für iPhon  0.70 für iPhon Max
            pdfView.maxScaleFactor = 5.0
        }else{
            pdfView.maxScaleFactor = 0.8
            
        }
        return pdfView
    } // Ende func

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
        // Update the view.
    } // Ende func
} // Ende struct

struct PDFKitView: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    var url: URL
    var body: some View {
        
        
        PDFKitRepresentedView(url)
        
    } // Ende var body
} // Ende struct


