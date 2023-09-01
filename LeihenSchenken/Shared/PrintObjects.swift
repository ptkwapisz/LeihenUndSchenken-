//
//  PrintObjects.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 29.08.23.
//

import SwiftUI
import Swift
import Foundation

struct ObjektListeParameter: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @ObservedObject var data = SharedData.shared
    @Binding var isPresented: Bool
        
    @FocusState var isInputActiveTitel: Bool
    @FocusState var isInputActiveUntertitel: Bool
    
    var body: some View {
       
        NavigationView {
            Form {
                Section(header: Text("Kopfzeilen der Liste").foregroundColor(.gray).font(.system(size: 16, weight: .regular))) {
                 
                    TextField("Listentitel", text: $data.titel)
                        .focused($isInputActiveTitel)
                        .padding(5)
                        .background(Color(.systemGray6))
                        .cornerRadius(5)
                        /*
                        .submitLabel(.done)
                        .disableAutocorrection(true)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                HStack {
                                    Spacer()
                                    Button("Abbrechen") {
                                        isInputActiveTitel = false
                                        titelTmp = ""
                                    } // Ende Button
                                } // Ende HStack
                                
                            } // Ende ToolbarItemGroup
                        } // Ende Toolbar
                    */
                    TextField("Listenuntertitel", text: $data.unterTitel)
                        .focused($isInputActiveUntertitel)
                        .padding(5)
                        .background(Color(.systemGray6))
                        .cornerRadius(5)
                      /*
                        .submitLabel(.done)
                        .disableAutocorrection(true)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                HStack {
                                    Spacer()
                                    Button("Abbrechen") {
                                        isInputActiveUntertitel = false
                                        unterTitelTmp = ""
                                    } // Ende Button
                                } // Ende HStack
                                
                            } // Ende ToolbarItemGroup
                        } // Ende Toolbar
                    */
                }// Ende Section
                .font(.system(size: 16, weight: .regular))
                Section {
                    Toggle("Das Feld Preis/Wert:", isOn: $globaleVariable.preisOderWert ).toggleStyle(SwitchToggleStyle(tint: .blue))
                } footer: {
                        
                        Text("Beim Einschalten wird das Feld Preis/Wert falls vorhanden, neben dem Gegenstand auf der Liste mitangezeigt.")
                        
                } // Ende Section
                .font(.system(size: 16, weight: .regular))
                
                VStack{
                    Spacer()
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            // Es wurden keine Angaben gemacht
                            
                            isPresented.toggle()
                            
                        }) {Text("Abbrechen")}
                            .buttonStyle(.bordered).foregroundColor(.blue).font(.system(size: 16, weight: .regular))
                        
                        Button(action: {
                            
                            print("Titel und Untertitel wurden übernohmen!")
                        
                            data.save()
                            
                            isPresented.toggle()
                            
                        }) {Text("Daten übernehmen")}
                            .buttonStyle(.borderedProminent)
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .regular))
                            .cornerRadius(10)
                        Spacer()
                    } // Ende HStack
                    
                } // Ende VStack
            } // Ende Form
            .navigationTitle("Parameter für die Objektenliste.").navigationBarTitleDisplayMode(.inline)
            
        } // Ende NavigationView
        .interactiveDismissDisabled()  // Disable dismiss with a swipe
        
    } // Ende var body
    
} // Ende func


// This function start the printing prozess
// Start from Sheet ObjektListeParameter
func printItems(pageHeader: String, objektenArray: [ObjectVariable]) {
    
    
    let items: [ObjectVariable] = objektenArray
    
    let printController = UIPrintInteractionController.shared
    let printInfo = UIPrintInfo(dictionary: nil)
    
    printInfo.outputType = .general
    printInfo.jobName = "My Print Job"
    
    printController.printInfo = printInfo
    
    
    printController.printPageRenderer = PrintPageRenderer(items: items, headerText: pageHeader)
    
    printController.present(animated: true, completionHandler: nil)
     
} // Ende func printItems

class PrintItem: Identifiable {
    
    @Published var gegenstand: String
    @Published var gegenstandText: UIImage
    @Published var gegenstandBild: UIImage
    
    init(gegenstand: String, gegenstandText: UIImage, gegenstandBild: UIImage) {
        self.gegenstand = gegenstand
        self.gegenstandText = gegenstandText
        self.gegenstandBild = gegenstandBild
    } // Ende init
} // Ende class

// A custom class that subclasses UIPrintPageRenderer to handle the layout and rendering of content for printing.
class PrintPageRenderer: UIPrintPageRenderer {
    
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
        
        // Dieser formatter verursachte fehler.
        // Create and add a print formatter to the renderer. This is a workaround to ensure headers and footers are drawn.
        //let formatter = UISimpleTextPrintFormatter(text: " ")
        //let formatter = UIMarkupTextPrintFormatter(markupText: " ")
        //self.addPrintFormatter(formatter, startingAtPageAt: 0)
        
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
        
