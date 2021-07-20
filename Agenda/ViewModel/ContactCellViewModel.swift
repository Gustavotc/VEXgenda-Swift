//
//  ContactCellViewModel.swift
//  Agenda
//
//  Created by INDB on 18/06/21.
//

import Foundation

class ContactCellViewModel {
    let name: String
    let email: String
    let photo: String
    
    init(contact: Contact) {
        self.name = contact.name
        self.email = contact.email
        self.photo = contact.photo ?? ""
    }
}
