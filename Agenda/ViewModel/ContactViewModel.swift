//
//  ContactViewModel.swift
//  Agenda
//
//  Created by INDB on 18/06/21.
//

import Foundation
import RealmSwift
import PromiseKit

protocol ContactViewModelDelegate: AnyObject {
    
    func reloadData()
    
}

class ContactViewModel: NSObject {
    
    var API = PeopleAPI()
    var contact = Contact()
    var contacts: Results<Contact>?
    weak var delegate: ContactViewModelDelegate?
    
    func numberOfRowsInSection() -> Int {
        return contacts?.count ?? 0
    }
    
    //Função para ler contatos
    func loadData() {
        //Exibe os contatos em ordem alfabética
        self.contacts = self.contact.listContacts()
        self.delegate?.reloadData()
    }
    
    func createContact(name: String?, email: String?, phones: [Phone]?, imageName: String?) {
        
        contact.name = name!
        contact.email = email!
        contact.phones.append(objectsIn: phones!)
    
        contact.dirty = true
        contact.imageName = imageName ?? ""
 
        contact.createOrUpdate()
    }
    
    func editContact(name: String?, email: String?, phones: [Phone]?, oldContact: Contact, imageName: String?) {
        
        contact.name = name!
        contact.email = email!
        contact.phones.append(objectsIn: phones!)
        contact.resourceName = oldContact.resourceName
        contact.etag = oldContact.etag
        contact.id = oldContact.id
        contact.imageName = imageName ?? ""
        
        contact.dirty = true
        contact.createOrUpdate()
    }
    
}

extension ContactViewModel: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count > 0 {
            self.contacts = Contact.searchContact(text: searchText)
            self.delegate?.reloadData()
        } else {
            self.contacts = self.contact.listContacts()
            self.delegate?.reloadData()
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
