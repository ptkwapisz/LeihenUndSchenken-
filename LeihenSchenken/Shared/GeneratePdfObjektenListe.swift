//
//  GeneratePdfObjektenListe.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 26.12.23.
//

import SwiftUI
import PDFKit

func deletePdfList(){
    
    print("func deletPdfList wird aufgerufen")
    
    let fileManager = FileManager.default
    var objektenListeURL: URL
    
    let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
    objektenListeURL = documentsUrl!.appendingPathComponent("ObjektenListe.pdf")
    
    if fileManager.fileExists(atPath: objektenListeURL.path) {
        deleteFile(fileNameToDelete: "ObjektenListe.pdf")
        
    } // Ende if
    
} // Ende deletePdfList

func existPdfList()-> Bool {
    
    print("func deletPdfList wird aufgerufen")
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
    
} // Ende deletePdfList

struct PDFGeneratorTab: View {
    @StateObject private var progressTracker = ProgressTracker.shared
    @State private var isCreatingPDF = false
    @Binding var isPDFGenerated: Bool
    @Binding var showProgressView: Bool // Hinzugefügte Variable zur Steuerung der Anzeige der ProgressView
    
    var body: some View {
        VStack {
            if isCreatingPDF && showProgressView {
                ProgressViewModalLinear()
            } // Ende if
        } // Ende VStack
        .onAppear {
            startPDFCreation()
        } // Ende onAppear
    } // Ende var body
    

    func startPDFCreation() {
        if showProgressView {
            isCreatingPDF = true
            progressTracker.reset()
            
            let updateInterval = 0.5 // Sekunden
            let totalDuration = 2.0 // Gesamtdauer der Simulation
            let totalSteps = totalDuration / updateInterval
            var currentStep = 0.0
            
            Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { timer in
                currentStep += 1
                let currentProgress = Float(currentStep) / Float(totalSteps)
                self.progressTracker.updateProgress(currentProgress)
                
                if currentProgress >= 1.0 {
                    timer.invalidate()
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        self.generatePDF()
                    }
                }
            } // Ende Timer
        } else {
            isCreatingPDF = true
            // Wenn showProgressView false ist, starte die PDF-Erstellung direkt ohne Timer und Fortschrittsanzeige
            generatePDF()
        } // Ende if/else
    } // Ende func
    
    func generatePDF() {
    
        print("Funktion generatePDF() wird aufgerufen")
        let alleObjekte = querySQLAbfrageClassObjecte(queryTmp: "SELECT * FROM Objekte", abfrage: true)
        let objektWithFilter = serchObjectArray(parameter: alleObjekte)
        let objekte = sortiereObjekte(par1: objektWithFilter, par2: true)
        
        createPDF(from: objekte) { pdfFilePath in
            if let pdfFilePath = pdfFilePath {
                print("PDF wurde gespeichert in: \(pdfFilePath)")
            }
            DispatchQueue.main.async {
                self.isCreatingPDF = false // Verberge die ProgressView, wenn fertig
                self.isPDFGenerated = true // Aktualisiere den Zustand, um anzuzeigen, dass die PDF generiert wurde
            } // Ende DispatchQ
        } // Ende createPDF
    } // Ende func generatePDF
    
} // Ende struct

