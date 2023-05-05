//
//  Extention.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 03.05.23.
//

import SwiftUI
import Foundation



// Diese Erweiterung endcodiert Image-String in ein Image
// Benutzung: Image(base64Str: imgString)

extension Image {
    init?(base64Str: String) {
        guard let data = Data(base64Encoded: base64Str) else { return nil }
        guard let uiImg = UIImage(data: data) else { return nil }
        self = Image(uiImage: uiImg)
    } // Ende init
} // Ende extension
