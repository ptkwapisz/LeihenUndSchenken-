//
//  ContentView.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 27.03.23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @ObservedObject var userSettingsDefaults = UserSettingsDefaults.shared
    
    //@State private var columnVisibility = NavigationSplitViewVisibility.all
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
        
        //UITableViewCell.appearance().backgroundColor = .clear
        /*
        // Diese drei Zeilen bestimmen die Hintergrundfarbe von dem Badge mit der Anzahl der Objekte bei der ersten TabView "Objekte"
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.stackedLayoutAppearance.normal.badgeBackgroundColor = UIColor(globaleVariable.farbenEbene0)
        UITabBar.appearance().standardAppearance = tabBarAppearance
        */
    } // Ende init
    
    var body: some View {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            NavigationStack() {
                
                DeteilView()
               
            } // Ende NavigationStack
            // Ausschalten des Dark-Modus für die App
            .preferredColorScheme(.light)
            // Das setzt die dynamische Taxtgrösse auf .large.
            .dynamicTypeSize(.large)
            .onAppear(){
                // Hier wird geprüft ob iCloud vorhanden ist
                // Wenn nicht dann wird der Switch für iCloud ausgeschaltet.
                // Das ist notwändig, weil der Switch zu UserSettings gehört
                // Und die iCloud kann auserhalb der App ausgeschaltet werden
                if isICloudContainerAvailable() == false {
                    userSettingsDefaults.iCloudSwitch = false
                } // Ende if
            
            } // Ende onApear
        }else{
            
            NavigationSplitView(columnVisibility: $globaleVariable.columnVisibility) {
             
                    EingabeMaskePhoneAndPadView()
                    //.navigationSplitViewColumnWidth(350)
                    //.frame(minWidth: 300, idealWidth: 350, maxWidth: 350, minHeight: 800, idealHeight: 835, maxHeight: 835)
                    //.offset(y: -23)
                    .applyModifier(UIDevice.current.userInterfaceIdiom == .pad){$0.toolbar(removing: .sidebarToggle)}
                
                
            } detail: {
                // NavigationStack ist notwändig, damit die Toolbars für Keyboard gezeigt werden.
                NavigationStack {
                    
                    DeteilView()
                    
                } // Ende NavigationStack
            } // Ende NavigationSplitView
            
            // Ausschalten des Dark-Modus für die App
            .preferredColorScheme(.light)
            // Das setzt die dynamische Taxtgrösse auf .large.
            .dynamicTypeSize(.large)
            .navigationSplitViewStyle(.balanced)
            .onAppear(){
                // Hier wird geprüft ob iCloud vorhanden ist
                // Wenn nicht dann wird der Switch für iCloud ausgeschaltet.
                // Das ist notwändig, weil der Switch zu UserSettings gehört
                // Und die iCloud kann auserhalb der App ausgeschaltet werden
                if isICloudContainerAvailable() == false {
                    userSettingsDefaults.iCloudSwitch = false
                } // Ende if
                
            } // Ende onApear
            
        } // Ende if/else
        
    } // Ende var body
} // Ende struct ContentView


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    } // Ende static var
} // Ende struct



