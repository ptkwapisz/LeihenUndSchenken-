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
/*
struct PDFKitView: UIViewRepresentable {
    var url: URL
    
    func makeUIView(context:      UIViewRepresentableContext<PDFKitView>)
        -> PDFView {
            let pdfView = PDFView()
            pdfView.document = PDFDocument(url: self.url)
            pdfView.autoScales = true
            pdfView.displayDirection = .vertical
            pdfView.minScaleFactor = 0.65 // 0.65 für iPhon  0.70 für iPhon Max
            pdfView.maxScaleFactor = 5.0
    
            return pdfView
    }
    
    func updateUIView(_ uiView: PDFView,
      context: UIViewRepresentableContext<PDFKitView>) {
    }
}
*/

struct PDFKitRepresentedView: UIViewRepresentable {
    let url: URL

    init(_ url: URL) {
        self.url = url
    } // Ende init

    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
        // Create a `PDFView` and set its `PDFDocument`.
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: self.url)
 pdfView.autoScales = true
 pdfView.displayDirection = .vertical
 pdfView.minScaleFactor = 0.5 // 0.65 für iPhon  0.70 für iPhon Max
 pdfView.maxScaleFactor = 5.0
        return pdfView
    } // Ende func

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
        // Update the view.
    } // Ende func
} // Ende struct

struct PDFKitView: View {
    var url: URL
    var body: some View {
        PDFKitRepresentedView(url)
    }
}


