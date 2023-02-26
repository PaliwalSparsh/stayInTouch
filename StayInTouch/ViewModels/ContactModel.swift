//
//  PeopleModel.swift
//  StayInTouch
//
//  Created by Sparsh Paliwal on 2/23/23.
//

import Foundation

class ContactModel: ObservableObject {
    @Published var contacts = [Contact]()
    
    func addContacts(contacts: [Contact]) {
        self.contacts.append(contentsOf: contacts)
    }
}
