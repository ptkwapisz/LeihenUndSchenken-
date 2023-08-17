//
//  ContactsView.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 16.07.23.
//
/*
import SwiftUI
import Foundation
import Contacts


func fetchAllContacts() -> [Contact] {
    
    var resultat = [Contact]()
    
    // Run this in the background async
    
    //DispatchQueue.global(qos: .userInteractive).async {
        
        // Get access to the Contacts store
        let store = CNContactStore()
        
        // Specify witch data keys we want to fetch
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey] as [CNKeyDescriptor]
        // Create fetch request
        let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
        
        // Call method to fetch all contacts
        do {
            
            try store.enumerateContacts(with: fetchRequest, usingBlock: { (contact, stopPointer) in
                // Do something with contacts
                
                resultat.append(Contact(firstName: contact.givenName, lastName: contact.familyName))
                
            })
            
            // Löschen leerer Element
            resultat = resultat.filter({ !$0.firstName.isEmpty && !$0.lastName.isEmpty})
            // Sortieren nach Nachname
            resultat = resultat.sorted { $0.lastName < $1.lastName }
            
            
        } // Ende do
        
        catch {
            // if there was an error, handle it here
            print("Error")
        } // Ende catch
        
    //} // Ende Dispatch
    
    return resultat
    
} // Ende func

*/

import SwiftUI
import Contacts

func fetchAllContacts() -> [Contact] {
    var resultat = [Contact]()
    
    // Get access to the Contacts store
    let store = CNContactStore()
    
    // Specify which data keys we want to fetch
    let keys = [CNContactGivenNameKey, CNContactFamilyNameKey] as [CNKeyDescriptor]
    
    // Create fetch request
    let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
    
    do {
        // Enumerate and process contacts
        try store.enumerateContacts(with: fetchRequest) { contact, stopPointer in
            // Append only non-empty contacts
            if !contact.givenName.isEmpty || !contact.familyName.isEmpty {
                resultat.append(Contact(firstName: contact.givenName, lastName: contact.familyName))
            } // Ende if
        } // Ende try
        
        // Sort the contacts by last name
        resultat.sort { $0.lastName < $1.lastName }
        
    } catch {
        // Handle errors
        print("Error fetching contacts: \(error)")
    } // Ende do/catch
    
    return resultat
} // Ende func

