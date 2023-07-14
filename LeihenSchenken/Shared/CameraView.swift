//
//  CameraView.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 14.07.23.
//

import SwiftUI
import UIKit
import PhotosUI
import AVFoundation

struct PhotoSelector: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @State private var image = UIImage()
    @State private var showSheet = false
    @State private var selectedPhotoData: Data?
    //@StateObject var cameraManager = CameraManager()
    
    var body: some View {
        
        Button {
            showSheet = true
        } label: {
            Label("", systemImage: "camera.on.rectangle.fill")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.blue)
        } // Ende Button
        .sheet(isPresented: $showSheet) {
            ImagePicker(sourceType: .camera, selectedImage: self.$image)
        } // Ende sheet
        .onChange(of: self.image) { newItem in
            Task {
                
                let tmp = UIImage(data: newItem.jpegData(compressionQuality: 0)!)
                let tmp2: String = (tmp?.jpegData(compressionQuality: 0.5)!.base64EncodedString())!
                
                globaleVariable.parameterImageString = tmp2
                
            } // Ende Task
            print("Foto gemacht und ausgewählt!")
        } // Ende onChange
        
    } // Ende var body
} // Ende struc



struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: UIImage
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
      
        
        return imagePicker
    } // Ende func
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    } // Ende func
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    } // Ende func
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        } // Ende init
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
                
            } // Ende if let
            
            parent.presentationMode.wrappedValue.dismiss()
            
        } // Ende func
        
    } // Ende final class

} // Ende struc

class CameraManager : ObservableObject {
    @Published var permissionGranted = false
    
    func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
            DispatchQueue.main.async {
                self.permissionGranted = accessGranted
            }
        })
    }
}
