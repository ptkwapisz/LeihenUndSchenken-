//
//  ChartView.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 01.05.23.
//
//

import SwiftUI

// Das ist die View für detalierte Objektangaben mit Foto
struct ChartView: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    @State var par1: [ObjectVariable]
    @State var par2: Int
    
    @State var showChartHilfe: Bool = false
    
    let heightFaktor: Double = 0.99
    
var body: some View {
    GeometryReader { geometry in
        VStack {
        
            VStack {
                Text("")
                Text("Objektdeteilansicht").bold()
                
                List {
                    
                    HStack {
                            
                        if par1[par2].gegenstandBild != "Kein Bild" {
                                Image(base64Str: par1[par2].gegenstandBild)!
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150, height: 150)
                                    .clipped()
                                    .cornerRadius(10)
                                    .padding(5)
                                
                            }else{
                                Text("Kein Bild")
                                    .scaledToFit()
                                    .padding(20)
                                    .frame(width: 150, height: 150)
                                    .background(Color.gray.gradient)
                                    .cornerRadius(10)
                                   
                            } // Ende if/else
                            
                            
                            Text("\(par1[par2].gegenstandText)")
                            //.padding(.top, 10)
                            //.padding(.leading, 6)
                                .frame(width: 200, height: 150)
                            //.border(.blue)
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(Color.black)
                                .background(Color.white)
                                .cornerRadius(10)
                                .opacity(0.9)
                            
                            
                        }// Ende HStack
                    
                    HStack() {
                        Text("Wert des Gegenstandes: ")
                        Text("\(par1[par2].preisWert)" + "€")
                        Spacer()
                    }
                    .font(.system(size: 16, weight: .regular))
                    .frame(width:UIScreen.screenWidth / 1.1, alignment: .center)
                    .background(Color.white)
                    .padding(.leading, 15)
                    
                    HStack {
                        Text("\(vorgangDeklination(vorgang: par1[par2].vorgang))")
                        Text(" am ")
                        Text("\(par1[par2].datum)")
                        Text(" an ")
                        Spacer()
                    }
                    .font(.system(size: 16, weight: .regular))
                    .frame(width:UIScreen.screenWidth / 1.1, alignment: .center)
                    .background(Color.white)
                    .padding(.leading, 15)
                    
                    HStack {
                        Text("\(par1[par2].personVorname)" + " " + "\(par1[par2].personNachname)")
                        Spacer()
                    }
                    .font(.system(size: 16, weight: .regular))
                    .frame(width:UIScreen.screenWidth / 1.1, alignment: .center)
                    .background(Color.white)
                    .padding(.leading, 15)
                    
                    Text("\(par1[par2].allgemeinerText)")
                        .frame(width: 300, height: 150)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color.black)
                        .background(Color.white)
                        .cornerRadius(25)
                        .opacity(0.9)
                    
                    
                    
                } // Ende List
                .cornerRadius(10)
                
                    Spacer()
                    
                    HStack(alignment: .bottom) {
                        
                        Button {
                            //gegenstandHinzufuegen = true
                            
                        } label: {
                            Label("", systemImage: "doc.badge.gearshape.fill")
                            //.font(.system(size: 25))
                            
                        } // Ende Button
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color.white)
                        .offset(x: 10)
                        
                        Text("|")
                            .offset(x:3, y: -3)
                            .foregroundColor(Color.white)
                        
                        Button {
                            //gegenstandHinzufuegen = true
                            
                        } label: {
                            Label("", systemImage: "rectangle.stack.fill.badge.minus")
                            
                        } // Ende Button
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color.white)
                        .offset(x: 10)
                        
                    }// Ende HStack
                    .frame(width: UIScreen.screenWidth, height: 25, alignment: .leading)
                    .background(.gray)
                    .foregroundColor(Color.black)
                    
 
                } // Ende VStack
                .frame(width: geometry.size.width ,height: geometry.size.height * globaleVariable.heightFaktorEbene1, alignment: .center)
                .background(globaleVariable.farbenEbene1)
                .cornerRadius(10)
            
        } // Ende VStack
        .frame(width: geometry.size.width,height: geometry.size.height * globaleVariable.heightFaktorEbene0, alignment: .center)
        .background(globaleVariable.farbenEbene0)
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
    } // Ende GeometryReader
} // Ende var body
} // Ende struc Tab4


/*
// Das ist die View für detalierte Objektangaben mit Foto
struct ChartViewtemp: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    @State var par1: [ObjectVariable]
    @State var par2: Int
    
    @State var showChartHilfe: Bool = false
    
    var body: some View {
        //Form {
            VStack {
                Section(header: Text("Objektinformationen")) {
                    Text("\(par1[par2].gegenstandText)")
                        .padding(.top, 10)
                        .padding(.leading, 6)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color.black)
                        .opacity(0.9)
               } // Ende Section
                
                
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
                
                Text("\(par1[par2].preisWert)" + "€")
                Text("\(par1[par2].vorgang)")
                Text("\(par1[par2].personVorname)" + " " + "\(par1[par2].personNachname)")
                Text("\(par1[par2].allgemeinerText)")
                
            } // Ende Vstack
            .frame(width: UIScreen.screenWidth,height:UIScreen.screenHeight - 250, alignment: .leading)
            .background(Color(UIColor.lightGray))
            .cornerRadius(10)
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
        //} // Ende Form
        
    }  // Ende var body
} // Ende struckt ChartView
*/


