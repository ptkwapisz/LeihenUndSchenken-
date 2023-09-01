//
//  StatistikView.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 30.08.23.
//

import Foundation
import SwiftUI

// Statistiken
struct Statistik: View {
    //@Binding var selectedTabView: Int
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    //@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let heightFaktor: Double = 0.99
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                if UIDevice.current.userInterfaceIdiom == .phone {
                    StatistikView()
                        .frame(height: geometry.size.height * globaleVariable.heightFaktorEbene1)
                    
                } else {
                    StatistikView()
                        .frame(width: geometry.size.width * globaleVariable.widthFaktorEbene1,height: geometry.size.height * globaleVariable.heightFaktorEbene1, alignment: .center)
                        .background(globaleVariable.farbenEbene1)
                        .cornerRadius(10)
                    
                } // Ende if/else
                
            } // Ende VStack
            .frame(width: geometry.size.width,height: geometry.size.height * globaleVariable.heightFaktorEbene0, alignment: .center)
            .background(globaleVariable.farbenEbene0)
            
            Spacer()
            
        } // Ende GeometryReader
        .interactiveDismissDisabled()  // Disable dismiss with a swipe
        /*
        Button {
        
            // Diese Zeile bewirkt, dass die View geschlossen wird
            self.presentationMode.wrappedValue.dismiss()
            
        } label: {
            Label("Ansicht verlassen", systemImage: "arrowshape.turn.up.backward.circle")
            
        } // Ende Button
        .font(.system(size: 16, weight: .medium))
        .foregroundColor(Color.white)
        .buttonStyle(.borderedProminent)
        */
    } // Ende var body
} // Ende struc Tab%


struct StatistikView: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        
        let statistikenVariable: [Statistiken] = ladeStatistiken()
        let stSection = distingtArrayStatistiken(par1: statistikenVariable, par2: "stGruppe")
        
        VStack{
            Text("")
            Text("Statistiken").bold()
            
            List {
                
                ForEach(stSection.indices, id: \.self) { idx in
                    Section(header: Text("\(stSection[idx])")
                        .font(.system(size: 15, weight: .medium)).bold()) {
                            
                            ForEach(0..<statistikenVariable.count, id: \.self) { item in
                                
                                if stSection[idx] == statistikenVariable[item].stGruppe {
                                    
                                    HStack {
                                        
                                        Text("\(statistikenVariable[item].stName)")
                                        Spacer()
                                        Text("\(statistikenVariable[item].stWert)")
                                        
                                    } // Ende HStack
                                    //.background(globaleVariable.farbenEbene0).foregroundColor(Color.white)
                                    .frame(height: 10)
                                    .font(.system(size: 16, weight: .medium)).bold()
                                    
                                } // Ende if
                            }// Ende ForEach
                    
                        } // Ende Section
                    
                } // Ende ForEach
                
                HStack{
                 Spacer()
                    Button {
                        
                        // Diese Zeile bewirkt, dass die View geschlossen wird
                        self.presentationMode.wrappedValue.dismiss()
                        
                    } label: {
                        Label("Ansicht verlassen", systemImage: "arrowshape.turn.up.backward.circle")
                        
                    } // Ende Button
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color.white)
                    .buttonStyle(.borderedProminent)
                    Spacer()
                } // Ende HStack
                
                
            } // Ende List
            .cornerRadius(10)
            Spacer()
            
        } // Ende Vstack
        .background(globaleVariable.farbenEbene1)
        .cornerRadius(10)
        
    } // Ende var body
    
} // Ende struct
