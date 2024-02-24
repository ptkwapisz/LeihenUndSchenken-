//
//  TabViews.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 27.03.23.
//

import Foundation
import SwiftUI

struct Tab1: View {
    @Binding var selectedTabView: Int
    //@ObservedObject var globaleVariable = GlobaleVariable.shared
    
var body: some View {
    let _ = print("Struct Tab1 wird aufgerufen!")
    GeometryReader { geometry in
        VStack {
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                DeteilTab1()
                .frame(height: geometry.size.height * GlobalStorage.heightFaktorEbene1)
                
            } else {
                
                DeteilTab1()
                    .frame(width: geometry.size.width * GlobalStorage.widthFaktorEbene1,height: geometry.size.height * GlobalStorage.heightFaktorEbene1, alignment: .center)
                    .background(GlobalStorage.farbEbene1)
                    .cornerRadius(10)
            } // Ende if/else
        } // Ende VStack
 
        .frame(width: geometry.size.width,height: geometry.size.height * GlobalStorage.heightFaktorEbene0, alignment: .center)
        .background(GlobalStorage.farbEbene0)
    } // Ende GeometryReader
} // Ende var body
} // Ende struc Tab1

struct Tab2: View {
    @Binding var selectedTabView: Int
    //@ObservedObject var globaleVariable = GlobaleVariable.shared
    
var body: some View {
    let _ = print("Struct Tab2 wird aufgerufen!")
    
    GeometryReader { geometry in
        VStack {
            
            if UIDevice.current.userInterfaceIdiom == .phone {
               
                deteilTab2()
                    .frame(height: geometry.size.height * GlobalStorage.heightFaktorEbene1)
                
            } else {
                deteilTab2()
                    .frame(width: geometry.size.width * GlobalStorage.widthFaktorEbene1,height: geometry.size.height * GlobalStorage.heightFaktorEbene1, alignment: .center)
                    .background(GlobalStorage.farbEbene1)
                    .cornerRadius(10)
                
            }
        } // Ende VStack
        .frame(width: geometry.size.width,height: geometry.size.height * GlobalStorage.heightFaktorEbene0, alignment: .center)
        .background(GlobalStorage.farbEbene0)
        
    } // Ende GeometryReader
} // Ende var body
} // Ende struc Tab3

struct Tab3: View {
    @Binding var selectedTabView: Int
    //@ObservedObject var globaleVariable = GlobaleVariable.shared
    
    @State private var tmp: CGFloat = 0
    
    //let heightFaktor: Double = 0.99
    
    var body: some View {
        let _ = print("Struct Tab3 wird aufgerufen!")
        GeometryReader { geometry in
            VStack {
                
                if UIDevice.current.userInterfaceIdiom == .phone {
                    deteilTab3()
                        .frame(height: geometry.size.height * GlobalStorage.heightFaktorEbene1)
                    
                } else {
                    
                    deteilTab3()
                        .frame(width: geometry.size.width * GlobalStorage.widthFaktorEbene1,height: geometry.size.height * GlobalStorage.heightFaktorEbene1, alignment: .center)
                        .background(GlobalStorage.farbEbene1)
                        .cornerRadius(10)
                } // Ende if/else
            } // Ende VStack
            
            .frame(width: geometry.size.width,height: geometry.size.height * GlobalStorage.heightFaktorEbene0, alignment: .center)
            .background(GlobalStorage.farbEbene0)
        } // Ende GeometryReader
    } // Ende var body
} // Ende struc Tab3


// Tab4

// Objektenliste
struct Tab4: View {
    @Binding var selectedTabView: Int
    
    @State private var showPDFGenerator = true // Initial auf true setzen, um direkt zu zeigen
    @State private var isPDFGenerated = false // Zustand, der angibt, ob die PDF generiert wurde
    @State private var showProgressView: Bool = false // das anzeigen der progressView

    let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    var body: some View {
    
        let _ = print("Struct Tab4 wird aufgerufen!")
        
        let pdfPath = docDir!.appendingPathComponent("ObjektenListe.pdf")
        
        GeometryReader { geometry in
            VStack {
                
                if UIDevice.current.userInterfaceIdiom == .phone {
                    
                    if isPDFGenerated { //Zeige PDFKitView nur, wenn isPDFGenerated == true
                        
                        PDFKitView(url: pdfPath, tabNumber: 4)
                            .frame(width: geometry.size.width, height: geometry.size.height * GlobalStorage.heightFaktorEbene1)
                        
                    } // Ende if
                    
                } else {
                    
                    PDFKitView(url: pdfPath, tabNumber: 4)
                        .frame(width: geometry.size.width * GlobalStorage.widthFaktorEbene1,height: geometry.size.height * GlobalStorage.heightFaktorEbene1, alignment: .center)
                        .background(GlobalStorage.farbEbene1)
                        .cornerRadius(10)
                } // Ende if/else
                
            } // Ende VStack
            .overlay(
                
                showPDFGenerator ? AnyView(PDFGeneratorTab(isPDFGenerated: $isPDFGenerated, showProgressView: $showProgressView)) : AnyView(EmptyView())

            ) // Ende overlay
            .frame(width: geometry.size.width,height: geometry.size.height * GlobalStorage.heightFaktorEbene0, alignment: .center)
            .background(GlobalStorage.farbEbene0)
            
        } // Ende GeometryReader
        
    } // Ende var body
    

} // Ende struc Tab4




// Das Handburch
struct Tab5: View {
    @Binding var selectedTabView: Int
    //@ObservedObject var globaleVariable = GlobaleVariable.shared
    
    let pdfPath = Bundle.main.url(forResource: "L&S Handbuch", withExtension: "pdf")
    
    var body: some View {
        let _ = print("Struct Tab5 wird aufgerufen!")
        
        GeometryReader { geometry in
            VStack {
                
                if UIDevice.current.userInterfaceIdiom == .phone {
                    
                    PDFKitView(url: pdfPath!, tabNumber: 5)
                        .frame(width: geometry.size.width, height: geometry.size.height * GlobalStorage.heightFaktorEbene1)
                    
                    
                } else {
                    
                    PDFKitView(url: pdfPath!, tabNumber: 5)
                        .frame(width: geometry.size.width * GlobalStorage.widthFaktorEbene1,height: geometry.size.height * GlobalStorage.heightFaktorEbene1, alignment: .center)
                        .background(GlobalStorage.farbEbene1)
                        .cornerRadius(10)
                     
                } // Ende if/else
                 
            } // Ende VStack
            .frame(width: geometry.size.width,height: geometry.size.height * GlobalStorage.heightFaktorEbene0, alignment: .center)
            .background(GlobalStorage.farbEbene0)
        } // Ende GeometryReader
    } // Ende var body
} // Ende struc Tab6



