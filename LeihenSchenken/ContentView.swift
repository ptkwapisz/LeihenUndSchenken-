//
//  ContentView.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 27.03.23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @State private var columnVisibility = NavigationSplitViewVisibility.all
    //@State private var preferredColumn = NavigationSplitViewColumn.detail
    @State private var emptyDatabase:Bool = false
    
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
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            NavigationStack{
                
                DeteilView()
                
            } // Ende NavigationStack
            .listStyle(SidebarListStyle()).font(.title3) // Veraltet mit Navigationview
            .environmentObject(globaleVariable)
            .phoneOnlyStackNavigationView()
            // Ausschalten des Dark-Modus für die App
            .preferredColorScheme(.light)
            // Das setzt die dynamische Taxtgrösse auf .large.
            .dynamicTypeSize(.large)
            
        }else{
            
            NavigationSplitView(columnVisibility: $columnVisibility) {
                
                EingabeMaskePadView()
            } detail: {
                DeteilView()
                
            } // Ende NavigationSplitView
            .environmentObject(globaleVariable)
            .phoneOnlyStackNavigationView()
            // Ausschalten des Dark-Modus für die App
            .preferredColorScheme(.light)
            // Das setzt die dynamische Taxtgrösse auf .large.
            .dynamicTypeSize(.large)
            .navigationSplitViewStyle(.balanced)
            
        } // Ende if/else
        
   
    } // Ende var body
} // Ende struct ContentView

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    } // Ende static var
} // Ende struct



