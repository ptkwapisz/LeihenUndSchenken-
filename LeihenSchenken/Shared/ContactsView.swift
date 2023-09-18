//
//  ContactsView.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 16.07.23.
//


import SwiftUI
import Contacts
import Foundation

// Funktion generiert von ChatGPT 4 Plus
func fetchAllContacts() -> [Contact] {
    var contacts = [Contact]()
    
    let store = CNContactStore()
    let keys: [CNKeyDescriptor] = [CNContactGivenNameKey, CNContactFamilyNameKey] as [CNKeyDescriptor]
    let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
    
    do {
        try store.enumerateContacts(with: fetchRequest) { contact, _ in
            if !contact.givenName.isEmpty || !contact.familyName.isEmpty {
                contacts.append(Contact(firstName: contact.givenName, lastName: contact.familyName))
            }// Ende if
        } // Ende store
        
        let filteredContacts = contacts.filter {$0.firstName != "" && $0.lastName != ""}
        return filteredContacts.sorted(by: { $0.lastName < $1.lastName })
        
    } catch {
        print("Error fetching contacts: \(error)")
        return []
    } // Ende do/catch
} // Ende func

