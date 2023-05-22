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
    
    let heightFaktor: Double = 0.99
    //let test = addDataGegenstaende()
    
    let test = querySQLAbfrageClassObjecte(queryTmp: "SELECT * FROM Objekte")
    
var body: some View {
    GeometryReader { geometry in
        VStack {
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                IphoneTable1()
                .frame(height: geometry.size.height * globaleVariable.heightFaktorEbene1)
               
            } else {
                
                Text("DeteilView Tab2")
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
    
    let heightFaktor: Double = 0.99
    
var body: some View {
    GeometryReader { geometry in
        VStack {
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                IphoneTable2()
                .frame(height: geometry.size.height * globaleVariable.heightFaktorEbene1)
               
            } else {
                
                Text("DeteilView Tab2")
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
    
    let heightFaktor: Double = 0.99
    
var body: some View {
    GeometryReader { geometry in
        VStack {
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                IphoneTable3()
                .frame(height: geometry.size.height * globaleVariable.heightFaktorEbene1)
               
            } else {
                
                Text("DeteilView Tab3")
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

struct Tab4: View {
    @Binding var selectedTabView: Int
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    let heightFaktor: Double = 0.99
    
var body: some View {
    GeometryReader { geometry in
        VStack {
            
            Text("DeteilView Tab4")
                .frame(width: geometry.size.width * globaleVariable.widthFaktorEbene1,height: geometry.size.height * globaleVariable.heightFaktorEbene1, alignment: .center)
                .background(globaleVariable.farbenEbene1)
                .cornerRadius(10)
            
        } // Ende VStack
        .frame(width: geometry.size.width,height: geometry.size.height * globaleVariable.heightFaktorEbene0, alignment: .center)
        .background(globaleVariable.farbenEbene0)
    } // Ende GeometryReader
} // Ende var body
} // Ende struc Tab4

struct Tab5: View {
    @Binding var selectedTabView: Int
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    let pdfPath = Bundle.main.url(forResource: "L&S Handbuch", withExtension: "pdf")
    let heightFaktor: Double = 0.99
    
var body: some View {
    GeometryReader { geometry in
        VStack {
            
            if UIDevice.current.userInterfaceIdiom == .phone {
               
                
                PDFKitView(url: pdfPath!)
                    .frame(width: geometry.size.width, height: geometry.size.height * globaleVariable.heightFaktorEbene1)
            
                
            } else {
                
                Text("DeteilView Tab5")
                    .frame(width: geometry.size.width * globaleVariable.widthFaktorEbene1,height: geometry.size.height * globaleVariable.heightFaktorEbene1, alignment: .center)
                    .background(globaleVariable.farbenEbene1)
                    .cornerRadius(10)
            }
        } // Ende VStack
        .frame(width: geometry.size.width,height: geometry.size.height * globaleVariable.heightFaktorEbene0, alignment: .center)
        .background(globaleVariable.farbenEbene0)
    } // Ende GeometryReader
} // Ende var body
} // Ende struc Tab5
