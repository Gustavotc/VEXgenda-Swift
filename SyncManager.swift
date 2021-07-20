//
//  SyncManager.swift
//  Agenda
//
//  Created by INDB on 02/07/21.
//

import Foundation
import PromiseKit

class SyncManager {
    
    static let shared = SyncManager()
    
    func syncDatabase() {
        
        firstly{ self.sendPendingContacts() }
        .then { self.sendPendingPhotos() }
        .then { self.updateDatabase() }
        .done { NotificationCenter.default.post(name: Notification.Name("finishSync"), object: nil) }.cauterize()
        
    }
    
    //Envia contatos pendentes
    private func sendPendingContacts() -> Promise<Void> {
       
        var pendingPromises: [Promise<Void>] = []
        
        if let pendingContacts = Contact.getAllPendingContacts() {
            for contact in pendingContacts {
                pendingPromises.append(send(contact: contact))
            }
        }

        return when(resolved: pendingPromises).asVoid()
        
    }
    
    private func send(contact: Contact) -> Promise<Void> {
        let API = PeopleAPI()

        if !contact.active { //Contato Excluído(desativado) localmente
            contact.clearContact()
            return API.deleteContact(resourceName: contact.resourceName) //Deletar contato na api
        }
        else if contact.resourceName == "" { //Contato inserido apenas localmente
            contact.clearContact()
            return API.createContact(contact: contact) //Cria contato na API
        }
        else { //Contato editado locamente
            contact.clearContact()
            return API.editContact(contact: contact) //Edita contato na API
        }
    }
    
    //Atualiza contatos locais
    private func updateDatabase() -> Promise<Void> {
        let API = PeopleAPI()
        API.updateHeader()
        
        return Promise { (seal) in
            API.loadContacts { contacts in
                
                contacts.forEach { contact in
                    contact.dirty = false
                    API.updateId(contact: contact)
                    contact.createOrUpdate()
                }
                
                seal.fulfill(())
                
            }
        }
    }
    
    
    //Envia fotos pendentes
    private func sendPendingPhotos() -> Promise<Void> {
        let API = PeopleAPI()
       
        var pendingPromises: [Promise<Void>] = []
        
        if let pendingPhotos = Contact.getAllPendingPhotos() {
            for contact in pendingPhotos {
                pendingPromises.append(API.uploadImage(contact: contact))
            }
        }

        return when(resolved: pendingPromises).asVoid()
        
    }
}
