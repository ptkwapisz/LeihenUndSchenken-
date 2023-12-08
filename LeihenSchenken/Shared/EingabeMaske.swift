//
//  EingabeMaske.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 24.09.23.
//

import SwiftUI
import PhotosUI
import SQLite3
import Combine


struct EingabeMaskePhoneAndPadView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode> // Only in iPhon
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @ObservedObject var userSettingsDefaults = UserSettingsDefaults.shared
    
    //@ObservedObject var hilfeTexte = HilfeTexte.shared
    //@ObservedObject var alertMessageTexte = AlertMessageTexte.shared
    
    @StateObject var cameraManager = CameraManager()
    @State var alertMessageTexte = AlertMessageTexte()
    
    @State var hilfeTexte = HilfeTexte()
    
    @State var showParameterHilfe: Bool = false
    //@State var showParameterAllgemeinesInfo: Bool = false // Only in iPhon
    //@State var showAlerOKButton: Bool = false
    @State var showAlertAbbrechenButton: Bool = false
    @State var showAlertSpeichernButton: Bool = false
    @State var showSheetPerson: Bool = false
    @State var showSheetGegenstand: Bool = false
    @State var isParameterBereich: Bool = true
    @State var paddingHeight: CGFloat = 0.0
    
    //@State private var amountText: String = ""
    
    @FocusState private var focusedField: Field?
    
    private enum Field: Int, CaseIterable {
        case amount // Für Preis/Wert
        case str1 // Für Gegenstandbeschreibung
        case str2 // Für allgemeine Informationen
        
    } // Ende private enum
    
    @State private var calendarId: Int = 0
    
    @State var platzText1: String = "Gegenstandbeschreibung"
    @State var platzText2: String = "Allgemeine Notizen"
    @State var selectedGegenstand: String = ""
    @State var selectedPerson: String = ""
    
    //@State private var text: String = ""
    //@State private var platz: String = ""
    
    @State var imageData = UIImage()
    
    private let numberFormatter: NumberFormatter
    private let perKeyFormatter: DateFormatter
    //private let germanDateFormatter: DateFormatter
    @State var customButton: String = ""
    
    init() {
        numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 2
        
        perKeyFormatter = DateFormatter()
        perKeyFormatter.dateFormat = "y MM dd, HH:mm"
        
    } // Ende init
    
    // Das ist eigenes Button
    // Ohne dieses Button wird der Name der View angezeigt (Gegenstandsname)
    // Wenn man aber den Gegenstandsname ändert bleibt es in der Anzeige als zurück der alte Name.
    var btnBack : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss() // Nur iPhon
    }) {
        HStack {
            Image(systemName: "chevron.left").bold()
                .offset(x: -7)
            Text("Zurück")
                .offset(x: -11)
            Spacer()
        } // Ende HStack
        .onDisappear() {
            // It is like a Cancel Button
            print("Disappear in Eingabemaske wurde ausgeführt.")
        } // Ende onDisappear
    } // Ende Button Label
    } // Ende some View
    
    
    var body: some View {
        
        let _ = print("Struct EingabeMaskePhoneAndPadView: wird aufgerufen!")
        
       // let test = querySQLAbfrageClassPersonenGender()
        
        
        let tapOptionGegenstand = Binding<Int>(
            get: { globaleVariable.selectedGegenstandInt }, set: { globaleVariable.selectedGegenstandInt = $0
                
                //Add the onTapGesture contents here
                if globaleVariable.parameterGegenstand[globaleVariable.selectedGegenstandInt] == "Neuer Gegenstand" {
                    showSheetGegenstand = true
                   // selectedGegenstand = "Neuer Gegenstand"
                //}else{
                  //  selectedGegenstand = globaleVariable.parameterGegenstand[globaleVariable.selectedGegenstandInt]
                } // Ende if
            } // Ende set
        ) // Ende let
        
        let tapOptionPerson = Binding<Int>(
            get: { globaleVariable.selectedPersonInt }, set: { globaleVariable.selectedPersonInt = $0
                
                //Add the onTapGesture contents here
                if globaleVariable.personenParameter[globaleVariable.selectedPersonInt].personPicker == "Neue Person" {
                    showSheetPerson = true
                    //selectedPerson = "Neue Person"
                //}else{
                  //  selectedPerson = globaleVariable.personenParameter[globaleVariable.selectedPersonInt].personPicker
                  
                } // Ende if
            } // Ende set
        ) // Ende let
        
        GeometryReader { geometry in
            VStack {
                VStack {
                    Text("")
                    HStack {
                        Spacer()
                        Text("Neues Objekt").bold()
                        //.padding(.leading, 20)
                        Spacer()
                    }
                    
                    List {
                        Section {
                            HStack {
                                Text("Gegenstand:")
                                Spacer()
                                Picker("", selection: tapOptionGegenstand, content: {
                                    ForEach(0..<$globaleVariable.parameterGegenstand.count, id: \.self) { index in
                                        Text("\(globaleVariable.parameterGegenstand[index])")
                                            //.tag(index)
                                            .fixedSize(horizontal: true, vertical: false)
                                    } // Ende ForEach
                                    
                                })
                                .font(.system(size: 16, weight: .regular))
                                .frame(width: 180, height: 36)
                                .padding(.trailing, 5)
                                //.background(Color.blue)
                                //.opacity(0.4)
                                .cornerRadius(5)
                                .applyIf(UIDevice.current.userInterfaceIdiom == .phone,
                                         apply: {$0.navigationDestination(isPresented: $showSheetGegenstand, destination: { ShapeViewAddGegenstand(isPresented: $showSheetGegenstand, isParameterBereich: $isParameterBereich)
                                        .navigationBarBackButtonHidden()
                                        .navigationBarTitleDisplayMode(.inline)
                                }) },
                                         else: {
                                    
                                    $0.sheet(isPresented: $showSheetGegenstand, content: { ShapeViewAddGegenstand(isPresented: $showSheetGegenstand, isParameterBereich: $isParameterBereich )})
                                } // Ende else
                                ) // Ende applyIf
                            } // Ende HStack
                            
                            CustomTextField(text: $globaleVariable.textGegenstandbeschreibung, isMultiLine: true, placeholder: "Gegenstandbeschreibung")
                                .focused($focusedField, equals: .str1)
                            /*
                            TextEditorWithPlaceholder(text: $globaleVariable.textGegenstandbeschreibung, platz: $platzText1)
                                .focused($focusedField, equals: .str1)
                            */
                            HStack {
                                Text("Gegenstandsbild:   ")
                                    .frame(height: 30)
                                    .font(.system(size: 16, weight: .regular))
                                Spacer()
                                ImageSelector()
                                Text(" ")
                                if cameraManager.permissionGranted {
                                    PhotoSelector()
                                } // Ende if
                                
                                if globaleVariable.parameterImageString != "Kein Bild" {
                                    let imageData = Data (base64Encoded: globaleVariable.parameterImageString)!
                                    let image = UIImage (data: imageData)!
                                    
                                    Image(uiImage: image)
                                        .resizable()
                                        .cornerRadius(36)
                                        .padding(.all, 4)
                                        .frame(width: 36, height: 36)
                                        .background(Color.black.opacity(0.2))
                                        .aspectRatio(contentMode: .fill)
                                        .clipShape(Circle())
                                    
                                } // Ende if
                                
                            } // Ende HStack
                            .onAppear {
                                cameraManager.requestPermission()
                            } // Ende onAppear
                            
                            HStack {
                                
                                Text("Preis/Wert:  ")
                                    .frame(height: 35, alignment: .leading)  // width: 190,
                                    .font(.system(size: 16, weight: .regular))
                                Spacer()
                                
                                
                                //Text(String(repeating: " ", count: 28))
                                TextField("", text: $globaleVariable.preisWert)
                                    .modifier(TextFieldEuro(textParameter: $globaleVariable.preisWert))
                                    .multilineTextAlignment(.trailing)
                                    .frame(width: 100, height: 30, alignment: .trailing)
                                    .background(Color.gray.opacity(0.09))
                                    .cornerRadius(10)
                                    .font(.system(size: 18, weight: .regular).bold())
                                    .foregroundColor(Color.black.opacity(0.4))
                                    .keyboardType(.decimalPad)
                                    .focused($focusedField, equals: .amount)
                                    .onReceive(Just(globaleVariable.preisWert)) { newValue in
                                        // Es soll verhindert werden mit cut/past nicht numerische Werte einzugeben. Zum Beispiel beim iPad
                                        let allowedCharacters = "0123456789,"
                                        var filtered = newValue.filter { allowedCharacters.contains($0) }
                                        let numberOfOccurances = filtered.numberOfOccurrencesOf(string: ",")
                                        
                                        if filtered != newValue  {
                                            globaleVariable.preisWert = filtered
                                            
                                        }else{
                                            if numberOfOccurances > 1 { // Wenn mehr als eine "," eingegeben wurden, werden sie gelöscht
                                                if let position = filtered.lastIndex(of: ",") {
                                                    filtered.remove(at: position)
                                                } // Ende if
                                                globaleVariable.preisWert = filtered
                                            }else{
                                                if filtered.prefix(1) == "," { // Wenn das erste zeichen "," ist, wird "0" voreingestellt.
                                                    filtered = "0" + filtered
                                                    globaleVariable.preisWert = filtered
                                                } // Ende if/else
                                                
                                            } // Ende if/else
                                            
                                        } // Ende if/else
                                    } // Ende onReceive
                                 
                            } // Ende HStack
                            
                            
                            HStack{
                                Text("Datum:")
                                    .font(.system(size: 16, weight: .regular))
                                Spacer()
                                DatePicker("", selection: $globaleVariable.datum, displayedComponents: [.date])
                                    .labelsHidden()
                                    .padding(.trailing, -5)
                                    .foregroundColor(.gray)
                                    .opacity(0.4)
                                    //.background(Color.blue)
                                    //.opacity(0.4)
                                    .multilineTextAlignment (.center)
                                    .environment(\.locale, Locale.init(identifier: "de"))
                                    .cornerRadius(5)
                                    .id(calendarId)
                                    .onChange(of: globaleVariable.datum) {
                                        calendarId += 1
                                    } // Ende onChange...
                                
                            } //Ende HStack
                            HStack{
                                Text("Vorgang: ")
                                    .font(.system(size: 16, weight: .regular))
                                Spacer()
                                
                                Picker("", selection: $globaleVariable.selectedVorgangInt, content: {
                                    ForEach(0..<$globaleVariable.parameterVorgang.count, id: \.self) { index in
                                        Text("\(globaleVariable.parameterVorgang[index])")//.tag(index)
                                    } // Ende ForEach
                                }) // Picker
                                .font(.system(size: 16, weight: .regular))
                                .frame(width: 150, height: 30)
                                .padding(.trailing, 5)
                                //.background(Color.blue)
                                //.opacity(0.4)
                                .cornerRadius(5)
                            } // Ende HStack
                            
                            HStack{
                                Text("Neue Person: ")
                                    .font(.system(size: 16, weight: .regular))
                                Spacer()
                                
                                Picker("", selection: tapOptionPerson, content: {
                                    ForEach(0..<$globaleVariable.personenParameter.count, id: \.self) { index in
                                        //HStack {
                                            
                                            Text("\(truncateText(globaleVariable.personenParameter[index].personPicker))")//.tag(index)
                                          /*
                                            Spacer()
                                            
                                            // Check if the current index matches the selected value. If it does not, display the image.
                                            // and if personPicker = "Neue Person" then don't display image
                                            if tapOptionPerson.wrappedValue != index  {
                                               if globaleVariable.personenParameter[index].personPicker != "Neue Person" {
                                                    
                                                    Image( globaleVariable.personenParameter[index].personSex)
                                                        .renderingMode(Image.TemplateRenderingMode.original)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 10, height: 10)
                                                        .clipped()
                                                    
                                                } // Ende if
                                            } // Ende if
                                        //} // Ende HStack
                                        */
                                    } // Ende ForEach
                                    
                                }) // Picker
                                .font(.system(size: 16, weight: .regular))
                                .frame(width: 175, height: 30)
                                .truncationMode(.tail)
                                .padding(.trailing, 5)
                                .cornerRadius(5)
                                /*
                                .onChange(of: tapOptionPerson.wrappedValue ){
                                    print("\(globaleVariable.personenParameter[tapOptionPerson.wrappedValue].personPicker)")
                                }
                                */
                                .applyIf(UIDevice.current.userInterfaceIdiom == .phone,
                                         apply: {
                                    $0.navigationDestination(isPresented: $showSheetPerson, destination: { ShapeViewAddUser(isPresented: $showSheetPerson, isParameterBereich: $isParameterBereich)
                                            .navigationBarBackButtonHidden()
                                      
                                    })
                                }, else: {
                                    $0.sheet(isPresented: $showSheetPerson, content: { ShapeViewAddUser(isPresented: $showSheetPerson, isParameterBereich: $isParameterBereich) })
                                }) // Ende applyIf
                                
                            } // Ende HStack
                            
                            CustomTextField(text: $globaleVariable.textAllgemeineNotizen, isMultiLine: true, placeholder: "Allgemeine Notitzen")
                                .focused($focusedField, equals: .str2)
                            /*
                            TextEditorWithPlaceholder(text: $globaleVariable.textAllgemeineNotizen, platz: $platzText2)
                                .focused($focusedField, equals: .str2)
                            */
                            VStack{
                                
                                HStack {
                                    Spacer()
                                    if UIDevice.current.userInterfaceIdiom == .pad {
                                        Button(action: {showAlertAbbrechenButton = true}) { Text("Abbrechen") } .buttonStyle(.bordered).foregroundColor(.blue).font(.system(size: 16, weight: .regular))
                                            .alert(isPresented:$showAlertAbbrechenButton) {
                                                Alert(
                                                    title: Text("Sie haben folgende Wahl."),
                                                    message: Text("\(AlertMessageTexte.alertTextForEingabemaske)"),
                                                    primaryButton: .destructive(Text("\(customButton)")) {
                                                        
                                                        // Die Parameterwerte werden gelöscht.
                                                        cleanEingabeMaske()
                                                        
                                                    },
                                                    secondaryButton: .cancel(Text("Abbrechen")){
                                                        //print("\(globaleVariable.parameterPerson[globaleVariable.selectedPersonInt])")
                                                        print("Abgebrochen ....")
                                                    } // Ende secondary Button
                                                ) // Ende Alert
                                            } // Ende alert
                                    } // Ende if
                                    Button(action: {showAlertSpeichernButton = true}) { Text("Speichern")}
                                        .disabled(parameterCheck(parGegenstand: "\(globaleVariable.parameterGegenstand[globaleVariable.selectedGegenstandInt])", parPerson: "\(globaleVariable.personenParameter[globaleVariable.selectedPersonInt].personVorname)"))
                                        .buttonStyle(.borderedProminent)
                                        .foregroundColor(.white).font(.system(size: 16, weight: .regular))
                                        .alert(isPresented:$showAlertSpeichernButton) {
                                            Alert(
                                                title: Text("Möchten Sie alle Eingaben speichern?"),
                                                message: Text("Die Daten werden in die Datenbank gespeichert und die Eingabemaske wird geleert!"),
                                                primaryButton: .destructive(Text("Speichern")) {
                                                    
                                                    // perKey ist die einmahlige Zahl zum eindeutigen definieren jeden Datensatzes
                                                    let perKey = erstellePerKey(par1: perKeyFormatter.string(from: globaleVariable.datum))
                                                    
                                                    let personVornameTmp = globaleVariable.personenParameter[globaleVariable.selectedPersonInt].personVorname
                                                    let personNachnameTmp = globaleVariable.personenParameter[globaleVariable.selectedPersonInt].personNachname
                                                    let persoSexTmp = globaleVariable.personenParameter[globaleVariable.selectedPersonInt].personSex
                                                    
                                                    let insertDataToDatenbank = "INSERT INTO Objekte(perKey, gegenstand, gegenstandText, gegenstandBild, preisWert, datum, vorgang, personVorname, personNachname, personSex, allgemeinerText) VALUES('\(perKey)','\(globaleVariable.parameterGegenstand[globaleVariable.selectedGegenstandInt])', '\(globaleVariable.textGegenstandbeschreibung)','\(globaleVariable.parameterImageString)','\(globaleVariable.preisWert)', '\(dateToString(parDatum: globaleVariable.datum))', '\(globaleVariable.parameterVorgang[globaleVariable.selectedVorgangInt])', '\(personVornameTmp)', '\(personNachnameTmp)', '\(persoSexTmp)', '\(globaleVariable.textAllgemeineNotizen)')"
                                                    
                                                    
                                                    // Die Parameterwerte werden in die SQL Tabelle Objekte geschrieben.
                                                    if sqlite3_exec(db, insertDataToDatenbank, nil, nil, nil) != SQLITE_OK {
                                                        let errmsg = String(cString: sqlite3_errmsg(db)!)
                                                        print("error -->: \(errmsg)")
                                                        print("Daten wurden nicht hinzugefügt")
                                                        
                                                    }else{
                                                        // Die Felder der Eingabemaske werden zurückgesetzt
                                                        cleanEingabeMaske()
                                                        
                                                        if UIDevice.current.userInterfaceIdiom == .phone {
                                                            // Diese Zeile bewirkt, dass die View in iPhone geschlossen wird
                                                            self.presentationMode.wrappedValue.dismiss() // Only iPhon
                                                        } // Ende if
                                                        
                                                        globaleVariable.numberOfObjects = anzahlDerDatensaetze(tableName: "Objekte")
                                                        
                                                        print("In der Tabelle Gespeichert...")
                                                        
                                                    } // End if/else
                                                    
                                                },
                                                secondaryButton: .cancel(Text("Abbrechen")){
                                                    print("Abgebrochen ....")
                                                } // Ende secondaryButton
                                            ) // Ende Alert
                                        } // Ende alert
                                    Spacer()
                                } // Ende HStack
                                
                            } // Ende VStack
                            
                            // Only iPhon
                            Text("Um ein Objekt speichern zu können müssen mimdestens ein Gegenstand und eine Person erfast werden.")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.gray)
                        } // Ende Section
                        
                    } // Ende List
                    //.navigationTitle("Eingabemaske")
                    .cornerRadius(5)
                    .font(.system(size: 16, weight: .regular))
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            
                            if focusedField == .amount {
                                Spacer()
                                Button("Fertig") {
                                    //preisWertIsFocused = false
                                    focusedField = nil
                                    print("OK Button wurde gedrückt!")
                                } // Ende Button
                                .buttonStyle(.bordered)
                                //.font(.system(size: 16, weight: .regular))
                            }else if focusedField == .str1 {
                                HStack {
                                    Text("\(globaleVariable.textGegenstandbeschreibung.count)/100")
                                        .font(.system(size: 16, weight: .regular))
                                        .foregroundColor(.brown)
                                        .padding()
                                    Spacer()
                                    Button("Abbrechen") {
                                        //preisWertIsFocused = false
                                        globaleVariable.textGegenstandbeschreibung = ""
                                        focusedField = nil
                                        print("Abbrechen Button Str1 wurde gedrückt!")
                                    } // Ende Button
                                    //.font(.system(size: 16, weight: .regular))
                                } // Ende HStack
                            }else if focusedField == .str2  {
                                HStack{
                                    Text("\(globaleVariable.textAllgemeineNotizen.count)/100")
                                    //.font(.system(size: 16, weight: .regular))
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Button("Abbrechen") {
                                        //preisWertIsFocused = false
                                        globaleVariable.textAllgemeineNotizen = ""
                                        focusedField = nil
                                        print("Abbrechen Button Str2 wurde gedrückt!")
                                    } // Ende Button
                                } // Ende HStack
                            } // Ende if/else
                            
                        } // Ende ToolbarItemGroup
                        if UIDevice.current.userInterfaceIdiom == .phone {
                            
                            ToolbarItemGroup(placement: .navigationBarTrailing) {
                                Button( action: {
                                    // Die Parameterwerte werden gelöscht.
                                    cleanEingabeMaske()
                                }) {Image(systemName: "trash").imageScale(.large)}
                                
                            } // Ende ToolbarGroup
                        } // Ende if
                        
                        if userSettingsDefaults.showHandbuch == true {
                           
                            ToolbarItemGroup(placement: .navigationBarTrailing) {
                                Button( action: {
                                    showParameterHilfe = true
                                }) {Image(systemName: "questionmark.circle.fill").imageScale(.large)}
                                
                            } // Ende ToolbarGroup
                
                        } // Ende if
                        
                    } // Ende toolbar
                    
                } // Ende VStack
                .frame(width: geometry.size.width, height: geometry.size.height * globaleVariable.heightFaktorEbene1, alignment: .center)
                .background(globaleVariable.farbenEbene1)
                .cornerRadius(10)
                
            } // Ende VStack
            .frame(width: geometry.size.width, height: geometry.size.height * globaleVariable.heightFaktorEbene0, alignment: .center)
            .background(globaleVariable.farbenEbene0)
            
            
        } // Ende GeometryReader
        .navigationTitle("Eingabemaske")
        .navigationBarBackButtonHidden()
        .applyModifier(UIDevice.current.userInterfaceIdiom == .phone){$0.navigationBarItems(leading: btnBack)}
        .onAppear{
            // Abstand der Form von der oberen Kante
            if UIDevice.current.userInterfaceIdiom == .pad {
                paddingHeight = 10 // For iPad
                customButton = "Löschen"
            } else {
                paddingHeight = 0 // For iPhone
                customButton = "Verlassen"
            } // Ende if/else
            
        } // Ende onApear
        .interactiveDismissDisabled()  // Disable dismiss with a swipe. Only iPhon
        .alert("Hilfe zu Eingabemaske", isPresented: $showParameterHilfe, actions: {
        }, message: { Text("\(HilfeTexte.eingabeMaske)") } // Ende message
        ) // Ende alert
    
    } // Ende var body

} // Ende struct



