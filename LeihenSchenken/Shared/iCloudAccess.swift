//
//  iCloudAccess.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 30.07.23.
//

import SwiftUI
import Foundation


// Prüfen ob iCloud ist verfügbar
// Wenn User nicht eingelogt ist, dann return ist false
func isICloudContainerAvailable() -> Bool {
    
    if let _ = FileManager.default.ubiquityIdentityToken {
        print("iCloud vorhanden")
        return true
        
    } else {
        print("iCloud nicht vorhanden")
        return false
        
    } // Ende if/else
    
} // Ende func

