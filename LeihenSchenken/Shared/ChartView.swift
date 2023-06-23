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
                                Text("\(par1[par2].personVorname)" + " " + "\(par1[par2].personNachname)" + " ")
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
                                
                            } // Ende alert
                            
                        } // Ende HStack
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
                
                //.scrollContentBackground(.hidden)
                .navigationBarItems(trailing: Button( action: {
                    showChartHilfe = true
                }) {Image(systemName: "questionmark.circle.fill")
                        .imageScale(.large)
                } )
                .alert("Hilfe für die Objektdeteilansicht", isPresented: $showChartHilfe, actions: {
                    Button(" - OK - ") {}
                }, message: { Text("Das ist die Beschreibung für den Bereich Objektdeteilansicht.") } // Ende message
                ) // Ende alert
                
                /*
                 .toolbar {
                 ToolbarItemGroup(placement: .navigationBarTrailing) {
                 Button(action:{showChartHilfe.toggle()
                 
                 }) {
                 Image(systemName: "questionmark.circle.fill")
                 } // Ende Button
                 .alert("Hilfe für die Objektdeteilansicht", isPresented: $showChartHilfe, actions: {
                 Button(" - OK - ") {}
                 }, message: { Text("Das ist die Beschreibung.") } // Ende message
                 ) // Ende alert
                 } // Ende ToolbarItemGroup
                 } // Ende toolbar
                 */
               
            } // Ende GeometryReader
            //.sheet(isPresented: $objektEditieren, content: { ChartViewEdit(isPresentedChartViewEdit: $objektEditieren, par1: $par1, par2: $par2)})
            .sheet(isPresented: $objektEditieren, content: { EditSheetView(isPresentedChartViewEdit: $objektEditieren, par1: $par1, par2: $par2)})
        
    } // Ende var body
} // Ende struc ChartView

