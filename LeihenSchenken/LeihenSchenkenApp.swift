//
//  LeihenSchenkenApp.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 27.03.23.
//

import SwiftUI
import SQLite3

var db: OpaquePointer?

@main

struct LeihenSchenkenApp: App {
    var body: some Scene {
        
        //let _: Bool = ifDatabaseExist()
        
        WindowGroup {
            GeometryReader { geometry in
            
               ContentView()
                
            } // Ende GeometryReader
        } // Ende WindowGroup
    } // Ende var body
} // Ende struckt