// What the function do:
// First, split the string using the comma , as the delimiter.
// For each side of the split string (left and right), take the first 5 characters and append '...' if there are more than 5 characters.
// Finally, combine both sides together.
func truncateText(_ myText: String) -> String {
    let _ = print("func truncateText() wird aufgerufen!")
    let components = myText.split(separator: ",", maxSplits: 1) // Split by comma
    
    guard components.count == 2 else {
        return myText // Return original text if there's no comma
    } // Ende guard
    
    guard myText.count > 15 else {
        return myText // Return original text if it is shorter as 15 characters
    } // Ende guard
    
    let left = String(components[0])
    let right = String(components[1])
    
    let truncatedLeft = left.count > 5 ? left.prefix(5) + "..." : left
    let truncatedRight = right.count > 5 ? right.prefix(5) + "..." : right
    
    return truncatedLeft + "," + truncatedRight
} // Ende func

// What the function do:
// For the string take the first 5 characters and append '...' if there are more than 5 characters.
func truncateString(_ myText: String) -> String {
    let _ = print("func truncateString() wird aufgerufen!")
    
    guard myText.count > 10 else {
        return myText // Return original text if it is shorter as 10 characters
    } // Ende guard
    
    let truncatedLeft = myText.count > 5 ? myText.prefix(5) + "..." : myText
    
    return truncatedLeft
} // Ende truncateString

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
        //.screenshots,
        .depthEffectPhotos
    ]))
    
    var body: some View {
        let _ = print("Struct ImageSelector: wird aufgerufen!")
        PhotosPicker(selection: $selectedItem, matching: filter, photoLibrary: .shared()) {
            Image(systemName: "photo.fill.on.rectangle.fill")
                .symbolRenderingMode(.multicolor)
                .font(.system(size: 25))
                .foregroundColor(.accentColor)
        } // Ende PhotoPicker
        .buttonStyle(.borderless)
        .onChange(of: selectedItem) {
            Task {
                
                if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
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



struct CustomTextField: View {
    
    @Binding var text: String
    
    let isMultiLine: Bool
    let placeholder: String
    
    @State var lastText: String = ""
    @FocusState private var textIsFocused: Bool

    var body: some View {
        let _ = print("Struct CustomTextField: wird aufgerufen!")
        
        // Check if the text field is active (focused) or has content
        let isActive = textIsFocused || text.count > 0
        
        
        // Create a ZStack to overlay the button and the text field content
        ZStack(alignment: .center) {
            // Button to trigger focus on the whole text field frame
            Button(action: {
                textIsFocused = true
            }) {
                EmptyView()
            } // Ende Button
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .opacity(0) // Make the button transparent
            
            // Main content of the CustomTextField
            TextField("", text: $text, axis: isMultiLine ? .vertical : .horizontal)
                .frame(height: 24)
                .font(.system(size: 16, weight: .regular))
                .disableAutocorrection(true)
                .lineLimit(isMultiLine ? 3 : 1, reservesSpace: true)
                .opacity(isActive ? 1 : 0)
                .offset(y: isMultiLine ? 5 : 7)
                .submitLabel(.done)
                .focused($textIsFocused)
                .onChange(of: text) {
                    // Ensure the text length is within a limit (100 characters)
                    if text.count <= 100 {
                        lastText = text
                    } else {
                        self.text = lastText
                    } // Ende if/else
                    
                    // Check if the user pressed the return key (newline character)
                    guard let newValueLastChar = text.last else { return }
                    
                    if newValueLastChar == "\n" {
                        text.removeLast()
                        textIsFocused = false
                    } // Ende if newValue...
                } // Ende onChange
            
            // Placeholder text displayed with font sitze 16 when the text field is not active
            // Placeholder text displayed with font sitze 12 when the text field is active
            
            HStack {
                Text(placeholder)
                    .foregroundColor(.black.opacity(0.3))
                    .frame(height: 12)
                    .font(.system(size: isActive ? 12 : 16, weight: .regular))
                    .offset(y: isActive ? isMultiLine ? -30 : -14 : isMultiLine ? -30 : 0)
                Spacer()
            } // Ende HStack
        } // Ende ZStack
        .animation(.linear(duration: 0.2), value: textIsFocused)
        .frame(height: isMultiLine ? 96 : 56) // Set the overall height of the CustomTextField
        .padding(.horizontal, 16)
        .background(.white) // Apply a white background
        .cornerRadius(10) // Round the corners of the text field
        .overlay {
            // Add a border around the text field when it's focused
            RoundedRectangle(cornerRadius: 10)
                .stroke(textIsFocused ? .black.opacity(0.6) : .black.opacity(0.2), lineWidth: 2)
        } // Ende overlay
    } // Ende var body
} // Ende struct

/*
// Diese Funktion zeigt bei der Personenliste die Gender-Symbole
func genderSymbol(par: String) -> Image {
    let _ = print("func genderSymbol() wird aufgerufen!")
    var resultat: Image = Image("")
    
    if par == "Mann" {
        resultat = Image("Mann")
        
    } else if par == "Frau" {
        resultat = Image("Frau")
            
    } else if par == "Divers" {
        resultat = Image("Divers")
           
    } // Ende if
    
    return resultat
    
} // Ende func
*/

func parameterCheck(parGegenstand: String, parPerson: String) -> Bool {
    var resultat: Bool = true
    
    if parGegenstand == "Neuer Gegenstand" || parPerson == "Neue Person" {
        resultat = true
        
    } else {
        resultat = false
        
    }// Ende if/else

    return resultat
} // Ende func
