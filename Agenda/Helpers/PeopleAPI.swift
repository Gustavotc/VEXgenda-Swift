//
//  PeopleAPI.swift
//  Agenda
//
//  Created by INDB on 19/06/21.
//

import Foundation
import Alamofire
import PromiseKit
import RealmSwift

class PeopleAPI {
   
    private let basePath = "https://people.googleapis.com/v1/people/me/connections"
    private let apiKey = ""
    private let scope = "https://www.googleapis.com/auth/contacts"
    
    private var APIHeaders: HTTPHeaders = [
        .authorization(bearerToken: UserData.shared.userAccessToken),
    ]
    
    func updateHeader() {
        self.APIHeaders = [
            .authorization(bearerToken: UserData.shared.userAccessToken),
        ]
    }
    
    //MARK:- GET CONTACTS
    func loadContacts(onComplete: @escaping ([Contact]) -> Void) {
        let url = basePath + "?personFields=names,phoneNumbers,emailAddresses,photos,externalIds&key=\(apiKey)"
        
        AF.request(url, method: .get, headers: APIHeaders).responseJSON { (response) in
            switch response.result {
                case .success(let json):
                    
                    //Caso de erro de autenticação, usuário deve relogar
                    if response.response?.statusCode == 401 {
                        print("Falha na autenticação")
                        let OAuth: OAuthService = OAuthService()
                        OAuth.presentASController()
                    }
                    
                    //Caso a requisição dê certo
                    var contacts: [Contact] = []
                    guard let dataResponse = json as? [String: Any], let connections = dataResponse["connections"] as? [[String: Any]]
                    else {return}
                    
                    connections.forEach { jsonContact in
                        let contact = Contact(JSON: jsonContact)
                        contacts.append(contact!)
                    }
                    onComplete(contacts)
                case .failure(let httpError):
                    print(httpError)
            }
        }
    }
    
    //MARK:- POST CONTACT
    func createContact(contact: Contact) -> Promise<Void> {
        
        let url = "https://people.googleapis.com/v1/people:createContact"
        
        let contactObject = contact

        let params = contactObject.detached().toJSON()
        
        return Promise { (seal) in
            AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: APIHeaders).responseJSON { (response) in

                switch(response.result) {
                    case .success(let json):
                        print(json)
                        
                        let response = json as! NSDictionary
                        let resourceName = response.object(forKey: "resourceName")!
                        
                        let contact = Contact.getContact(id: contact.id)
                        contact.saveResourceName(resourceName: resourceName as! String)

                        seal.fulfill(())
                    case .failure(let httpError):
                        print(httpError)
                        seal.reject(httpError)
                }
            }

        }
    }
    
    //MARK:- DELETE CONTACT
    func deleteContact(resourceName: String) -> Promise<Void> {
        
        let url = "https://people.googleapis.com/v1/\(resourceName):deleteContact?key=\(apiKey)"
        
        return Promise { (seal) in
            
            AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: APIHeaders).responseJSON { (response) in
                switch(response.result) {
                    case .success:
                        print("Contato Deletado")
                        seal.fulfill(())
                    case .failure(let httpError):
                        print(httpError)
                        seal.reject(httpError)
                }
            }
            
        }
    }
    
    //MARK:- EDIT CONTACT
    func editContact(contact: Contact) -> Promise<Void> {
        
        let url = "https://people.googleapis.com/v1/\(contact.resourceName):updateContact?updatePersonFields=names,phoneNumbers,emailAddresses,externalIds&key=\(apiKey)"
        
        let contactObject = contact

        let params = contactObject.detached().toJSON()
            
        return Promise { (seal) in
            AF.request(url, method: .patch, parameters: params, encoding: JSONEncoding.default ,headers: APIHeaders).responseJSON { (response) in

                switch(response.result) {
                case .success(_):
                        //print(json)
                        //print("Contato Editado")
                        seal.fulfill(())
                    case .failure(let httpError):
                        print(httpError)
                        seal.reject(httpError)
                }
            }
        }
        
    }
    
    
    func updateId(contact: Contact) {
        
        let url = "https://people.googleapis.com/v1/\(contact.resourceName):updateContact?updatePersonFields=externalIds&key=\(apiKey)"
        
        let params = [
            "externalIds": [
              [
                  "value": contact.id
              ]
            ],
              "etag": contact.etag,
        ] as [String : Any]

    
        AF.request(url, method: .patch, parameters: params, encoding: JSONEncoding.default ,headers: APIHeaders).responseJSON { (response) in

//                switch(response.result) {
//                    case .success:
//                        print("Contato Editado")
//                    case .failure(let httpError):
//                        print(httpError)
//                }
        }

    }
    
    //MARK:- UPLOAD IMAGE
    func uploadImage(contact: Contact) -> Promise<Void>{
        
        let url = "https://people.googleapis.com/v1/\(contact.resourceName):updateContactPhoto"
        
        let image = ImageManager.findImageWithName(name: contact.imageName)
        
        let jpegData = image?.jpegData(compressionQuality: 1)
        guard let imageEncoded = jpegData?.base64EncodedString() else {return Promise()}
     
        let params: [String: Any] = [
            "photoBytes": imageEncoded
        ]
        
        return Promise { (seal) in
            AF.request(url, method: .patch, parameters: params, encoding: JSONEncoding.default ,headers: APIHeaders).responseString { (response) in

                        switch(response.result) {
                            case .success:
                                seal.fulfill(())
                                //print("Foto editada")
                            case .failure(let httpError):
                                seal.reject(httpError)
                                print(httpError)
                        }
            }
        }
    }
    
}