/*

// Das ist die View für bearbeitung der detalierten Objektbearbeitung mit Foto
struct ChartViewEdit: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    @Binding var isPresentedChartViewEdit: Bool
    @Binding var par1: [ObjectVariable]
    @Binding var par2: Int
    
    @State var showChartHilfe: Bool = false
    @State var lastText: String = ""
    
    @State var calendarId: Int = 0
    
    @State var datumTmp: Date = Date()
    
    private enum FocusedField: Int, CaseIterable {
        case preisWert // Für Preis/Wert
        case strGegenstand // Für Gegenstand
        case strGegenstandText // Für GegenstandText
        case strAllgemeinerText // Für allgemeine Informationen
    } // Ende private enum
    
    @FocusState private var focusedFeld: FocusedField?
    
    
    var body: some View {
        
        let datumTmpArray = querySQLAbfrageArray(queryTmp: "Select datum From Objekte Where perKey = '\(par1[par2].perKey)'")
        let datumTmpString = datumTmpArray[0]
        
        NavigationStack {
            
            Form {
                
                    Section(header: Text("Objekt bearbeiten:" ).font(.system(size: 16, weight: .regular)).bold()) {
                        HStack(alignment: .center) {
                            Text("Gegenstand:")
                                .font(.callout)
                                .bold()
                            
                            Spacer()
                            
                            TextField(" ", text: $par1[par2].gegenstand)
                                .focused($focusedFeld, equals: .strGegenstand)
                                .disableAutocorrection(true)
                                .submitLabel(.done)
                                .modifierEditFields()
                                
                        } // Ende HStack
                        
                        TextEditorWithPlaceholder(text: $par1[par2].gegenstandText, platz: $par1[par2].gegenstandText)
                            .focused($focusedFeld, equals: .strGegenstandText)
                            .background(Color.blue)
                            .cornerRadius(5)
                            .opacity(0.6)
                        
                        
                        if par1[par2].gegenstandBild != "Kein Bild" {
                            Image(base64Str: par1[par2].gegenstandBild)!
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipped()
                                .cornerRadius(10)
                                .padding(5)
                            
                        }else{
                            Text("Kein Bild")
                                .scaledToFit()
                                .padding(20)
                                .frame(width: 100, height: 100)
                                .background(Color.gray.gradient)
                                .cornerRadius(10)
                            
                        } // Ende if/else
                        
                        HStack {
                            Text("Neuer Wert: ")
                                .font(.callout)
                                .bold()
                            Spacer()
                            
                            TextField(" ", text: $par1[par2].preisWert)
                                .focused($focusedFeld, equals: .preisWert)
                                .keyboardType(.decimalPad)
                                .modifierEditFields()
                            
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
                                .multilineTextAlignment (.center)
                                .environment(\.locale, Locale.init(identifier: "de"))
                                .font(.system(size: 16, weight: .regular))
                                .id(calendarId)
                                .onChange(of: datumTmp, perform: { _ in
                                    calendarId += 1
                                }) // Ende onChange...
                                .onAppear{
                                    datumTmp = stringToDate(parDatum: "\(datumTmpString)")
                                } // Ende onAppear
                            
                        } // Ende HStack
                    
                        
                        Text("\(par1[par2].vorgang)")
                            .font(.system(size: 16, weight: .regular))
                            .offset(x: 5)
                        Text("\(par1[par2].personVorname)" + " " + "\(par1[par2].personNachname)")
                            .font(.system(size: 16, weight: .regular))
                            .offset(x: 5)
                        
                        TextEditorWithPlaceholder(text: $par1[par2].allgemeinerText, platz: $par1[par2].allgemeinerText)
                            .focused($focusedFeld, equals: .strAllgemeinerText)
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
                                    //Image(systemName: "x.square.fill")
                                    //  .font(.system(size: 16, weight: .regular))
                                    Text("Abbrechen")
                                    
                                } // Ende HStack
                                
                            } // Ende Button
                            .buttonStyle(.bordered)
                            .foregroundColor(.blue)
                            .fontWeight(.semibold)
                            .font(.system(size: 16, weight: .regular))
                            
                            Button(action: {
                                
                                print(datumTmp)
                                
                                updateSqliteTabellenField(sqliteFeld: "gegenstand", neueInhalt: par1[par2].gegenstand, perKey: par1[par2].perKey)
                                
                                par1[par2].datum = dateToString(parDatum: datumTmp)
                                updateSqliteTabellenField(sqliteFeld: "datum", neueInhalt: par1[par2].datum, perKey: par1[par2].perKey)
                                
                                updateSqliteTabellenField(sqliteFeld: "gegenstandText", neueInhalt: par1[par2].gegenstandText, perKey: par1[par2].perKey)
                                
                                updateSqliteTabellenField(sqliteFeld: "allgemeinerText", neueInhalt: par1[par2].allgemeinerText, perKey: par1[par2].perKey)
                                
                                refreshAllViews()
                                isPresentedChartViewEdit = false
                                
                            }) {
                                HStack {
                                    //Image(systemName: "square.and.arrow.down.fill")
                                    //  .font(.system(size: 16, weight: .regular))
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
                
                
            } // Ende Form
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    
                    if focusedFeld == .preisWert {
                        
                        Spacer()
                        Button("Fertig") {
                            
                            focusedFeld = nil
                            
                            print("Fertig Button (numerische Tastatur) wurde gedrückt!")
                        } // Ende Button
                        
                    }else if focusedFeld == .strGegenstand {
                        
                        HStack {
                            Text("\(par1[par2].gegenstand.count)/20")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.gray)
                                .padding()
                            Spacer()
                            Button("Abbrechen") {
                                
                                focusedFeld = nil
                                
                                print("Abbrechen Button StrGegenstand wurde gedrückt!")
                            } // Ende Button
                            .font(.system(size: 16, weight: .regular))
                            .onSubmit {
                                focusedFeld = nil
                            }
                        } // Ende HStack
                        
                    }else if focusedFeld == .strGegenstandText {
                        
                        HStack {
                            Text("\(par1[par2].gegenstandText.count)/100")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.gray)
                                .padding()
                            Spacer()
                            Button("Abbrechen") {
                                
                                focusedFeld = nil
                                
                                print("Abbrechen Button StrGegenstandText wurde gedrückt!")
                            } // Ende Button
                            .font(.system(size: 16, weight: .regular))
                        } // Ende HStack
                        
                    }else if focusedFeld == .strAllgemeinerText {
                        
                        HStack{
                            Text("\(par1[par2].allgemeinerText.count)/100")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.gray)
                            Spacer()
                            Button("Abbrechen") {
                                
                                focusedFeld = nil
                                
                                print("Abbrechen Button StrAllgemeinerText wurde gedrückt!")
                            } // Ende Button
                        } // Ende HStack
                   
                        
                    } // Ende if/else
                        
                    
                } // Ende ToolbarItemGroup
            } // Ende toolbar
            
           .scrollContentBackground(.hidden)
            .navigationBarItems(trailing: Button( action: {
                showChartHilfe = true
            }) {Image(systemName: "questionmark.circle.fill")
                    .imageScale(.large)
            } )
          
            .alert("Hilfe zu Objekt Editieren", isPresented: $showChartHilfe, actions: {
                Button(" - OK - ") {}
            }, message: { Text("Das ist die Beschreibung für den Bereich Objekt Editieren.") } // Ende message
            ) // Ende alert
            
            
        } // Ende NavigationStack
       
    }  // Ende var body
} // Ende struckt ChartViewEdit
*/
