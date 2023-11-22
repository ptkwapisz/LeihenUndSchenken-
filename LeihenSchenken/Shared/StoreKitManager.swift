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

class ProductManager: NSObject, ObservableObject, SKProductsRequestDelegate, SKRequestDelegate {
    @Published var products: [SKProduct] = []
    @Published var isPremium = false
    private let purchaseManager = PurchaseManager()
    private var productRequest: SKProductsRequest?

    // Produkt-IDs
    private let productIdentifiers: Set<String> = ["PTK.LeihenSchenken"]

    override init() {
        super.init()
        loadProducts()
        checkPremiumStatus()
    }

    private func checkPremiumStatus() {
        isPremium = purchaseManager.isPremium()
    }

    func loadProducts() {
        productRequest?.cancel()
        productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productRequest?.delegate = self
        productRequest?.start()
    }

    func purchasePremium() {
        // Hier StoreKit-Kauflogik implementieren
        // Nach erfolgreichem Kauf:
        purchaseManager.savePurchase(isPremium: true)
        isPremium = true
    }

    func restorePurchases() {
        // Käufe wiederherstellen
    }

    // SKProductsRequestDelegate
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.products = response.products
        }
    }

    // SKRequestDelegate
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load products: \(error.localizedDescription)")
    }
}



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
        }
    }

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
            }
        }
        return nil
    }

    static func delete(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}

// Kaufstatus speichern und abrufen
class PurchaseManager {
    private let premiumKey = "isPremium"

    func savePurchase(isPremium: Bool) {
        KeychainHelper.set(isPremium ? "true" : "false", forKey: premiumKey)
    }

    func isPremium() -> Bool {
        return KeychainHelper.get(forKey: premiumKey) == "true"
    }
}


struct InAppKaufPremiumView: View {
    @StateObject var productManager = ProductManager()

    var body: some View {
        NavigationView {
            if productManager.isPremium {
                Text("Premium Version")
            } else {
                Text("Standard Version")
                Button("Upgrade to Premium") {
                    productManager.purchasePremium()
                }
            }
        }
        .onAppear {
            productManager.loadProducts()
        }
    }
}
