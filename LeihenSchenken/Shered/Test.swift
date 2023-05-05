//
//  Test.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 13.04.23.
//

import Foundation
import SwiftUI
import PhotosUI

/*
extension UIImage {
    func aspectFittedToHeight(_ newHeight: CGFloat) -> UIImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: newSize)

        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}

func compressImage(image: UIImage) -> UIImage {
        let resizedImage = image.aspectFittedToHeight(50)
        resizedImage.jpegData(compressionQuality: 0.2) // Add this line

        return resizedImage
}
*/

func dateToString(parDatum: Date) -> String {
    
    var result: String = ""
    
    let inputDateString = parDatum

    let germanDateFormatter = DateFormatter()
    germanDateFormatter.locale = .init(identifier: "de")
    germanDateFormatter.dateFormat = "d MMM yyyy"
    germanDateFormatter.dateStyle = .short
    germanDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

    if inputDateString != nil {

        result = germanDateFormatter.string(from: inputDateString)

        print(result) //16.08.19, 07:04:12
    }else{
        
        result = "Keine umwandlung"
    }
    
    return result
}


