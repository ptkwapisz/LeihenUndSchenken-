//
//  StoreKitManager.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 20.11.23.
//

import Foundation
import SwiftUI
import StoreKit
import Security

// Das isr einige Hilfsfunktionen, um den Umgang mit der Keychain zu vereinfachen.
// Diese Funktionen ermöglicht das Speichern, Abrufen und Löschen von Daten in der Keychain:
class KeychainHelper {
    static func set(_ value: String, forKey key: String) {
        if let value = value.data(using: .utf8) {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecValueData as String: value
            ]
            SecItemDelete(query as CFDictionary)
            SecItemAdd(query as CFDictionary, nil)
        } // Ende if
    } // Ende func

    static func get(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var dataTypeRef: AnyObject?
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == noErr {
            if let data = dataTypeRef as? Data {
                return String(data: data, encoding: .utf8)
            } // Ende if
        } // Ende if
        return nil
    } // Ende func get

    static func delete(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    } // Ende func delete
} // Ende class

// Kaufstatus speichern und abrufen
class PurchaseManager {
    
    private let premiumKey = "isPremium"

    func savePurchase(isPremium: Bool) {
        KeychainHelper.set(isPremium ? "true" : "false", forKey: premiumKey)
    } // Ende func savePurchase

    func isPremium() -> Bool {
        
        //return purchasedProductIdentifiers.contains(productIdentifier)

        return KeychainHelper.get(forKey: premiumKey) == "true"
    } // Ende func isPremium
    
    func deletePurchase() {
        
        KeychainHelper.delete(forKey: premiumKey)
    } // Ende func deletePurchase
    

} // Ende class PurchaseManager

struct StroreAccessPremium: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    //@ObservedObject private var purchaseStatusNotifier = PurchaseStatusNotifier()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject private var purchaseStatusNotifier = PurchaseStatusNotifier()
    @Binding var isPresented: Bool
    @State private var needsRefresh: Bool = false
    let statusManager = StatusManager()
    let purchaseManager = PurchaseManager()
   
    let footerTextStandard: String = "Bei der Standard-Version ist die Anzahl der Objekte auf \(GlobalStorage.numberOfObjectsFree) begrenzt. Die Funktionalität der App ist aber nicht eingeschränkt. Man kann dadurch die App auf eigene Belange testen. Mit dem Kauf der Premium-Version fehlt die Begrenzung auf 10 Objekte. Den oben angezeigten Betrag zahlt man nur ein Mal."
    let footerTextPremium: String = "Bei der Premium-Version ist die Anzahl der Objekte unbegrenzt. Die Funktionalität der App ist nicht eingeschränkt. Der Kauf war einmalig und ist zeitlich unbegrnzt."
   
    @State private var heightOfTextinForm: CGFloat = 0.0 // Is needed for calculation of footer position
    
    var body: some View {
       
        let footerText: String = purchaseManager.isPremium() ? footerTextPremium : footerTextStandard
        //let footerText: String = statusManager.isProductPurchased ? footerTextPremium : footerTextStandard
        
        GeometryReader { geometry in
            
            VStack{
                VStack{
                    Text("")
                    Text ("App Status").bold()
                    Form {
                        Section(footer: Text("\(footerText)")) {
                           
                            InAppPurchasePremiumView()
                            
                        } // Ende Section
                        
                        //Section (footer: FooterView(heightOfTextinForm: $heightOfTextinForm)) {
                        Section {
                            HStack{
                                Spacer()
                                Button {
                                    
                                    // Diese Zeile bewirkt, dass die View geschlossen wird
                                    self.presentationMode.wrappedValue.dismiss()
                                    
                                } label: {
                                    Label("Ansicht verlassen", systemImage: "arrowshape.turn.up.backward.circle")
                                    
                                } // Ende Button
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color.white)
                                .buttonStyle(.borderedProminent)
                                Spacer()
                                
                            } // Ende HStack
                            .onReceive(purchaseStatusNotifier.$purchaseCompleted) { completed in
                                if completed {
                                    statusManager.handlePurchaseStatusUpdate(with: purchaseManager, needsRefresh: true) {
                                        needsRefresh.toggle()
                                    }
                                    print("complited ist true")
                                }else{
                                    print("complited ist false")
                                }
                            }
                        } // Ende Section
                        .onAppear {
                            heightOfTextinForm = geometry.size.height
                           
                        } // Ende onAppear
          
                        FooterView()
                        .listRowInsets(EdgeInsets())
                        .frame(width: geometry.size.width, height: 45, alignment: .top)
                        .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                        
                    } // Ende Form
                    .cornerRadius(10)
                    
                    
                } // Ende VStack
                .background(globaleVariable.farbenEbene1)
                .cornerRadius(10)
                
            } // Ende VStack
            .frame(width: geometry.size.width, height: geometry.size.height * globaleVariable.heightFaktorEbene0, alignment: .center)
            .background(globaleVariable.farbenEbene0)
            
        } // Ende GeometryReader
        .interactiveDismissDisabled()  // Disable dismiss with a swipe
        .environmentObject(purchaseStatusNotifier)
        
    } // Ende var body

} // Ende struct StroreAccessPremium