func createPDF(from objekte: [ObjectVariable], completion: @escaping (_ pdfFilePath: URL?) -> Void) {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @ObservedObject var sheredData = SharedData.shared
    
    let appName = "Leih&SchenkApp" // Setze hier den Namen deiner App ein
    
    let pdfMetaData = [
        kCGPDFContextCreator: appName,
        kCGPDFContextAuthor: "Piotr T. Kwapisz",
        kCGPDFContextTitle: "PDF-Liste"
    ]
    let format = UIGraphicsPDFRendererFormat()
    format.documentInfo = pdfMetaData as [String: Any]

    let pageWidth = 8.5 * 72.0
    let pageHeight = 11 * 72.0
    let margin: CGFloat = 20.0
    let lineHeight: CGFloat = 14.0
    let itemsPerPage = 45 // Maximal erlaubte Zeilen pro Seite und pro objekt.vorgang
    let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), format: format)
    
    let outputFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("ObjektenListe.pdf")

    do {
        try autoreleasepool {
            try renderer.writePDF(to: outputFileURL) { context in
                let groupedObjekte = Dictionary(grouping: objekte, by: { $0.vorgang })
                let pageCount = groupedObjekte.count
                
                var currentPage = 0
                for (vorgang, vorgangObjekte) in groupedObjekte {
                    currentPage += 1
                    context.beginPage()
                    
                    let title1 = sheredData.titel //"Erste Titelzeile"
                    let title2 = sheredData.unterTitel //"Zweite Titelzeile"
                    let titleFont = UIFont.boldSystemFont(ofSize: 18)
                    let titleAttributes: [NSAttributedString.Key: Any] = [.font: titleFont]
                    let title1Size = title1.size(withAttributes: titleAttributes)
                    let title2Size = title2.size(withAttributes: titleAttributes)
                    let titleYPosition = margin
                    title1.draw(at: CGPoint(x: (pageWidth - title1Size.width) / 2.0, y: titleYPosition), withAttributes: titleAttributes)
                    title2.draw(at: CGPoint(x: (pageWidth - title2Size.width) / 2.0, y: titleYPosition + titleFont.lineHeight), withAttributes: titleAttributes)
                    
                    let vorgangTitleFont = UIFont.boldSystemFont(ofSize: 16)
                    let vorgangTitleAttributes: [NSAttributedString.Key: Any] = [.font: vorgangTitleFont]
                    //let vorgangTitleSize = vorgang.size(withAttributes: vorgangTitleAttributes)
                    let vorgangYPosition = titleYPosition + 2 * titleFont.lineHeight + 2 * lineHeight // 2 Zeilen unter der zweiten Titelzeile
                    vorgang.draw(at: CGPoint(x: margin, y: vorgangYPosition), withAttributes: vorgangTitleAttributes)
                    
                    var currentLine = 0
                    for objekt in vorgangObjekte {
                        let euroZeichen = (objekt.preisWert.isEmpty) ? "": " €"
                        
                        var text1: String = ""
                        
                        if globaleVariable.preisOderWert == true {
                            text1 = "\(objekt.gegenstand), \(objekt.gegenstandText), \(objekt.preisWert)\(euroZeichen)"
                        }else{
                            text1 = "\(objekt.gegenstand), \(objekt.gegenstandText) "
                        } // Ende if/else
                        
                        let text2 = "\(objekt.vorgang), \(objekt.datum), \(objekt.personNachname), \(objekt.personVorname), \(objekt.allgemeinerText)"
                        
                        let textAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
                        let text1YPosition = vorgangYPosition + vorgangTitleFont.lineHeight + lineHeight * CGFloat(currentLine) + 20 // +20 für Abstand nach dem Titel
                        let text2YPosition = text1YPosition + lineHeight + 5 // zusätzlicher Abstand zwischen den Zeilen
                        
                        text1.draw(at: CGPoint(x: margin, y: text1YPosition), withAttributes: textAttributes)
                        text2.draw(at: CGPoint(x: margin, y: text2YPosition), withAttributes: textAttributes)
                        
                        currentLine += 2
                        
                        // Füge eine leere Zeile ein
                        let emptyLineYPosition = text2YPosition + 2 * lineHeight // verdopple die Höhe der leeren Zeile
                        let emptyLineRect = CGRect(x: margin, y: emptyLineYPosition, width: pageWidth - 2 * margin, height: 2 * lineHeight)
                        UIColor.white.setFill() // Ändere die Farbe für die leere Zeile
                        UIRectFill(emptyLineRect)
                        currentLine += 2
                        
                        if currentLine >= itemsPerPage {
                            context.beginPage()
                            currentLine = 0
                            title1.draw(at: CGPoint(x: (pageWidth - title1Size.width) / 2.0, y: titleYPosition), withAttributes: titleAttributes)
                            title2.draw(at: CGPoint(x: (pageWidth - title2Size.width) / 2.0, y: titleYPosition + titleFont.lineHeight), withAttributes: titleAttributes)
                            vorgang.draw(at: CGPoint(x: margin, y: vorgangYPosition), withAttributes: vorgangTitleAttributes)
                        }// Ende if
                    } // Ende for objekt
                    
                    let footerText = "Seite \(currentPage) von \(pageCount) - \(appName)"
                    let footerAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]
                    let footerSize = footerText.size(withAttributes: footerAttributes)
                    let footerYPosition = pageHeight - margin - footerSize.height
                    footerText.draw(at: CGPoint(x: (pageWidth - footerSize.width) / 2.0, y: footerYPosition), withAttributes: footerAttributes)
                } // Ende for
            } // Ende try
        } // Ende try
        completion(outputFileURL)
    } catch {
        print("Could not save PDF: \(error)")
        completion(nil)
    } // Ende do
} // Ende finc


