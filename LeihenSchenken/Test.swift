//
//  Test.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 13.04.23.
//

import Foundation
import SwiftUI

/*
struct TestKeyboard: View {
    @State var str: String = ""
    @State var num: Float = 1.2
    
    @FocusState private var focusedField: Field?
    private enum Field: Int, CaseIterable {
        case amount
        case str
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            TextField("A text field here", text: $str)
                .focused($focusedField, equals: .str)
            
            TextField("", value: $num, formatter: FloatNumberFormatter())
                .focused($focusedField, equals: .amount)
                .keyboardType(.decimalPad)
            
            Spacer()
        }
        .toolbar {          // << here !!
            ToolbarItem(placement: .keyboard) {
                if focusedField == .amount {             // << here !!
                    Button("Done") {
                        focusedField = nil
                    }
                }
            }
        }
        
    }
}

class FloatNumberFormatter: NumberFormatter {
    override init() {
        super.init()
        
        self.numberStyle = .currency
        self.currencySymbol = "€"
        self.minimumFractionDigits = 2
        self.maximumFractionDigits = 2
        self.locale = Locale.current
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
*/
