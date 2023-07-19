//
//  ChartView.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 01.05.23.
//
//
//

import SwiftUI
import UIKit

// Das ist die View für detalierte Objektangaben mit Foto
struct ChartView: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var par1: [ObjectVariable]
    @State var par2: Int
    
    @State var showChartHilfe: Bool = false
    
    @State var errorMessageText: String = ""
    @State private var showAlert: Bool = false
    @State private var activeAlert: ActiveAlert = .error
    @State var showDetailPhoto: Bool = false
    @State var objektEditieren: Bool = false
    
    let heightFaktor: Double = 0.99
    
    @State var isPresentedTestView: Bool = true
    
    var body: some View {
      
            GeometryReader { geometry in
                
                VStack {
                    VStack {
                        Text("")
                        Text("Objektdeteilansicht").bold()
                        
                        List {
                            
                            HStack {
                                
                                if par1[par2].gegenstandBild != "Kein Bild" {
                                    
                                    Button {
                                        showDetailPhoto = true
                                        print("Show Photo")
                                    } label: {
                                        Image(base64Str: par1[par2].gegenstandBild)!
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 150, height: 150)
                                            .clipped()
                                            .cornerRadius(10)
                                            .padding(5)
                                    } // Ende label
                                    
                                    
                                }else{
                                    Text("Kein Bild")
                                        .scaledToFit()
                                        .padding(20)
                                        .frame(width: 150, height: 150)
                                        .background(Color.gray.gradient)
                                        .cornerRadius(10)
                                    
                                } // Ende if/else
                                
                                
                                Text("\(par1[par2].gegenstandText)")
                                    .padding(.top, 10)
                                    .padding(.leading, 6)
                                    .frame(width: 160, height: 150, alignment: .topLeading)
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(Color.black)
                                    .background(Color(UIColor.lightGray)).opacity(0.4)
                                    .cornerRadius(10)
                                    .opacity(0.9)
                                
                                
                            }// Ende HStack
                            
                            
                            HStack {
                                Text("Wert des Gegenstandes: ")
                                Spacer()
                                Text("\(par1[par2].preisWert)" + "€ ")
                                    .modifierShowFields()
                                
                                
                            } // Ende Hstack
                            .font(.system(size: 16, weight: .regular))
                            //.frame(width:UIScreen.screenWidth / 1.1, alignment: .center)
                            //.background(Color.white)
                            //.padding(.leading, 15)
                            
                            HStack {
                                Text("\(vorgangDeklination(vorgang: par1[par2].vorgang))")
                                Text(" am ")
                                Spacer()
                                Text("\(par1[par2].datum) ")
                                    .modifierShowFields()
                                
                                
                            } // Ende HStack
                            .font(.system(size: 16, weight: .regular))
                            //.frame(width:UIScreen.screenWidth / 1.1, alignment: .center)
                            //.background(Color.white)
                            //.padding(.leading, 15)
                            
                            HStack {
                                if par1[par2].vorgang == "Bekommen" {
                                    Text(" von ")
                                }else{
                                    Text(" an ")
                                } // Ende if/else
                                Spacer()
                                Text("\(par1[par2].personNachname)" + ", " + "\(par1[par2].personVorname)" + " ")
                                    .modifierShowFields()
                            } // Ende HStack
                            .font(.system(size: 16, weight: .regular))
                            //.frame(width:UIScreen.screenWidth / 1.1, alignment: .center)
                            //.background(Color.white)
                            //.padding(.leading, 15)
                            
                            Text("\(par1[par2].allgemeinerText)")
                                .padding(.top, 10)
                                .padding(.leading, 6)
                                .frame(width: 320, height: 150, alignment: .topLeading)
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(Color.black)
                                .background(Color(UIColor.lightGray)).opacity(0.4)
                                .cornerRadius(10)
                                .opacity(0.9)
                            
                            /*
                             .frame(width: 300, height: 150, alignment: .topLeading)
                             .font(.system(size: 16, weight: .regular))
                             .foregroundColor(Color.black)
                             .background(Color.white)
                             .cornerRadius(10)
                             .opacity(0.9)
                             */
                        } // Ende List
                        .cornerRadius(10)
                        
                        Spacer()
                        
                        HStack(alignment: .bottom) {
                            
                            Button {
                                objektEditieren = true
                                
                            } label: {
                                Label("", systemImage: "pencil.and.outline") //doc.badge.gearshape.fill
                                //.font(.system(size: 25))
                                
                            } // Ende Button
                            .font(.system(size: 30, weight: .medium))
                            .foregroundColor(Color.white)
                            .offset(x: 10)
                            
                            Text("|")
                                .offset(x:3, y: -7)
                                .foregroundColor(Color.white)
                            
                            Button {
                                showAlert = true
                                //activeAlert = .delete
                                
                            } label: {
                                Label("", systemImage: "rectangle.stack.fill.badge.minus")
                                
                            } // Ende Button
                            .font(.system(size: 30, weight: .medium))
                            .foregroundColor(Color.white)
                            .offset(x: 10)
                            .alert(isPresented: $showAlert) {
                                Alert( title: Text("Wichtige Information!"),
                                       message: Text("Das Objekt: \(par1[par2].gegenstand) wird unwiederfuflich gelöscht! Man kann diesen Vorgang nicht rückgängich machen!"),
                                       primaryButton: .destructive(Text("Löschen")) {
                                    
                                    let perKeyTmp = par1[par2].perKey
                                    deleteItemsFromDatabase(tabelle: "Objekte", perKey: perKeyTmp)
                                    print("\(par1[par2].gegenstand)" + " wurde gelöscht")
                                    print(perKeyTmp)
                                    globaleVariable.navigationTabView = 1
                                    refreshAllViews()
                                    showAlert = false
                                    // Diese Zeile bewirkt, dass die View geschlossen wird
                                    self.presentationMode.wrappedValue.dismiss()
                                },
                                    secondaryButton: .cancel(Text("Abbrechen")){
                                    print("\(par1[par2].gegenstand)" + " wurde nicht gelöscht")
                                    print("Abgebrochen ....")
                                    refreshAllViews()
                                    showAlert = false
                                } // Ende secondary Button
                                       
                                ) // Ende Alert
                                
                            } // Ende alert
                            
                        } // Ende HStack
                        .frame(width: UIScreen.screenWidth, height: 34, alignment: .leading)
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
                .navigationBarItems(trailing: Button( action: {
                    showChartHilfe = true
                }) {Image(systemName: "questionmark.circle.fill")
                        .imageScale(.large)
                } )
                .alert("Hilfe für die Objektdeteilansicht", isPresented: $showChartHilfe, actions: {
                    Button(" - OK - ") {}
                }, message: { Text("Das ist die Beschreibung für den Bereich Objektdeteilansicht.") } // Ende message
                ) // Ende alert
                
               
            } // Ende GeometryReader
            .sheet(isPresented: $objektEditieren, content: {EditSheetView(isPresentedChartViewEdit: $objektEditieren, par1: $par1, par2: $par2)})
        
            .sheet(isPresented: $showDetailPhoto, content: { ShapeShowDetailPhoto(isPresentedShowDetailPhoto: $showDetailPhoto, par1: $par1, par2: $par2)})
    } // Ende var body
} // Ende struc ChartView

