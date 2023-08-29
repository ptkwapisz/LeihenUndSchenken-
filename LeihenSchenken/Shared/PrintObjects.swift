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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var titel: String = ""
    @State var unterTitel: String = ""
    @State var sortObjekte: Bool = true
    
    @FocusState var isInputActiveTitel: Bool
    @FocusState var isInputActiveUntertitel: Bool
    
    
    var body: some View {
       
        let alleObjekte = querySQLAbfrageClassObjecte(queryTmp: "SELECT * FROM Objekte")
        
        let objektWithFilter = serchObjectArray(parameter: alleObjekte)
        
        let objekte = sortiereObjekte(par1: objektWithFilter, par2: sortObjekte)
        
        NavigationView {
            Form {
                Section(header: Text("Kopfzeilen der Liste").foregroundColor(.gray).font(.system(size: 16, weight: .regular))) {
                    TextField("Listentitel", text: $titel)
                        .focused($isInputActiveTitel)
                        .padding(5)
                        .background(Color(.systemGray6))
                        .cornerRadius(5)
                        .disableAutocorrection(true)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                HStack {
                                    Spacer()
                                    Button("Abbrechen") {
                                        isInputActiveTitel = false
                                        titel = ""
                                    } // Ende Button
                                } // Ende HStack
                                
                            } // Ende ToolbarItemGroup
                        } // Ende Toolbar
                    
                    
                    TextField("Listenuntertitel", text: $unterTitel)
                        .focused($isInputActiveUntertitel)
                        .padding(5)
                        .background(Color(.systemGray6))
                        .cornerRadius(5)
                        .disableAutocorrection(true)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                HStack {
                                    Spacer()
                                    Button("Abbrechen") {
                                        isInputActiveUntertitel = false
                                        unterTitel = ""
                                    } // Ende Button
                                } // Ende HStack
                                
                            } // Ende ToolbarItemGroup
                        } // Ende Toolbar
                    
                }// Ende Section
                .font(.system(size: 16, weight: .regular))
                
                
                VStack{
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {Text("Abbrechen")}
                            .buttonStyle(.bordered).foregroundColor(.blue).font(.system(size: 16, weight: .regular))
                        
                        Button(action: {
                            if titel.isEmpty {
                                titel = "Das ist Header-Titel - First Line"
                            }// Ende if
                            if unterTitel.isEmpty {
                                unterTitel = "Das ist Header-Untertitel - Second Line"
                            } // Ende if
                            
                            let pageHeader = titel + "\n" + unterTitel
                            
                            printItems(pageHeader: pageHeader, objektenArray: objekte)
                            //printObjectsList(titel: titel, unterTitel: unterTitel)
                            
                        }) {Text("Liste generieren")}
                            .buttonStyle(.borderedProminent)
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .regular))
                            .cornerRadius(10)
                        Spacer()
                    }// Ende HStack
                } // Ende VStack
            } // Ende Form
            .navigationTitle("Objektlisten Parameter").navigationBarTitleDisplayMode(.inline)
        } // Ende NavigationView
        .interactiveDismissDisabled()  // Disable dismiss with a swipe
    } // Ende var body
    
} // Ende func


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
}

class PrintItem: Identifiable {
    //static let shared = UserSettingsDefaults()
    
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
        
        // Create and add a print formatter to the renderer. This is a workaround to ensure headers and footers are drawn.
        let formatter = UISimpleTextPrintFormatter(text: " ")
        self.addPrintFormatter(formatter, startingAtPageAt: 0)
    }
    
    // Calculate the total number of pages required to print all items.
    override var numberOfPages: Int {
        return (items.count + itemsPerPage - 1) / itemsPerPage
    }
    
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
            
        }
    }
    
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
    }
    
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
        }
    }
    
    // Method responsible for rendering a single PrintItem.
    private func drawItem(_ item: ObjectVariable, in rect: CGRect) {
        
        // Text attributes for the item's text.
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12)
        ]
        
        // Draw the item's text.
        let text = item.gegenstand as NSString
        text.draw(in: rect.insetBy(dx: 10, dy: 10), withAttributes: textAttributes)
        
        
        // Draw the item's image.
        let imageRect = CGRect(x: rect.minX + 10, y: rect.minY + 40, width: 50, height: 50)
        if item.gegenstandBild == "Kein Bild" {
            
            
            let emptyGegenstandBild = createImageFromLabel(labelText: "Kein Bild")
            emptyGegenstandBild.draw(in: imageRect)
            
        }else{
            
            let base64String = item.gegenstandBild
            let gegenstandBild = UIImage(base64Str: base64String)
            gegenstandBild!.draw(in: imageRect)
            
            
        } // Ende if/else
        
        // Draw the item's label (assuming this is an image due to the previous code, which is a bit confusing).
        let labelRect = CGRect(x: rect.minX + 70, y: rect.minY + 40, width: 200, height: 50)
        if item.gegenstandText.isEmpty {
            
            
            let emptyImageGegenstandText = createImageFromLabel(labelText: "Kein Gegenstandstext.")
            emptyImageGegenstandText.draw(in: labelRect)
            
        }else{
            
            let imageGegenstandText = createImageFromLabel(labelText: "\(item.gegenstandText)")
            imageGegenstandText.draw(in: labelRect)
            
        } // Ende if/else
        
    } // Ende func drawItem
    
    
}

// This extention help to convert Image from base64String to UIImage
extension UIImage {
    convenience init?(base64Str: String) {
        guard let data = Data(base64Encoded: base64Str) else {
            return nil
        } // Ende guard
        self.init(data: data)
    } // Ende convenince
} // Ende extension



func createImageFromLabel(labelText: String) -> UIImage {
    var resultat: UIImage
    var widthInt = 0
    
    if labelText == "Kein Bild" {
        widthInt = 50
    }else{
        widthInt = 150
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
    
    resultat = createUIImage(from: labelTmp)!
    
    return resultat
    
} // Ende func
