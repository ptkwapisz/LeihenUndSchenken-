//
//  ChartView.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 01.05.23.
//

import SwiftUI

struct ChartView: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    @State var par1: [GegenstaendeVariable]
    @State var par2: Int
    
    @State var showChartHilfe: Bool = false
    
    
    var body: some View {
        
        VStack {
            
            Text("\(par1[par2].datum)")
            if par1[par2].gegenstandBild != "Kein Bild" {
                Image(base64Str: par1[par2].gegenstandBild)!
                .resizable()
                .scaledToFit()
                .cornerRadius(25)
                .padding(20)
                .frame(width: 350, height: 200)
                .shadow(color: Color.black, radius: 5, x: 5, y: 5)
            }else{
                Text("Kein Bild")
                    .scaledToFit()
                    .padding(20)
                    .frame(width: 150, height: 100)
                    .background(Color.gray.gradient)
                    .cornerRadius(25)
            
            } // Ende if/else
            
            Text("\(par1[par2].gegenstandText)")
            
        } // Ende Vstack
        .navigationTitle("\(par1[par2].gegenstand)")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action:{showChartHilfe.toggle()
                    
                }) {
                    Image(systemName: "questionmark.circle")
                } // Ende Button
                .alert("Hilfe für Chart", isPresented: $showChartHilfe, actions: {
                    Button(" - OK - ") {}
                }, message: { Text("Das ist die Beschreibung für das Chart.") } // Ende message
                ) // Ende alert
            } // Ende ToolbarItemGroup
        } // Ende toolbar
    }  // Ende var body
} // Ende struckt ChartView
