//
//  ChartView.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 01.05.23.
//
//
//

import SwiftUI

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
    
    @State var objektEditieren: Bool = false
    
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
                                .frame(width: 200, height: 150, alignment: .topLeading)
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
                            if par1[par2].vorgang == "Bekommen" {
                               Text(" von ")
                            }else{
                                Text(" an ")
                            } // Ende if/else
                                
                            
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
                            .frame(width: 300, height: 150, alignment: .topLeading)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(Color.black)
                            .background(Color.white)
                            .cornerRadius(10)
                            .opacity(0.9)
                        
                        
                        
                    } // Ende List
                    .cornerRadius(10)
                    
                    Spacer()
                    
                    HStack(alignment: .bottom) {
                        
                        Button {
                            objektEditieren = true
                            
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
                            showAlert = true
                            //activeAlert = .delete
                            
                        } label: {
                            Label("", systemImage: "rectangle.stack.fill.badge.minus")
                            
                        } // Ende Button
                        .font(.system(size: 20, weight: .medium))
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
                            //} // Ende switch
                        } // Ende alert
                        
                    } // Ende HStack
                    .frame(width: UIScreen.screenWidth, height: 25, alignment: .leading)
                    .background(.gray)
                    .foregroundColor(Color.black)
                    .sheet(isPresented: $objektEditieren, content: { ChartViewEdit(isPresentedChartViewEdit: $objektEditieren, par1: $par1, par2: $par2)})
                    
                    
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
                    .alert("Hilfe für die Objektdeteilansicht", isPresented: $showChartHilfe, actions: {
                        Button(" - OK - ") {}
                    }, message: { Text("Das ist die Beschreibung.") } // Ende message
                    ) // Ende alert
                } // Ende ToolbarItemGroup
            } // Ende toolbar
        } // Ende GeometryReader
    } // Ende var body
} // Ende struc ChartView



// Das ist die View für bearbeitung der detalierten Objektbearbeitung mit Foto
struct ChartViewEdit: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @Binding var isPresentedChartViewEdit: Bool
    @Binding var par1: [ObjectVariable]
    @Binding var par2: Int
    
    @State var isPositionenEdit: Bool = false
    @State var showChartHilfe: Bool = false
    @State var lastText: String = ""
    
    @State private var calendarId: Int = 0
    @State var datumTmp: Date = Date()
    
    @FocusState private var focusedField: Field?
    private enum Field: Int, CaseIterable {
        case amount
        case str1 // Für Gegenstandbeschreibung
        case str2 // Für allgemeine Informationen
    } // Ende private enum
    
    var body: some View {
        
        NavigationView {
            Form {
                Section(header: Text("Objekt bearbeiten:" ).font(.system(size: 16, weight: .regular))) {
                    HStack(alignment: .center) {
                        Text("Gegenstand:")
                            .font(.callout)
                            .bold()
                        
                        Spacer()
                        
                        TextField(" ", text: $par1[par2].gegenstand)
                            .modifierEditFields()
                        
                    } // Ende HStack
                    
                    TextEditorWithPlaceholder(text: $par1[par2].gegenstandText, platz: $par1[par2].gegenstandText)
                        .focused($focusedField, equals: .str1)
                        .background(Color.blue)
                        .cornerRadius(5)
                        .opacity(0.6)
                    
                    
                    if par1[par2].gegenstandBild != "Kein Bild" {
                        Image(base64Str: par1[par2].gegenstandBild)!
                            .resizable()
                            .cornerRadius(10)
                            .padding(20)
                            .frame(width: 100, height: 100)
                    }else{
                        Text("Kein Bild")
                            .scaledToFit()
                            .padding(20)
                            .frame(width: 100, height: 100)
                            .background(Color.gray.gradient)
                            .cornerRadius(10)
                            .font(.system(size: 12, weight: .regular))
                    } // Ende if/else
                    
                    HStack {
                        Text("Neuer Wert: ")
                            .font(.callout)
                            .bold()
                        Spacer()
                        
                        TextField(" ", text: $par1[par2].preisWert)
                            .modifierEditFields()
                        /*
                         Text("\(par1[par2].preisWert)" + "€")
                         .font(.system(size: 16, weight: .regular))
                         .offset(x: 5)
                         */
                    } // Ende HStack
                    
                    HStack {
                        
                        Text("Neues Datum: ")
                            .background(Color.white)
                            .font(.callout)
                            .bold()
                        Spacer()
                        DatePicker("", selection: $datumTmp, displayedComponents: [.date])
                            .labelsHidden()
                            .background(Color.blue.opacity(0.2), in: RoundedRectangle(cornerRadius: 5))
                            .accentColor(Color.black)
                            .multilineTextAlignment (.center)
                            .environment(\.locale, Locale.init(identifier: "de"))
                            .font(.system(size: 16, weight: .regular))
                            .id(calendarId)
                            .onChange(of: datumTmp, perform: { _ in
                                calendarId += 1
                            }) // Ende onChange...
                        /*
                         .onTapGesture {
                         calendarId += 1
                         } // Ende onTap....
                         */
                    } // Ende HStack
                    
                    
                    Text("\(par1[par2].vorgang)")
                        .font(.system(size: 16, weight: .regular))
                        .offset(x: 5)
                    Text("\(par1[par2].personVorname)" + " " + "\(par1[par2].personNachname)")
                        .font(.system(size: 16, weight: .regular))
                        .offset(x: 5)
                    
                    TextEditorWithPlaceholder(text: $par1[par2].allgemeinerText, platz: $par1[par2].allgemeinerText)
                        .focused($focusedField, equals: .str2)
                        .background(Color.blue)
                        .cornerRadius(5)
                        .opacity(0.6)
                    
                } // Ende Section
                
                Section {
                    HStack {
                        Spacer()
                        Button(action: {
                            
                            isPresentedChartViewEdit = false
                            
                        }) {
                            HStack {
                                Image(systemName: "x.square.fill")
                                    .font(.system(size: 16, weight: .regular))
                                Text("Abbrechen")
                                
                            } // Ende HStack
                            
                        } // Ende Button
                        .buttonStyle(.bordered)
                        .foregroundColor(.blue)
                        .fontWeight(.semibold)
                        .font(.system(size: 16, weight: .regular))
                        
                        Button(action: {
                            
                            print(datumTmp)
                            par1[par2].datum = dateToString(parDatum: datumTmp)
                            isPresentedChartViewEdit = false
                            
                        }) {
                            HStack {
                                Image(systemName: "square.and.arrow.down.fill")
                                    .font(.system(size: 16, weight: .regular))
                                Text("Speichern")
                                
                            } // Ende HStack
                            
                        } // Ende Button
                        .buttonStyle(.borderedProminent)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .font(.system(size: 16, weight: .regular))
                        Spacer()
                    } // Ende HStack
                } // Ende Section
                
            } // Ende VStack
            .scrollContentBackground(.hidden)
            /*
             .navigationBarItems(trailing: Button( action: {
             isPresentedChartViewEdit = false
             
             }) {Image(systemName: "figure.walk.circle")
             .imageScale(.large)
             } )
             */
            .navigationBarItems(trailing: Button( action: {
                showChartHilfe = true
            }) {Image(systemName: "questionmark.circle")
                    .imageScale(.large)
            } )
            .alert("Hilfe zu Objekt Editieren", isPresented: $showChartHilfe, actions: {
                Button(" - OK - ") {}
            }, message: { Text("Das ist die Beschreibung für den Bereich Objekt Editieren.") } // Ende message
            ) // Ende alert
            
        } // Ende NavigationView
        
    }  // Ende var body
} // Ende struckt ChartViewEdit



