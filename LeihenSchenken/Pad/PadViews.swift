//
//  PadViews.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 10.05.23.
//

import Foundation
import SwiftUI

struct IpadTable2: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    @State var gegenstandeTmp = querySQLAbfrageClassGegenstaende(queryTmp: "SELECT * FROM Gegenstaende")
    @State var selectedItem: GegenstandVariable.ID?
 
    var body: some View {
        
        
        VStack {
            Text("")
            Text("Gegenstände").bold()
            
            Table(gegenstandeTmp, selection: $selectedItem) {
                
                TableColumn("perKey", value: \.perKey)
                TableColumn("Gegenstand", value: \.gegenstandName)
                  
            } // Ende Table
            .scrollContentBackground(.hidden)
            .listRowSeparatorTint(.gray)
            .font(.custom("HelveticaNeue-Medium", size: 15))
            
            HStack(alignment: .bottom) {
                Button(" + "){ // Aktion
                            
                }
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color.white)
                
                Text("|")
                
                Button(" - "){ // Aktion
                            
                }
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color.white)
                Text("|")
                
                Button(" Edit"){ // Aktion
                            
                }
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Color.white)
                
            }
            .frame(width: 395, height: 25, alignment: .leading)
            .background(.gray)
            .cornerRadius(10)
            .foregroundColor(Color.black)
            //.frame(maxWidth: .infinity, alignment: .leading)
        
        } // Ende Vstack
        .background(globaleVariable.farbenEbene1)
        .cornerRadius(10)
        .shadow(radius: 10)
    
        
    }// Ende var body
    
    
    
} // Ende struct
