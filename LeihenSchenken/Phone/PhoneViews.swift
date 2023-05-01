//
//  PhoneViews.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 01.05.23.
//

import SwiftUI
import Foundation

struct IphoneTable1: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    let titleErsteSpalte: CGFloat = 190
    let titleZweiteSpalte: CGFloat = 95

    let ersteSpalte: CGFloat = 135
    let zweiteSpalte: CGFloat = 60
    
    var body: some View {
        
        //let bluKat1 = distingtArray(par1: globaleVariable.badania, par2: "Kategorie1")
        let gegenstaende = addDataGegenstaende()
        
        let anzahl: Int = gegenstaende.count
      
            VStack {
                Text("Datensätze ").bold()  //+ "\(globaleVariable.selecteduntDate)").bold()
                
                    List {
                        /*
                            ForEach(bluKat1.indices, id: \.self) { idx in
                                
                                Section(header: Text("Kategorie " + "\(bluKat1[idx])")
                                    .font(.system(size: 15, weight: .medium)).bold()) {
                          */
                                        ForEach(0..<anzahl, id: \.self) { item in
                                            
                                            //if bluKat1[idx] == globaleVariable.badania[item].bluKategorie1 {
                                                
                                                VStack() {
                                                    
                                                    HStack {
                                                        
                                                        Text("\(gegenstaende[item].perKey)")
                                                        
                                                        Text("\(gegenstaende[item].gegenstand)")
                                                        
                                                        Spacer()
                                                        
                                                    } // Ende HStack
                                                    .background(globaleVariable.farbenEbene0).foregroundColor(Color.white)
                                                    .font(.system(size: 18, weight: .medium)).bold()
                                                    
                                                    HStack {
                                                        /*
                                                        NavigationLink(destination: ChartView(par1: globaleVariable.badania[item].bluNameL + " " + globaleVariable.badania[item].bluNameS)) {
                                                            
                                                            Text(String(globaleVariable.badania[item].bluWert))
                                                                .background(globaleVariable.farbenEbene0).foregroundColor(Color.white)
                                                                .font(.system(size: 15, weight: .medium)).bold()
                                                            
                                                            Text(String(globaleVariable.badania[item].bluEinheit))
                                                                .background(globaleVariable.farbenEbene0).foregroundColor(Color.white)
                                                                .font(.system(size: 15, weight: .medium)).bold()
                                                            
                                                            Spacer()
                                                            
                                                            Label{} icon: { Image(systemName: "chart.xyaxis.line") .font(.system(size: 12, weight: .medium))
                                                            } // Ende Label
                                                            .frame(width:35, height: 25, alignment: .center)
                                                            .background(.gray)
                                                            .cornerRadius(10)
                                                            .foregroundColor(.black)
                                                            // Diese Zeile bewirkt, dass Label rechtsbündig kurz vor dem > erscheint
                                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                                            
                                                            
                                                        } // Ende NavigationLink
                                                        */
                                                    } // Ende HStack
                                                    
                                                } // Ende VStack
                                                
                                            //} // Ende if blutKat1
                                        } // Ende ForEach
                                        .listRowBackground(globaleVariable.farbenEbene0)
                                        .listRowSeparatorTint(.white)
                                        
                                   // } // Ende Section
                                
                            //} // Ende ForEach
                        
                    } // Ende List
                    .cornerRadius(10)
                   
            } // Ende VStack
            .frame(width: 360, height: 570)
       
    } // Ende var body
    
} // Ende struct

