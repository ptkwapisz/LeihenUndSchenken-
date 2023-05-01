//
//  ColorData.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 27.03.23.
//

import Foundation
import SwiftUI

struct ColorData {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    private var COLOR_KEY0 = "COLOR_KEY0"
    private var COLOR_KEY1 = "COLOR_KEY1"
    
    private let userDefaults = UserDefaults.standard
    
    func saveColor(color0: Color, color1: Color) {
        let color0 = UIColor(color0).cgColor
        let color1 = UIColor(color1).cgColor
        
        if let components0 = color0.components {
            userDefaults.set(components0, forKey: COLOR_KEY0)
            print(components0)
            print("Color Ebene 0 saved!")
        } // Ende if let
        
        if let components1 = color1.components {
            userDefaults.set(components1, forKey: COLOR_KEY1)
            print(components1)
            print("Color Ebene 1 saved!")
        } // Ende if let
      
    } // Ende func saveColor

    func loadColor0() -> Color {
        
        guard let array0 = userDefaults.object(forKey: COLOR_KEY0) as? [CGFloat] else {return Color.gray}
        let color0 = Color(.sRGB, red: array0[0], green: array0[1], blue: array0[2], opacity: array0[3])
        print(color0)
        print("Color Ebene 0 loaded! Funktion: loadColor0")
        return color0
    } // Ende func loadColor
    
    func loadColor1() -> Color {
        
        guard let array1 = userDefaults.object(forKey: COLOR_KEY1) as? [CGFloat] else {return Color.blue}
        let color1 = Color(.sRGB, red: array1[0], green: array1[1], blue: array1[2], opacity: array1[3])
        print(color1)
        print("Color Ebene 1 loaded! Funktion: loadColor1")
        return color1
    } // Ende func loadColor
    

} // Ende struc ColorData

func loadColor0A() -> Color {
    let COLOR_KEY0 = "COLOR_KEY0"
    
    let userDefaults = UserDefaults.standard
    
    guard let array0 = userDefaults.object(forKey: COLOR_KEY0) as? [CGFloat] else {return Color.blue}
    let color0 = Color(.sRGB, red: array0[0], green: array0[1], blue: array0[2], opacity: array0[3])
    print(color0)
    print("Color Ebene 0 loaded! Funktion: loadColor0A")
    return color0
} // Ende func loadColor


func loadColor1B() -> Color {
    let COLOR_KEY1 = "COLOR_KEY1"
    
    let userDefaults = UserDefaults.standard
    guard let array1 = userDefaults.object(forKey: COLOR_KEY1) as? [CGFloat] else {return Color.green}
    let color1 = Color(.sRGB, red: array1[0], green: array1[1], blue: array1[2], opacity: array1[3])
    print(color1)
    print("Color Ebene 1 loaded! Funktion: loadColor1B")
    return color1
} // Ende func loadColor

func saveColors(color0: Color, color1: Color) {
    let COLOR_KEY0 = "COLOR_KEY0"
    let COLOR_KEY1 = "COLOR_KEY1"
    
    let userDefaults = UserDefaults.standard
    
    let color0 = UIColor(color0).cgColor
    let color1 = UIColor(color1).cgColor
    
    if let components0 = color0.components {
        userDefaults.set(components0, forKey: COLOR_KEY0)
        print(components0)
        print("Color Ebene 0 saved!")
    } // Ende if let
    
    if let components1 = color1.components {
        userDefaults.set(components1, forKey: COLOR_KEY1)
        print(components1)
        print("Color Ebene 1 saved!")
    } // Ende if let
  
} // Ende func saveColor
