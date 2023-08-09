//
//  PhoneViews.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 01.05.23.
//

import SwiftUI
import Foundation
 
struct IphoneTable4: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
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
                }
            } // Ende List
            .cornerRadius(10)
            Spacer()
            
        } // Ende Vstack
        .background(globaleVariable.farbenEbene1)
        .cornerRadius(10)
        
    } // Ende var body
    
} // Ende struct

func perKeyBestimmenGegenstand(par: String) -> [String] {
    var result: [String] = [""]
    
    if par != "N/A" {
        result = querySQLAbfrageArray(queryTmp: "SELECT perKey FROM Gegenstaende WHERE gegenstandName = '\(par)'")
    }else{
        result = [""]
    } // Ende if/else

    return result
} // Ende func

func perKeyBestimmenPerson(par: String) -> [String] {
    var result: [String] = [""]
    
    if par != "N/A" {
        result = querySQLAbfrageArray(queryTmp: "SELECT perKey FROM Personen WHERE personPicker = '\(par)'")
    }else{
        result = [""]
    } // Ende if/else

    return result
} // Ende func