        // Iterate through the items and draw each one in its corresponding location.
        for i in start..<end {
            let item = items[i]
            
            // Calculate the rectangle for the current item.
            let yOffset = (i - start) * Int(adjustedPrintableRect.height) / itemsPerPage
            let itemRect = adjustedPrintableRect.offsetBy(dx: 0, dy: CGFloat(yOffset))
            
            // Draw the item in the calculated rectangle.
            drawItem(item, in: itemRect)
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
        
        // Draw the item's label of gegenstandText
        let labelRectgegenstandText = CGRect(x: rect.minX + 85, y: rect.minY + 40, width: 110, height: 50)
        if item.gegenstandText.isEmpty {
            
            let emptyImageGegenstandText = createImageFromLabel(labelText: "Kein Gegenstandstext.")
            emptyImageGegenstandText.draw(in: labelRectgegenstandText)
            
        }else{
            
            let imageGegenstandText = createImageFromLabel(labelText: "\(item.gegenstandText)")
            imageGegenstandText.draw(in: labelRectgegenstandText)
            
        } // Ende if/else
        
        // Draw the item's label of allgemeinerText
        let labelRectallgemeinerText = CGRect(x: rect.minX + 205, y: rect.minY + 40, width: 110, height: 50)
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

/*
// This function was used by direct printing
func createImageFromLabel(labelText: String) -> UIImage {
    var resultat: UIImage?
    var widthInt = 0
    
    if labelText == "Kein Bild" {
        widthInt = 50
    }else{
        widthInt = 110
    } // Ende if/else
    DispatchQueue.main.sync {
        let labelTmp = UILabel(frame: CGRect(x: 0, y: 0, width: widthInt, height: 50))
        labelTmp.text = """
             \(labelText)
            """
        labelTmp.numberOfLines = 0
        labelTmp.preferredMaxLayoutWidth = 50
        labelTmp.font = labelTmp.font.withSize(8)
        labelTmp.backgroundColor = UIColor.gray
        labelTmp.textColor = UIColor.white
        
        resultat = createUIImage(from: labelTmp)!
    } // Ende DispatchQueue
    
    return resultat!
    
} // Ende func
*/

// This function ist used by generating of PDF Objects List
func createImageFromLabel(labelText: String) -> UIImage {
    var resultat: UIImage?
    var widthInt = 0
    
    if labelText == "Kein Bild" {
        widthInt = 50
    } else {
        widthInt = 110
    }

    // Use a semaphore to wait for the async task to complete.
    //let semaphore = DispatchSemaphore(value: 0)

    //DispatchQueue.main.async {

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
        
        //semaphore.signal()
    //}

    // Wait for the async task to complete.
    //semaphore.wait()

    return resultat!
}

// Convert UILabel to UIImage for printing
func createUIImage(from label: UILabel) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
    defer { UIGraphicsEndImageContext() }  // This ensures UIGraphicsEndImageContext() is always called at the end
    
    if let context = UIGraphicsGetCurrentContext() {
        label.layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    } // Ende if
    
    return nil
} // Ende func

/*
struct ShowObjektenListe: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    
    let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    var body: some View {
        
        let pdfPath = docDir!.appendingPathComponent("objektenListe.pdf")
        GeometryReader { geometry in
        NavigationView {
            
            Form {
                
                    VStack {
                        
                        if UIDevice.current.userInterfaceIdiom == .phone {
                            
                            PDFKitView(url: pdfPath)
                              .frame(width: geometry.size.width, height: geometry.size.height * globaleVariable.heightFaktorEbene1)
                            
                            
                        } else {
                            PDFKitView(url: pdfPath)
                                .frame(width: geometry.size.width * globaleVariable.widthFaktorEbene1,height: geometry.size.height * globaleVariable.heightFaktorEbene1, alignment: .center)
                                .background(globaleVariable.farbenEbene1)
                                .cornerRadius(10)
                        }
                    } // Ende VStack
                    .frame(width: geometry.size.width,height: geometry.size.height * globaleVariable.heightFaktorEbene0, alignment: .center)
                    .background(globaleVariable.farbenEbene0)
                
                
            }
            
        }
       } // Ende GeometryReader
        .navigationTitle("Objektenliste").navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action:{
                    
                    printingHandbuchFile()
                    
                }) {
                    Image(systemName: "printer") // printer.fill square.and.arrow.up
                } // Ende Button
            } // Ende ToolbarGroup
            
        }
    } // Ende var body
    
} // Ende struc ShowObjektenListe

*/

func createObjektenListe(parTitel: String, parUnterTitel: String) -> Bool {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    var titelString: String = parTitel
    var unterTitelString: String = parUnterTitel
    
    let sortObjekte: Bool = true
    
    //let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    let alleObjekte = querySQLAbfrageClassObjecte(queryTmp: "SELECT * FROM Objekte", abfrage: true)
    
    let objektWithFilter = serchObjectArray(parameter: alleObjekte)
    let objekte = sortiereObjekte(par1: objektWithFilter, par2: sortObjekte)
    //let resultat = docDir!.appendingPathComponent("objektenListe.pdf")
    
    if titelString.isEmpty {
        print("GV.Titel ist empty")
        titelString = "Das ist Header-Titel - First Line"
        print("\(titelString)")
    }else{
        print("GV.Titel ist nicht empty")
        print("\(titelString)")
    }// Ende if
    
    if unterTitelString.isEmpty {
        unterTitelString = "Das ist Header-Untertitel - Second Line"
    }else{
        
    } // Ende if
    
    let pageHeader = titelString + "\n" + unterTitelString
    
    generatePDF(pageHeader: pageHeader, objektenArray: objekte)
    
    return true
    
} // Ende func
