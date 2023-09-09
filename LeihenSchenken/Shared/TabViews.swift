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
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    @State var tmp: CGFloat = 0
    
    let heightFaktor: Double = 0.99
    //let test = addDataGegenstaende()
    
    //let test = querySQLAbfrageClassObjecte(queryTmp: "SELECT * FROM Objekte")
    
var body: some View {
    GeometryReader { geometry in
        VStack {
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                deteilTab1()
                .frame(height: geometry.size.height * globaleVariable.heightFaktorEbene1)
               
            } else {
                
                deteilTab1()
                    .frame(width: geometry.size.width * globaleVariable.widthFaktorEbene1,height: geometry.size.height * globaleVariable.heightFaktorEbene1, alignment: .center)
                    .background(globaleVariable.farbenEbene1)
                    .cornerRadius(10)
            } // Ende if/else
        } // Ende VStack
 
        .frame(width: geometry.size.width,height: geometry.size.height * globaleVariable.heightFaktorEbene0, alignment: .center)
        .background(globaleVariable.farbenEbene0)
    } // Ende GeometryReader
} // Ende var body
} // Ende struc Tab1

struct Tab2: View {
    @Binding var selectedTabView: Int
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    @State var tmp: CGFloat = 0
    
    let heightFaktor: Double = 0.99
    
    
var body: some View {
    GeometryReader { geometry in
        VStack {
            
            if UIDevice.current.userInterfaceIdiom == .phone {
               
                deteilTab2()
                    .frame(height: geometry.size.height * globaleVariable.heightFaktorEbene1)
                
            } else {
                deteilTab2()
                    .frame(width: geometry.size.width * globaleVariable.widthFaktorEbene1,height: geometry.size.height * globaleVariable.heightFaktorEbene1, alignment: .center)
                    .background(globaleVariable.farbenEbene1)
                    .cornerRadius(10)
                
            }
        } // Ende VStack
        .frame(width: geometry.size.width,height: geometry.size.height * globaleVariable.heightFaktorEbene0, alignment: .center)
        .background(globaleVariable.farbenEbene0)
        
    } // Ende GeometryReader
} // Ende var body
} // Ende struc Tab3



struct Tab3: View {
    @Binding var selectedTabView: Int
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @State var tmp: CGFloat = 0
    
    let heightFaktor: Double = 0.99
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                if UIDevice.current.userInterfaceIdiom == .phone {
                    deteilTab3()
                        .frame(height: geometry.size.height * globaleVariable.heightFaktorEbene1)
                    
                } else {
                    
                    deteilTab3()
                        .frame(width: geometry.size.width * globaleVariable.widthFaktorEbene1,height: geometry.size.height * globaleVariable.heightFaktorEbene1, alignment: .center)
                        .background(globaleVariable.farbenEbene1)
                        .cornerRadius(10)
                } // Ende if/else
            } // Ende VStack
            
            .frame(width: geometry.size.width,height: geometry.size.height * globaleVariable.heightFaktorEbene0, alignment: .center)
            .background(globaleVariable.farbenEbene0)
        } // Ende GeometryReader
    } // Ende var body
} // Ende struc Tab3


// Objektenliste
struct Tab4: View {
    @Binding var selectedTabView: Int
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    //let _: Bool = createObjektenListe()
    
    var body: some View {
    
        let _ = print("Struct Tab4 wird aufgerufen!")
        
        let pdfPath = docDir!.appendingPathComponent("objektenListe.pdf")
        
        GeometryReader { geometry in
            VStack {
                
                if UIDevice.current.userInterfaceIdiom == .phone {
                    
                    PDFKitView(url: pdfPath, tabNumber: 4)
                        .frame(width: geometry.size.width, height: geometry.size.height * globaleVariable.heightFaktorEbene1)
                    
                } else {
                    PDFKitView(url: pdfPath, tabNumber: 4)
                        .frame(width: geometry.size.width * globaleVariable.widthFaktorEbene1,height: geometry.size.height * globaleVariable.heightFaktorEbene1, alignment: .center)
                        .background(globaleVariable.farbenEbene1)
                        .cornerRadius(10)
                }
            } // Ende VStack
            .frame(width: geometry.size.width,height: geometry.size.height * globaleVariable.heightFaktorEbene0, alignment: .center)
            .background(globaleVariable.farbenEbene0)
        } // Ende GeometryReader
        
    } // Ende var body

} // Ende struc Tab4


// Das Handburch
struct Tab5: View {
    @Binding var selectedTabView: Int
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    
    let pdfPath = Bundle.main.url(forResource: "L&S Handbuch", withExtension: "pdf")
    //let heightFaktor: Double = 0.99
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                if UIDevice.current.userInterfaceIdiom == .phone {
                    
                    PDFKitView(url: pdfPath!, tabNumber: 5)
                        .frame(width: geometry.size.width, height: geometry.size.height * globaleVariable.heightFaktorEbene1)
                    
                    
                } else {
                    PDFKitView(url: pdfPath!, tabNumber: 5)
                        .frame(width: geometry.size.width * globaleVariable.widthFaktorEbene1,height: geometry.size.height * globaleVariable.heightFaktorEbene1, alignment: .center)
                        .background(globaleVariable.farbenEbene1)
                        .cornerRadius(10)
                }
            } // Ende VStack
            .frame(width: geometry.size.width,height: geometry.size.height * globaleVariable.heightFaktorEbene0, alignment: .center)
            .background(globaleVariable.farbenEbene0)
        } // Ende GeometryReader
    } // Ende var body
} // Ende struc Tab6