/*

func createObjektenListe(parTitel: String, parUnterTitel: String) {
    print("Funktion createObjektenListe() wird aufgerufen!")
    
    
    
    // Setup your initial variables and data
    let titelString = parTitel.isEmpty ? "Das ist Header-Titel - First Line" : parTitel
    let unterTitelString = parUnterTitel.isEmpty ? "Das ist Header-Untertitel - Second Line" : parUnterTitel
    
    let alleObjekte = querySQLAbfrageClassObjecte(queryTmp: "SELECT * FROM Objekte", abfrage: true)
    let objektWithFilter = serchObjectArray(parameter: alleObjekte)
    let objekte = sortiereObjekte(par1: objektWithFilter, par2: true)
    let pageHeader = "\(titelString)\n\(unterTitelString)"
    
    deleteFile(fileNameToDelete: "ObjektenListe.pdf")
    
    generatePDF(pageHeader: pageHeader, objektenArray: objekte)
    
} // Ende func createObjektenListe

 
 
// Diese Funktion generiert eine PDF File from ObjektenListe
// Call fom func createObjektenListe
func generatePDF(pageHeader: String, objektenArray: [ObjectVariable]) {
    
    
    let _ = print("Funktion generatePDF() wird aufgerufen!")
    
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
        let pdfPath = docDir.appendingPathComponent("ObjektenListe.pdf")
        pdfData.write(to: pdfPath, atomically: true)
        print("PDF saved at path: \(pdfPath)")
        
    } // Ende if let
    
    
    
} // Ende func


// A custom class that subclasses UIPrintPageRenderer to handle the layout and rendering of content for printing.
class PrintPageRenderer: UIPrintPageRenderer {
    
    //@ObservedObject var progressTracker = ProgressTracker.shared
    
    // Array of PrintItem objects representing each printable item.
    //let items: [PrintItem]
    let items: [ObjectVariable]
    
    // Define the number of items that should be printed on each page.
    let itemsPerPage: Int = 6
    
    // Text to be displayed at the top of each page as a header.
    let headerText: String //= "Das ist Header Title First Line\nDas ist Header Untertitle Second Line"
    
    // Text to be displayed at the bottom of each page as a footer.
    let footerText: String = "Leih&Schenk App"
    
    // Initializer method that takes an array of PrintItem objects.
    init(items: [ObjectVariable], headerText: String) {
        // Set the items property.
        self.items = items
        self.headerText = headerText
        
        // Call the super class initializer.
        super.init()
        
        // Set the height for the header and footer spaces.
        self.headerHeight = 50.0
        self.footerHeight = 50.0
        
    } // Ende init
    
    // Calculate the total number of pages required to print all items.
    override var numberOfPages: Int {
        return (items.count + itemsPerPage - 1) / itemsPerPage
    } // Ende override func
    
    override func drawHeaderForPage(at pageIndex: Int, in headerRect: CGRect) {
        super.drawHeaderForPage(at: pageIndex, in: headerRect)
        
        // Text attributes for the header first Line.
        let headerAttributes0: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20),
            .foregroundColor: UIColor.darkGray
        ]
        // Text attributes for the header second Line.
        let headerAttributes1: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.darkGray
        ]
        
        // Split the header text into two separate lines.
        let headerLines = headerText.split(separator: "\n", maxSplits: 1)
        if headerLines.count == 2 {
            // Create attributed strings for each line.
            let attributedHeaderLine1 = NSAttributedString(string: String(headerLines[0]), attributes: headerAttributes0)
            let attributedHeaderLine2 = NSAttributedString(string: String(headerLines[1]), attributes: headerAttributes1)
            
            // Calculate the position for the first line and draw it.
            let size1 = attributedHeaderLine1.size()
            let x1 = (headerRect.width - size1.width) / 2.0
            let y1 = headerRect.minY + (headerRect.height - size1.height) / 4.0
            attributedHeaderLine1.draw(at: CGPoint(x: x1, y: y1))
            
            // Calculate the position for the second line and draw it.
            let size2 = attributedHeaderLine2.size()
            let x2 = (headerRect.width - size2.width) / 2.0
            let y2 = headerRect.minY + 4 * (headerRect.height - size2.height) / 4.0
            attributedHeaderLine2.draw(at: CGPoint(x: x2, y: y2))
        }else{
            // Only one Line of Text
            // Create an attributed string for the header text.
            let attributedHeaderText = NSAttributedString(string: headerText, attributes: headerAttributes0)
            
            // Calculate the position to center the header text in the provided rectangle.
            let size = attributedHeaderText.size()
            let x = (headerRect.width - size.width) / 2.0
            let y = headerRect.minY + (headerRect.height - size.height) / 2.0
            let point = CGPoint(x: x, y: y)
            // Draw the header text.
            attributedHeaderText.draw(at: point)
            
        } // Ende if/else
    } //ende override func
    
    // Method responsible for drawing the footer.
    override func drawFooterForPage(at pageIndex: Int, in footerRect: CGRect) {
        super.drawFooterForPage(at: pageIndex, in: footerRect)
        
        // Text attributes for the footer.
        let footerAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.lightGray
        ]
        
        // Create an attributed string for the footer text.
        let attributedFooterText = NSAttributedString(string: "\(footerText) - Page \(pageIndex + 1)", attributes: footerAttributes)
        
        // Calculate the position to center the footer text in the provided rectangle.
        let size = attributedFooterText.size()
        let x = (footerRect.width - size.width) / 2.0
        let y = footerRect.minY + (footerRect.height - size.height) / 2.0
        let point = CGPoint(x: x, y: y)
        
        // Draw the footer text.
        attributedFooterText.draw(at: point)
    } // Ende override func
    
    // Method responsible for drawing the content of each page.
    override func drawContentForPage(at pageIndex: Int, in printableRect: CGRect) {
        
        // Adjust the printableRect to avoid drawing over the header and footer areas.
        let adjustedPrintableRect = CGRect(x: printableRect.origin.x,
                                           y: printableRect.origin.y + headerHeight,
                                           width: printableRect.size.width,
                                           height: printableRect.size.height - (headerHeight + footerHeight))
        
        // Calculate the range of items to be drawn on the current page.
        let start = pageIndex * itemsPerPage
        let end = min(start + itemsPerPage, items.count)
        
        let itemsNumber = items.count
        
        // Iterate through the items and draw each one in its corresponding location.
        for i in start..<end {
            let item = items[i]
            
            // Calculate the rectangle for the current item.
            let yOffset = (i - start) * Int(adjustedPrintableRect.height) / itemsPerPage
            let itemRect = adjustedPrintableRect.offsetBy(dx: 0, dy: CGFloat(yOffset))
            
            // Draw the item in the calculated rectangle.
            drawItem(item, in: itemRect)
            
            // Aktualisiere den Fortschritt
            DispatchQueue.main.async {
                let currentProgress = Float(i + 1) / Float(itemsNumber)
                ProgressTracker.shared.updateProgress(currentProgress)
            
            } // Ende Dispatch
            
        } // Ende for i
        
    } // Ende override func
    
    // Method responsible for rendering a single PrintItem.
    private func drawItem(_ item: ObjectVariable, in rect: CGRect) {
        @ObservedObject var globaleVariable = GlobaleVariable.shared
        
        // Text attributes for the item textGegenstand.
        let textGegenstandAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12)
        ]
        
        // Draw the item textGegenstand.
        let textGegenstand = item.gegenstand as NSString
        textGegenstand.draw(in: rect.insetBy(dx: 25, dy: 10), withAttributes: textGegenstandAttributes)
        
        if globaleVariable.preisOderWert == true {
            
            let euroZeichen = (item.preisWert.isEmpty) ? "": " €"
            // Text attributes for the item PreisWert.
            let textPreisWertAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12)
                
            ]
            
            // Draw the item textPreisWert.
            let textPreisWert = item.preisWert + euroZeichen as NSString
            let textGegenstandSize = textGegenstand.size(withAttributes: textGegenstandAttributes)
            let textGegenstandWidth: CGFloat = textGegenstandSize.width
            textPreisWert.draw(in: rect.insetBy(dx: 25 + textGegenstandWidth + 5, dy: 10), withAttributes: textPreisWertAttributes)
        }
        
        // Draw the item's image.
        let imageRect = CGRect(x: rect.minX + 25, y: rect.minY + 40, width: 50, height: 50)
        if item.gegenstandBild == "Kein Bild" {
            
            let emptyGegenstandBild = createImageFromLabel(labelText: "Kein Bild")
            emptyGegenstandBild.draw(in: imageRect)
            
        }else{
            
            let base64String = item.gegenstandBild
            let gegenstandBild = UIImage(base64Str: base64String)
            gegenstandBild!.draw(in: imageRect)
            
        } // Ende if/else
        
        //-----------------
        // Text attributes for the item textGegenstandTitel.
        let textGegenstandTitelAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 8)
        ]
        
        // Draw the item textGegenstandTitel.
        let textGegenstandTitel = "Gegenstand Beschreibung" as NSString
        textGegenstandTitel.draw(in: rect.insetBy(dx: 85, dy: 38), withAttributes: textGegenstandTitelAttributes)
        //------------------
        
        // Draw the item's label of gegenstandText
        let labelRectgegenstandText = CGRect(x: rect.minX + 85, y: rect.minY + 50, width: 110, height: 40)
        if item.gegenstandText.isEmpty {
            
            let emptyImageGegenstandText = createImageFromLabel(labelText: "Kein Gegenstandstext.")
            emptyImageGegenstandText.draw(in: labelRectgegenstandText)
            
        }else{
            
            let imageGegenstandText = createImageFromLabel(labelText: "\(item.gegenstandText)")
            imageGegenstandText.draw(in: labelRectgegenstandText)
            
        } // Ende if/else
        
        //-----------------
        // Text attributes for the item textGegenstandTitel.
        let textAllgemeinTitelAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 8)
        ]
        
        // Draw the item textGegenstandTitel.
        let textAllgemeinTitel = "Allgemeine Beschreibung" as NSString
        textAllgemeinTitel.draw(in: rect.insetBy(dx: 205, dy: 38), withAttributes: textAllgemeinTitelAttributes)
        //------------------
        
        // Draw the item's label of allgemeinerText
        let labelRectallgemeinerText = CGRect(x: rect.minX + 205, y: rect.minY + 50, width: 110, height: 40)
        if item.allgemeinerText.isEmpty {
            
            let emptyImageGegenstandText = createImageFromLabel(labelText: "Kein allgemeiner Text.")
            emptyImageGegenstandText.draw(in: labelRectallgemeinerText)
            
        }else{
            
            let imageGegenstandText = createImageFromLabel(labelText: "\(item.allgemeinerText)")
            imageGegenstandText.draw(in: labelRectallgemeinerText)
            
        } // Ende if/else
        
    } // Ende func drawItem
    
} // Ende class

// This extention help to convert Image from base64String to UIImage
extension UIImage {
    convenience init?(base64Str: String) {
        guard let data = Data(base64Encoded: base64Str) else {
            return nil
        } // Ende guard
        self.init(data: data)
    } // Ende convenince
} // Ende extension

// This function ist used by generating of PDF Objects List
func createImageFromLabel(labelText: String) -> UIImage {
    //let _ = print("Funktion createImageFromLabel() wird aufgerufen!")
    
    var resultat: UIImage?
    var widthInt = 0
    
    if labelText == "Kein Bild" {
        widthInt = 50
    } else {
        widthInt = 110
    } // Ende if/else
    
    
    let labelTmp = UILabel(frame: CGRect(x: 0, y: 0, width: widthInt, height: 50))
    labelTmp.text = """
             \(labelText)
            """
    labelTmp.numberOfLines = 0
    labelTmp.preferredMaxLayoutWidth = 50
    labelTmp.font = labelTmp.font.withSize(8)
    labelTmp.backgroundColor = UIColor.gray
    labelTmp.textColor = UIColor.white
    
    resultat = createUIImage(from: labelTmp)
    
    return resultat!
} // Ende func createImage ..

// Convert UILabel to UIImage for printing
func createUIImage(from label: UILabel) -> UIImage? {
    //let _ = print("Funktion createUIImage() wird aufgerufen!")
    
    UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
    defer { UIGraphicsEndImageContext() }  // This ensures UIGraphicsEndImageContext() is always called at the end
    
    if let context = UIGraphicsGetCurrentContext() {
        label.layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    } // Ende if
    
    return nil
} // Ende func
*/
