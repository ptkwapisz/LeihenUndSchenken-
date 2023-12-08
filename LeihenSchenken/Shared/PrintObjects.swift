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
    
    @FocusState private var focusedFields: Field?
    
    private enum Field: Int, CaseIterable {
        case titel // Für titel
        case unterTitel // Für Untertitel
        
    } // Ende private enum
    
    // Das ist eigenes Button
    // Ohne dieses Button wird der Name der View angezeigt (Gegenstandsname)
    // Wenn man aber den Gegenstandsname ändert bleibt es in der Anzeige als zurück der alte Name.
    var btnBack : some View { Button(action: {
        isPresented = false
    }) {
        HStack {
            Image(systemName: "chevron.left").bold()
                .offset(x: -7)
            Text("Zurück")
                .offset(x: -11)
            Spacer()
        } // Ende HStack
        .onDisappear() {
            // It is like a Cancel Button
            print("Disappear in ObjektListeParameter wurde ausgeführt.")
            
        } // Ende onDisappear
    } // Ende Button Label
    } // Ende some View
    
    
    var body: some View {
        let _ = print("Struct ObjektListParameter wird aufgerufen!")
        
        GeometryReader { geometry in
            
            VStack {
                VStack {
                    Text("")
                    Text("Parameter").bold()
                    List {
                        Section(header: Text("Kopfzeilen der Liste").foregroundColor(.gray).font(.system(size: 16, weight: .regular))) {
                           // VStack {
                                
                                CustomTextField(text: $data.titel, isMultiLine: false, placeholder: "Listentitel")
                                    .focused($focusedFields, equals: .titel)
                                /*
                                TextField("Listentitel", text: $data.titel)
                                    .padding(5)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(5)
                                    .submitLabel(.done)
                                    .disableAutocorrection(true)
                                    .focused($focusedFields, equals: .titel)
                                */
                                
                                CustomTextField(text: $data.unterTitel, isMultiLine: false, placeholder: "Listenuntertitel")
                                    .focused($focusedFields, equals: .unterTitel)
                                /*
                                TextField("Listenuntertitel", text: $data.unterTitel)
                                    .padding(5)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(5)
                                    .submitLabel(.done)
                                    .disableAutocorrection(true)
                                    .focused($focusedFields, equals: .unterTitel)
                                 */
                                
                            //} // Ende VStack
                            
                            
                        }// Ende Section
                        .font(.system(size: 16, weight: .regular))
                       
                        Section {
                            Toggle("Das Feld Preis/Wert:", isOn: $globaleVariable.preisOderWert ).toggleStyle(SwitchToggleStyle(tint: .blue)).font(.system(size: 16, weight: .regular))
                        } footer: {
                            
                            Text("Beim Einschalten wird das Feld Preis/Wert falls vorhanden, neben dem Gegenstand auf der Liste mitangezeigt.").font(.system(size: 12, weight: .regular))
                            
                        } // Ende Section
                        
                            HStack {
                                Spacer()
                               
                                Button {
                                    print("Titel und Untertitel wurden übernohmen!")
                                    // Is defined in GlobaleVariablen
                                    data.save()
                                    
                                    isPresented.toggle()
                                    
                                } label: {
                                    Label("Daten übernehmen", systemImage: "arrowshape.turn.up.backward.circle")
                                    
                                } // Ende Button
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color.white)
                                .buttonStyle(.borderedProminent)
                                .cornerRadius(10)
                                .disabled(data.titel.isEmpty && data.unterTitel.isEmpty)
                                
                                Spacer()
                            } // Ende HStack
                            .padding()
                            
                        Text("Beim Drücken auf 'Daten übernehmen' wird das Fenster geschloßen und die einzehlen Parameter werden gespeichert.")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.gray)
                        
                    } // Ende List
                    
                    
                } // Ende VStack
                .frame(width: geometry.size.width,height: geometry.size.height * globaleVariable.heightFaktorEbene1, alignment: .center)
                .background(globaleVariable.farbenEbene1)
                .cornerRadius(10)
                
            } // Ende VStack
            .frame(width: geometry.size.width,height: geometry.size.height * globaleVariable.heightFaktorEbene0, alignment: .center)
            .background(globaleVariable.farbenEbene0)
            .navigationTitle("PDF Objektliste").navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden()
            .navigationBarItems(leading: btnBack)
            
            
        } // Ende GeometryReader
        .interactiveDismissDisabled()  // Disable dismiss with a swipe
        //.navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                
                if focusedFields == .titel {
                    HStack{
                        Spacer()
                        Button("Abbrechen") {
                            
                            print("Abbrechen Button titel wurde gedrückt!")
                            focusedFields = nil
                        } // Ende Button
                    } // Ende HStack
                }else if focusedFields == .unterTitel {
                    HStack{
                        Spacer()
                        Button("Abbrechen") {
                            
                            print("Abbrechen Button unterTitel wurde gedrückt!")
                            focusedFields = nil
                        } // Ende Button
                    } // Ende HStack
                    
                } // Ende if/else
                
            } // Ende ToolbarItemGroup
        }// Ende toolbar
        
    } // Ende var body
    
} // Ende struct

/*
// This function start the printing prozess
// Start from Sheet ObjektListeParameter
func printItems(pageHeader: String, objektenArray: [ObjectVariable]) {
    
    let _ = print("Funktion printItems() wird aufgerufen!")
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
*/


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
    let _ = print("Funktion createImageFromLabel() wird aufgerufen!")
    
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
    let _ = print("Funktion createUIImage() wird aufgerufen!")
    
    UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
    defer { UIGraphicsEndImageContext() }  // This ensures UIGraphicsEndImageContext() is always called at the end
    
    if let context = UIGraphicsGetCurrentContext() {
        label.layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    } // Ende if
    
    return nil
} // Ende func


func createObjektenListe(parTitel: String, parUnterTitel: String) -> Bool {
    let _ = print("Funktion createObjektenListe() wird aufgerufen!")
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
        
        titelString = "Das ist Header-Titel - First Line"
        print("\(titelString)")
    }else{
        
        print("Das ist Header-Titel: \(titelString)")
    }// Ende if
    
    if unterTitelString.isEmpty {
        unterTitelString = "Das ist Header-Untertitel - Second Line"
    }else{
        
    } // Ende if
    
    let pageHeader = titelString + "\n" + unterTitelString
    
    generatePDF(pageHeader: pageHeader, objektenArray: objekte)
    
    return true
    
} // Ende func
