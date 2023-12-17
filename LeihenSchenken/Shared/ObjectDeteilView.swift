//
//  ObjectDeteilView.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 09.12.23.
//

import SwiftUI
//import Foundation

// Das ist die View für detalierte Objektangaben mit Foto
struct ObjectDeteilView: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @ObservedObject var userSettingsDefaults = UserSettingsDefaults.shared
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var par1: [ObjectVariable]
    @State var par2: Int
    
    @State var showChartHilfe: Bool = false
    
    @State var errorMessageText: String = ""
    @State private var showAlert: Bool = false
    
    @State var showDetailPhoto: Bool = false
    @State var objektEditieren: Bool = false
    
    let heightFaktor: Double = 0.99
    
    @State var isPresentedTestView: Bool = true
    
    var body: some View {
        
        GeometryReader { geometry in
            
            let gegenstandTextWidth = geometry.size.width / 2.6
            let allgemeinerTextWidth = geometry.size.width / 1.25
            
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
                                        .padding(5)
                                        .border(.blue, width: 4)
                                        .cornerRadius(10)
                                    
                                } // Ende label
                                //.buttonStyle(.bordered)
                                //.tint(.blue)
                                
                            }else{
                                Text("Kein Bild")
                                    .scaledToFit()
                                    .padding(20)
                                    .frame(width: 150, height: 150)
                                    .background(Color.gray.gradient)
                                    .cornerRadius(10)
                                
                            } // Ende if/else
                            
                            Spacer()
                            
                            Text("\(par1[par2].gegenstandText)")
                                .padding(.top, 10)
                                .padding(.leading, 6)
                                .frame(width: gegenstandTextWidth, height: 150, alignment: .topLeading) // - 230
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
                        
                        HStack {
                            Text("\(vorgangDeklination(vorgang: par1[par2].vorgang))")
                            Text(" am ")
                            Spacer()
                            Text("\(par1[par2].datum) ")
                                .modifierShowFields()
                            
                            
                        } // Ende HStack
                        .font(.system(size: 16, weight: .regular))
                        
                        HStack {
                            let textPrefix = vorgangPrefixDeklination(vorgang: par1[par2].vorgang )
                            Text("\(textPrefix)")
                            Spacer()
                            Text("\(par1[par2].personNachname)" + ", " + "\(par1[par2].personVorname)" + " ")
                                .modifierShowFields()
                        } // Ende HStack
                        .font(.system(size: 16, weight: .regular))
                        
                        Text("\(par1[par2].allgemeinerText)")
                            .padding(.top, 10)
                            .padding(.leading, 6)
                            .frame(width: allgemeinerTextWidth, height: 150, alignment: .topLeading)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(Color.black)
                            .background(Color(UIColor.lightGray)).opacity(0.4)
                            .cornerRadius(10)
                            .opacity(0.9)
                        
                        
                        if UIDevice.current.userInterfaceIdiom != .phone {
                            HStack {
                                Spacer()
                                Button {
                                    self.presentationMode.wrappedValue.dismiss()
                                    if UIDevice.current.userInterfaceIdiom == .pad {
                                        globaleVariable.columnVisibility = .all
                                    }
                                } label: {
                                    Label("Objektsicht verlassen", systemImage: "arrowshape.turn.up.backward.circle")
                                    
                                } // Ende Button
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color.white)
                                //.buttonStyle(.bordered)
                                .buttonStyle(.borderedProminent)
                                Spacer()
                            } // Ende HStack
                            
                        } // Ende if UIDevice
                        
                    } // Ende List
                    .cornerRadius(10)
                    
                    Spacer()
                    
                } // Ende VStack
                .frame(width: geometry.size.width, height: geometry.size.height * globaleVariable.heightFaktorEbene1, alignment: .center)
                .background(globaleVariable.farbenEbene1)
                .cornerRadius(10)
                
            } // Ende VStack
            .frame(width: geometry.size.width, height: geometry.size.height * globaleVariable.heightFaktorEbene0, alignment: .center)
            .background(globaleVariable.farbenEbene0)
            .navigationTitle("\(par1[par2].gegenstand)")
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    
                    Button( action: {
                        objektEditieren = true
                    }) {Image(systemName: "pencil")
                            .imageScale(.large)
                    } // Ende Image
                    
                } // Ende ToolbarGroup
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    
                    Button( action: {
                        showAlert = true
                    }) {Image(systemName: "trash")
                            .imageScale(.large)
                    } // Ende Image
                    .alert(isPresented: $showAlert) {
                        Alert( title: Text("Wichtige Information!"),
                               message: Text("Das Objekt: \(par1[par2].gegenstand) wird unwiederuflich gelöscht! Man kann diesen Vorgang nicht rückgängich machen!"),
                               primaryButton: .destructive(Text("Löschen")) {
                            
                            let perKeyTmp = par1[par2].perKey
                            deleteItemsFromDatabase(tabelle: "Objekte", perKey: perKeyTmp)
                            print("\(par1[par2].gegenstand)" + " wurde gelöscht")
                            print(perKeyTmp)
                            globaleVariable.navigationTabView = 1
                            refreshAllViews()
                            globaleVariable.numberOfObjects = anzahlDerDatensaetze(tableName: "Objekte")
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
                    
                    
                } // Ende ToolbarGroup
                
                
                if userSettingsDefaults.showHandbuch == true {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        
                        Button( action: {
                            showChartHilfe = true
                        }) {Image(systemName: "questionmark.circle.fill")
                                .imageScale(.large)
                        } // Ende Image
                        
                    } // Ende ToolbarGroup
                } // Ende if
            } // Ende toolbar
            
        } // Ende GeometryReader
        .sheet(isPresented: $showDetailPhoto, content: { ShapeShowDetailPhoto(isPresentedShowDetailPhoto: $showDetailPhoto, par1: $par1, par2: $par2)})
        .applyIf(UIDevice.current.userInterfaceIdiom == .phone,
                 apply: {
            $0.navigationDestination(isPresented: $objektEditieren, destination:{EditSheetView(isPresentedChartViewEdit: $objektEditieren, par1: $par1, par2: $par2)
                    .navigationBarBackButtonHidden()
                //.navigationBarTitleDisplayMode(.inline)
                
            })
        }, else: {
            $0.sheet(isPresented: $objektEditieren, content: {EditSheetView(isPresentedChartViewEdit: $objektEditieren, par1: $par1, par2: $par2)
            })
        }) // Ende applyIf
        .onAppear{
            if UIDevice.current.userInterfaceIdiom == .pad {
                globaleVariable.columnVisibility = .detailOnly
            } // Ende if
        } // Ende onAppear
        .alert("Hilfe für die Objektdeteilansicht", isPresented: $showChartHilfe, actions: {}, message: { Text("Diese Objektdeteilansicht zeigt alle Daten eines Objektes. Falls das Foto vorhanden ist, können Sie durch das drücken auf das Bild eine vergröserte Ansicht dieses Bildes aufrufen. Unten links befindeen sich zwei Tasten: eine mit dem Kreis und Stift Symbol. Wenn Sie drauf drücken können Sie die Daten des Objektes bearbeiten. Mit der andren Taste mit dem Stappelzeichen und einem 'Minus' Symbol können Sie das Objekt löschen.") } // Ende message
        ) // Ende alert
        
        
        //} // Ende NavigationStack
    } // Ende var body
} // Ende struc ChartView

