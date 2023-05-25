//
//  ContentView.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 27.03.23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    //@State private var columnVisibility = NavigationSplitViewVisibility.all
    
    init() {
      let coloredAppearance = UINavigationBarAppearance()
      coloredAppearance.configureWithOpaqueBackground()
      // Color für die TitleBar
      coloredAppearance.backgroundColor = .lightGray
      coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
      coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
      
      UINavigationBar.appearance().standardAppearance = coloredAppearance
      UINavigationBar.appearance().compactAppearance = coloredAppearance
      UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
      // Farbe für die MenueBar Icons
      // Diese Farbe ist auch für den fileExporter und fileImporter gültig
      UINavigationBar.appearance().tintColor = .blue
    
      UITableViewCell.appearance().backgroundColor = .clear
        
    } // Ende init
    
    
    var body: some View {
        NavigationView {
            
            ParameterView()
               
            DeteilView()
           
        } // Ende NavigationView
        .listStyle(SidebarListStyle()).font(.title3)
        .environmentObject(globaleVariable)
        .phoneOnlyStackNavigationView()

        
    } // Ende var body
} // Ende struct ContentView

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    } // Ende static var
} // Ende struct


extension View {
    @ViewBuilder func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.navigationViewStyle(.stack)
        } else {
            self
        } // Ende else
    } // Ende some View
} // Ende extension
