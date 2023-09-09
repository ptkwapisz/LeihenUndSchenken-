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

func ladeStatistiken() -> [Statistiken] {
    var resultat: [Statistiken] = [Statistiken(stGruppe: "", stName: "", stWert: "")]
    resultat.removeAll()
    
    let z1s0: String = "Objekte"
    let z1s1: String = "Alle Objekte:"
    let z1S2: [String]  = querySQLAbfrageArray(queryTmp: "Select count() From Objekte")
    
    
    
    let z2s0: String = "Objekte"
    let z2s1: String = "Verschenkte Objekte:"
    let z2S2: [String]  = querySQLAbfrageArray(queryTmp: "Select count() From Objekte Where vorgang = 'Verschenken'")
    
    let z3s0: String = "Objekte"
    let z3s1: String = "Verliehene Objekte:"
    let z3S2: [String]  = querySQLAbfrageArray(queryTmp: "Select count() From Objekte Where vorgang = 'Verleihen'")
    
    let z4s0: String = "Objekte"
    let z4s1: String = "Erhaltene Objekte:"
    let z4S2: [String]  = querySQLAbfrageArray(queryTmp: "Select count() From Objekte Where vorgang = 'Bekommen'")
    
    let z5s0: String = "Objekte"
    let z5s1: String = "Objekte zum Aufbewahren:"
    let z5S2: [String]  = querySQLAbfrageArray(queryTmp: "Select count() From Objekte Where vorgang = 'Aufbewahren'")
    
    let z6s0: String = "Objekte"
    let z6s1: String = "Ideen für ein Objekt:"
    let z6S2: [String]  = querySQLAbfrageArray(queryTmp: "Select count() From Objekte Where vorgang = 'Geschenkidee'")
    
    
    resultat.append(Statistiken(stGruppe: z1s0, stName: z1s1, stWert: z1S2.count == 0 ? "0" : z1S2[0]))
    resultat.append(Statistiken(stGruppe: z2s0, stName: z2s1, stWert: z2S2.count == 0 ? "0" : z2S2[0]))
    resultat.append(Statistiken(stGruppe: z3s0, stName: z3s1, stWert: z3S2.count == 0 ? "0" : z3S2[0]))
    resultat.append(Statistiken(stGruppe: z4s0, stName: z4s1, stWert: z4S2.count == 0 ? "0" : z4S2[0]))
    resultat.append(Statistiken(stGruppe: z5s0, stName: z5s1, stWert: z5S2.count == 0 ? "0" : z5S2[0]))
    resultat.append(Statistiken(stGruppe: z6s0, stName: z6s1, stWert: z6S2.count == 0 ? "0" : z6S2[0]))
    
    
    let tmp0 = querySQLAbfrageArray(queryTmp: "Select distinct(gegenstand) From Objekte")
    
    if tmp0.count != 0 {
        
        for n in 0...tmp0.count - 1 {
            
            let tmp1 = querySQLAbfrageArray(queryTmp: "Select count() gegenstand From Objekte Where gegenstand = '\(tmp0[n])'")
            
            if Int("\(tmp1[0])") != 0 {
                
                resultat.append(Statistiken(stGruppe: "Gegenstände", stName: "\(tmp0[n])", stWert: tmp1[0]))
                
            } // Ende if
            
        }// Ende for
        
    }else{
        
        // Wenn Tabelle Objekte leer ist:
        resultat.append(Statistiken(stGruppe: "Gegenstände", stName: "Anzahl der Gegenstände", stWert: "0"))
        
    } // Ende if/else
    
    return resultat
} // Ende func
