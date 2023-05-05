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
    
    @State var operatorZeichen: [String] = ["gleicht", "ungleicht"]
    @State private var selectedOperatorZeichen = "gleicht"
    
    @State var tabellenFeld1: [String] = ["gegenstand", "vorgang","name", "vorname"]
    @State private var selectedTabellenFeld1 = "gegenstand"
    
    @State var tabellenFeld2: [String] = ["Buch", "Geld","CD/DVD", "Werkzeug"]
    @State private var selectedTabellenFeld2 = "Buch"
    
    var body: some View {
        
        VStack {
            Text("Abfragenfilter").bold()
            Form {
                
                Picker("Bedinung 1", selection: $selectedTabellenFeld1, content: {
                                ForEach(tabellenFeld1, id: \.self, content: { index1 in
                                    Text(index1)
                                })
                })
                .frame(height: 50)
                
                Picker("", selection: $selectedOperatorZeichen, content: {
                                ForEach(operatorZeichen, id: \.self, content: { index2 in
                                    Text(index2)
                                })
                })
                .pickerStyle(.wheel)
                .frame(height: 50)
                
                Picker("Bedinung 2", selection: $selectedTabellenFeld2, content: {
                                ForEach(tabellenFeld2, id: \.self, content: { index3 in
                                    Text(index3)
                                })
                })
                .frame(height: 50)
                
                /*
                HStack {
                    Text("Feld 1 ")
                    Text("Feld 2 ")
                } // Ende HStack
              
                HStack {
                    Text("Feld 3 ")
                    Text("Feld 4 ")
                } // Ende HStack
                */
                
            } // Ende Form
            .background(globaleVariable.farbenEbene1)
            .cornerRadius(10)
            //.frame(width: 360, height: 570)
                           
        } // Ende VStack
    } // Ende var body
} // Ende struct


struct IphoneTable2: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    let titleErsteSpalte: CGFloat = 190
    let titleZweiteSpalte: CGFloat = 95

    let ersteSpalte: CGFloat = 135
    let zweiteSpalte: CGFloat = 60
    
    var body: some View {
        
        let gegenstaende = addDataGegenstaende()
        let gegVorgang = distingtArray(par1: gegenstaende, par2: "Vorgang")
        
        
        let anzahl: Int = gegenstaende.count
      
            VStack {
                Text("Alle Vorgänge").bold()  //+ "\(globaleVariable.selecteduntDate)").bold()
                
                    List {
                        
                            ForEach(gegVorgang.indices, id: \.self) { idx in
                                
                                Section(header: Text("Vorgang: " + "\(gegVorgang[idx])")
                                    .font(.system(size: 15, weight: .medium)).bold()) {
                          
                                        ForEach(0..<anzahl, id: \.self) { item in
                                            
                                            if gegVorgang[idx] == gegenstaende[item].vorgang {
                                                
                                                VStack() {
                                                    
                                                    HStack {
                                                        
                                                        //Text("\(gegenstaende[item].perKey)")
                                                        
                                                        Text("\(gegenstaende[item].gegenstand)")
                                                        
                                                        Spacer()
                                                        
                                                    } // Ende HStack
                                                    .background(globaleVariable.farbenEbene0).foregroundColor(Color.white)
                                                    .font(.system(size: 18, weight: .medium)).bold()
                                                    
                                                    HStack {
                                                        NavigationLink(destination: ChartView(par1: gegenstaende, par2: item)) {
                                                            
                                                            
                                                            Text(String(gegenstaende[item].personVorname))
                                                                .background(globaleVariable.farbenEbene0).foregroundColor(Color.white)
                                                                .font(.system(size: 15, weight: .medium)).bold()
                                                            
                                                            Text(String(gegenstaende[item].personNachname))
                                                                .background(globaleVariable.farbenEbene0).foregroundColor(Color.white)
                                                                .font(.system(size: 15, weight: .medium)).bold()
                                                            
                                                            Spacer()
                                                            
                                                            Label{} icon: { Image(systemName: "list.bullet") .font(.system(size: 12, weight: .medium))
                                                            } // Ende Label
                                                            .frame(width:35, height: 25, alignment: .center)
                                                            .background(.gray)
                                                            .cornerRadius(10)
                                                            .foregroundColor(.black)
                                                            // Diese Zeile bewirkt, dass Label rechtsbündig kurz vor dem > erscheint
                                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                                            
                                                            
                                                        } // Ende NavigationLink
                                                    
                                                    } // Ende HStack
                                                    
                                                } // Ende VStack
                                                
                                            } // Ende if blutKat1
                                        } // Ende ForEach
                                        .listRowBackground(globaleVariable.farbenEbene0)
                                        .listRowSeparatorTint(.white)
                                        
                                   } // Ende Section
                                
                            } // Ende ForEach
                        
                    } // Ende List
                    .cornerRadius(10)
                   
            } // Ende VStack
            //.frame(width: 360, height: 570)
            //.background(globaleVariable.farbenEbene1)
            .cornerRadius(10)
            .shadow(radius: 10)
       
    } // Ende var body
    
} // Ende struct

