//
//  ProgressViews.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 05.01.24.
//
//  Zurzeit nicht im Gebrauch


import SwiftUI
import PDFKit








// Werte für das Progress View
// Fortschrittsverfolgung
class ProgressTracker: ObservableObject {
    static let shared = ProgressTracker()
    
    @Published var progress: Float = 0.0
    
    private init() {}
    
    func reset() {
        progress = 0.0
    }
    
    func updateProgress(_ value: Float) {
        DispatchQueue.main.async {
            self.progress = value
        }
    }
}

struct ProgressViewModalLinear: View {
    @ObservedObject var progressTracker = ProgressTracker.shared
    
    var body: some View {
        let _ = print("struct ProgressViewModalLinear wird aufgerufen")
        let _ = print(progressTracker.progress)
        
        VStack {
            ProgressView(value: progressTracker.progress, total: 1.0) {
                Text("Erstelle PDF Liste...")
            }currentValueLabel: {
                Text("\(Int(progressTracker.progress * 100))% Complete")
            }
            .progressViewStyle(LinearProgressViewStyle())
            .padding()
            
        } // Ende VStack
        .frame(width: 300, height: 100)
        .background(Color.white)
        .foregroundColor(Color.black)
        .cornerRadius(15)
        .shadow(radius: 10)
    } // Ende var body
} // Ende struct

