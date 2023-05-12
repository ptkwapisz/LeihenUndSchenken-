//
//  Test.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 13.04.23.
//

import Foundation
import SwiftUI
import PhotosUI
import SQLite3
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
    } // Ende if/else
    
    return result
} // Ende func


// Das ist die TabelenView für den Fall, dass nur einen Spieltag in ausgesuchten Saison gespielt wurde.
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
            Text("Die Tabellen können nur dann angezeigt werden, wenn mindestens ein Gegenstand gespeichert wurde. Gehen Sie bitte zu Eingabemaske zurück und geben sie den ersten Gegenstand ein. Bitte vergessen Sie nicht dann Ihre Eingaben zu speichern.")
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


