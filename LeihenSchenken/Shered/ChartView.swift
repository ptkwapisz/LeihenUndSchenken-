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
    
            //Text("\(dateToString(parDatum: par1[par2].datum))")
            Text("\(par1[par2].datum)")
            
            Image(base64Str: par1[par2].gegenstandBild)!
                .resizable()
                .cornerRadius(100)
                .padding(.all, 4)
                .frame(width: 100, height: 100)
                .background(Color.black.opacity(0.2))
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
            
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
