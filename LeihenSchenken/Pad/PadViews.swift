//
//  PadViews.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 10.05.23.
//

import Foundation
import SwiftUI


/*
struct TestTable: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    @State var personenTmp = querySQLAbfrageClassPersonen(queryTmp: "SELECT * FROM Personen")
    @State var selectedItem: PersonClassVariable.ID?
    @State private var sortOrder = [KeyPathComparator(\PersonClassVariable.personNachname)]
    
    var body: some View {
    
        
        VStack {
            Text("")
            Text("Personen").bold()
            
            Table(personenTmp, selection: $selectedItem, sortOrder: $sortOrder) {
                
                //TableColumn("perKey", value: \.perKey)
                TableColumn("Vorname", value: \.personVorname)
                TableColumn("Nachname", value: \.personNachname)
                TableColumn("Geschlecht", value: \.personSex)
                  
           
            } // Ende Table
            .onChange(of: sortOrder) {personenTmp.sort(using: $0)}
            .scrollContentBackground(.hidden)
            .listRowSeparatorTint(.gray)
            .tableStyle(InsetTableStyle())
            .font(.custom("HelveticaNeue-Medium", size: 15))
           
            
        } // Ende Vstack
        .background(globaleVariable.farbenEbene1)
        .cornerRadius(10)
        .shadow(radius: 10)
    
        
    }// Ende var body
   
    
} // Ende struct


*/
