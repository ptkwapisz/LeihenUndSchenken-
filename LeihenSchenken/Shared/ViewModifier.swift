//
//  ViewModifier.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 21.06.23.
//

import Foundation
import SwiftUI

struct EditFields: ViewModifier {
    func body(content: Content) -> some View {
        content
            .disableAutocorrection (true)
            .frame(width: 150, height: 30, alignment: .trailing)
            .submitLabel(.done)
            .font(.system(size: 16, weight: .regular))
            .background(Color.blue.opacity(0.4))
            .foregroundColor(.black.opacity(0.4))
            .cornerRadius(5)
            
    } // Ende func
} // Ende struct

struct ShowFields: ViewModifier {
    func body(content: Content) -> some View {
        content
            .disableAutocorrection (true)
            .frame(width: 150, height: 30, alignment: .trailing)
            .font(.system(size: 16, weight: .regular))
            .background(Color.gray).opacity(0.4)
            .cornerRadius(5)
            .textFieldStyle(.roundedBorder)
    } // Ende func
} // Ende struct

extension View {
    func modifierEditFields() -> some View {
        modifier(EditFields())
    }// Ende func
    
    func modifierShowFields() -> some View {
        modifier(ShowFields())
    }// Ende func
    
} // Ende extension

struct TextFieldEuro: ViewModifier {
    @Binding var textParameter: String
   
    func body(content: Content) -> some View {
        HStack {
            content
            //if !textParameter.isEmpty {
                Text("€")
                    .foregroundColor(.black.opacity(0.2))
                    .padding(.trailing, 5)
            //} //Ende if !text
        } // Ende HStack
    } // Ende func body
} // Ende struc
