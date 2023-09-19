//
//  ParameterView.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 27.03.23.
//


import SwiftUI
import PhotosUI

struct TextEditorWithPlaceholder: View {
    @Binding var text: String
    @Binding var platz: String
    
    @State var lastText: String = ""
    
    @FocusState private var textIsFocussed: Bool
    
    @State var totalCHarsText: Int = 100
    var body: some View {
        let _ = print("Struckt TextEditorWithPlaceHolder wird aufgerufen!")
        
        NavigationStack {
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    VStack {
                        Text("\(platz)")
                            .padding(.top, 10)
                            .padding(.leading, 6)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(Color.black)
                            .opacity(0.6)
                        Spacer()
                    } // Ende VStack
                } // Ende if
                
                VStack {
                    TextField("\(platz)", text: $text, axis: .vertical)
                        .focused($textIsFocussed)
                        .font(.system(size: 16, weight: .regular))
                        .cornerRadius(5)
                        .disableAutocorrection(true)
                        .lineLimit(3, reservesSpace: true)
                        .textFieldStyle(.roundedBorder)
                        .submitLabel(.done)
                        .onChange(of: text, perform: { newValue in
                            if newValue.count <= 100 {
                                lastText = newValue
                                //print(lastText.count)
                            }else{
                                self.text = lastText
                            } // Ende else
                            
                            guard let newValueLastChar = newValue.last else { return }
                            
                            if newValueLastChar == "\n" {
                                text.removeLast()
                                textIsFocussed = false
                            } // Ende if
                            
                        }) // Ende onChange
                    
                } // Ende VStack
                
            } // Ende ZStack
        } // Ende NavigationStack
    }// Ende var body
}// Ende struckt


struct ImageSelector: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedPhotoData: Data?
    let filter: PHPickerFilter = .not(.any( of: [
        .videos,
        .slomoVideos,
        .bursts,
        .livePhotos,
        .screenRecordings,
        .cinematicVideos,
        .timelapseVideos,
        .screenshots,
        .depthEffectPhotos
    ]))
    
    var body: some View {
        
        PhotosPicker(selection: $selectedItem, matching: filter, photoLibrary: .shared()) {
                    Image(systemName: "photo.fill.on.rectangle.fill")
                        .symbolRenderingMode(.multicolor)
                        .font(.system(size: 30))
                        .foregroundColor(.accentColor)
                } // Ende PhotoPicker
                .buttonStyle(.borderless)
                .onChange(of: selectedItem) { newItem in
                    Task {
                        
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                           selectedPhotoData = data
                           
                        } // Ende if let
                        
                        if let selectedPhotoData, let _ = UIImage(data: selectedPhotoData) {
                            // Transferiere Photo in ein jpgPhoto
                            let tmpPhoto = UIImage(data: selectedPhotoData)?.jpegData(compressionQuality: 0.5)
                            // transferiere jpgPhoto in String
                            globaleVariable.parameterImageString = tmpPhoto!.base64EncodedString()
                         
                            print("Photo wurde ausgewählt")
                        } // Ende if
                        
                    } // Ende Task
                } // Ende onChange
    } // Ende var body
} //Ende struckt PhotoSelector






