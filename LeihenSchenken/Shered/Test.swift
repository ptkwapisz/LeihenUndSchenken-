//
//  Test.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 20.05.23.
//
import SwiftUI
import Foundation


struct EmptyView: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    var breite: CGFloat = 370
    var hoehe: CGFloat = 320

    var body: some View {
        ZStack{
        VStack{
            Text("Info zu Tabellen").bold()
                .font(.title2)
                .frame(alignment: .center)

            Divider().background(Color.black)
            Text("")
            Text("Die Tabellen können nur dann angezeigt werden, wenn mindestens ein Gegenstand gespeichert wurde. Gehen Sie bitte zu Eingabemaske zurück und geben sie den ersten Gegenstand ein. Bitte vergessen Sie nicht dann Ihre Eingaben zu speichern. Danach können Sie die Tabellen sehen.")
                .font(.system(size: 18))
             Spacer()

        } // Ende Vstack
        //.frame(width: breite, height: hoehe, alignment: .leading)
        .padding(EdgeInsets(top: 40, leading: 20, bottom: 30, trailing: 20))
        .frame(width: breite, height: hoehe, alignment: .leading)
        .background(Color.gray.gradient)
        .cornerRadius(10.0)
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 15.0)
        }
    } // Ende var body
        
} // Ende struct