struct InAppPurchasePremiumView: View {
    //@ObservedObject var purchaseStatusNotifier = PurchaseStatusNotifier()
    @EnvironmentObject var purchaseStatusNotifier: PurchaseStatusNotifier
    
   private let purchaseManager = PurchaseManager()
    
    var body: some View {
        HStack {
            //if statusManager.isProductPurchased {
            if purchaseManager.isPremium() {
                Spacer()
                Text("Sie haben die Premium-Version!")
                Spacer()
            } else {
                Spacer()
                Text("Sie haben die Standard-Version!")
                Spacer()
            } // Ende if/else
        } // Ende HStack
        
        ZStack {
            
            ProductView(id: "PTK.LeihenUndSchenken.lifetime") {_ in
                Image("AppImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .cornerRadius(10)
                
            } placeholderIcon: {
                ProgressView()
            } // Ende placeholderIcon
            .productViewStyle(.compact)
            .storeButton(.visible, for: .restorePurchases)
            .storeButton(.hidden, for: .cancellation)
            .onInAppPurchaseStart { product in
                print("User has started buying \(product.id)")
            } // Ende .onInAppPurchaseStart
            .onInAppPurchaseCompletion { product, result in
                if case .success(.success(let transaction)) = result {
                    print("Purchased successfully: \(transaction.signedDate)")
                    purchaseManager.savePurchase(isPremium: true)
                    purchaseStatusNotifier.notifyPurchaseCompletion()
                } else {
                    print("Something else happened")
                    
                } // Ende if/else
            } // Ende .onInAppPurchaseCompletion
            
        } // Ende ZStack
        
    } // Ende var body
} // Ende struct InAppPurchasePremiumView

// This struct show footer in the Section for "Käufe wiederherstellen"
// This footer will be show when premium ist false
struct FooterView: View {
    //@Binding var heightOfTextinForm: CGFloat
    let purchaseManager = PurchaseManager()
    //let statusManager = StatusManager()
    
    var body: some View {
        
        HStack {
            if purchaseManager.isPremium() != true {
            //if statusManager.isProductPurchased != true {
                Spacer()
                Button(action: {
                    Task {
                        do {
                            try await AppStore.sync()
                        } catch {
                            print(error)
                        } // Ende catch
                    } // Ende Task
                }) {
                    
                    HStack{
                        Spacer()
                        Text("Einkäufe wiederherstellen")
                        Spacer()
                    } // Ende HStack
                    //.frame(height: heightOfTextinForm * 0.83)
                    
                } // Ende Button
                
                Spacer()
            } // Ende if
        } // Ende HStack
    } // Ende var body
} // Ende struct

class StatusManager: NSObject, ObservableObject, SKPaymentTransactionObserver {
    @Published var isProductPurchased: Bool = false
    
    private let productId: String = "PTK.LeihenUndSchenken.lifetime"
    private var checkCompletion: ((Bool) -> Void)?
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    } // Ende override
    
    func checkPurchaseStatus(completion: @escaping (Bool) -> Void) {
        self.checkCompletion = completion
        SKPaymentQueue.default().restoreCompletedTransactions()
    } // Ende func
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
                case .purchased, .restored:
                    if transaction.payment.productIdentifier == self.productId {
                        isProductPurchased = true
                        checkCompletion?(true)
                    }
                    queue.finishTransaction(transaction)
                case .failed:
                    queue.finishTransaction(transaction)
                    checkCompletion?(false)
                default:
                    break
            } // Ende switch
        } // Ende for
    } // Ende func
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        checkCompletion?(isProductPurchased)
    } // Ende func
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        checkCompletion?(false)
    } // Ende func

    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return true
    } // Ende func
} // Ende class


extension StatusManager {
    //func handlePurchaseStatusUpdate(with purchaseManager: PurchaseManager) {
    func handlePurchaseStatusUpdate(with purchaseManager: PurchaseManager, needsRefresh: Bool, completion: @escaping () -> Void) {
        
        checkPurchaseStatus { isPurchased in
            if isPurchased {
                if !purchaseManager.isPremium() {
                    purchaseManager.savePurchase(isPremium: true)
                } // Ende if
                print("----------------------------")
                print("CheckPurchaseStatus: Produkt ist Premium")
                print("----------------------------")
            } else {
                if purchaseManager.isPremium() {
                    purchaseManager.deletePurchase()
                }
                print("----------------------------")
                print("CheckPurchaseStatus: Produkt ist Standard")
                print("----------------------------")
            } // Ende if/else
            
            if self.isProductPurchased {
                
                print("----------------------------")
                print("isProductPurchased: Produkt ist Premium")
                print("----------------------------")
                
            }else {
                print("----------------------------")
                print("isProductPurchased: Produkt ist Standard")
                print("----------------------------")
                
            } // Ende if/else
            
            if needsRefresh {
                completion()
            } // Ende if
        } // Ende checkPurchaseStatus
    } // Ende func
} // Ende extension

class PurchaseStatusNotifier: ObservableObject {
    // Diese Variable wird aktualisiert, wenn ein Kauf abgeschlossen wird
    @Published var purchaseCompleted: Bool = false
    
    func notifyPurchaseCompletion() {
        purchaseCompleted = true
    } // Ende func
} // Ende class


