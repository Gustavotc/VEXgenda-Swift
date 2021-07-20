//
//  Contact.swift
//  Agenda
//
//  Created by INDB on 18/06/21.
//

import Foundation
import ObjectMapper
import RealmSwift

class Contact: Object, Mappable{
    
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var resourceName: String = ""
    @objc dynamic var etag: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var photo: String?
    @objc dynamic var dirty = false
    @objc dynamic var imageName: String?
    @objc dynamic var active: Bool = true
    var phones = List<Phone>()
    
    
    //MARK:- Primary Key
    override static func primaryKey() -> String? {
            return "id"
    }
    
    //MARK:- Constructor
    required convenience init?(map: ObjectMapper.Map) {
        self.init()
    }
    
    //MARK:- Mapping
    func mapping(map: ObjectMapper.Map) {
       
        if map.mappingType == .fromJSON {
            id <- map["externalIds.0.value"]
            resourceName <- map["resourceName"]
            etag <- map["etag"]
            name <- map["names.0.displayName"]
            email <- map["emailAddresses.0.value"]
            photo <- map["photos.0.url"]
            phones <- (map["phoneNumbers"], getPhonesTransform())
        }
        
       if map.mappingType == .toJSON {
            id <- map["externalIds.value"]
            resourceName <- map["resourceName"]
            etag <- map["etag"]
            name <- map["names.givenName"]
            email <- map["emailAddresses.value"]
            phones <- (map["phoneNumbers"], getPhonesTransform())
       }
        
    }
    
    
    //MARK:- Realm Functions
    func createOrUpdate() {
        let realm = RealmManager.getInstance()
        
        try! realm.write {
            realm.add(self, update: .modified)
        }
    }
    
    func listContacts() -> Results<Contact>{
        let realm = RealmManager.getInstance()
        let predicate = NSPredicate(format: "active == true")
        return realm.objects(Contact.self).filter(predicate).sorted(byKeyPath: "name", ascending: true)
    }
    
    func deleteContact() {
        let realm = RealmManager.getInstance()
        try! realm.write {
            self.active = false
            self.dirty = true
            //realm.delete(self)
        }
    }
    
    func clearContact() {
        let realm = RealmManager.getInstance()
        try! realm.write({
            self.dirty = false
            realm.add(self, update: .modified)
        })
    }
    
    static func getAllPendingContacts() -> Results<Contact>? {
        let realm = RealmManager.getInstance()
        let predicate = NSPredicate(format: "dirty == true")
        return realm.objects(Contact.self).filter(predicate)
    }
    
    static func getAllPendingPhotos() -> Results<Contact>? {
        let realm = RealmManager.getInstance()
        let predicate = NSPredicate(format: "imageName != null")
        return realm.objects(Contact.self).filter(predicate)
    }
    
    static func savePhoto(newPhoto: UIImage?) -> String? {
        if let photo = newPhoto {
            do {
                return try ImageManager.savePhoto(photo: photo, name: "IMG_\(UUID().uuidString).jpg")
            } catch let error {
                print(error)
                return nil
            }
        }
        return nil
    }
    
    func saveResourceName(resourceName: String) {
        let realm = RealmManager.getInstance()
        try! realm.write({
            self.resourceName = resourceName
        })
    }
    
    static func getContact(id: String) -> Contact {
        let realm = RealmManager.getInstance()
        let predicate = NSPredicate(format: "id == %@", id)
        return realm.objects(Contact.self).filter(predicate).first!
    }
    
    static func searchContact(text: String!) -> Results<Contact>? {
        let realm = RealmManager.getInstance()
        let predicate = NSPredicate(format: "name CONTAINS [c] %@ && active = true", text)
        return realm.objects(Contact.self).filter(predicate).sorted(byKeyPath: "name")
    }
        

    //MARK:- Realm Transforms
    func getPhonesTransform() -> TransformOf<List<Phone>, [[String: Any]]> {
        let fromJson: (_ jsonArray: [[String: Any]]?) -> List<Phone>? = { jsonArray in
            let allPhones = List<Phone>()

            guard let jsonArray = jsonArray else { return allPhones }

            for json in jsonArray {
                if let phone = Phone(JSON: json) {
                    allPhones.append(phone)
                }
            }

            return allPhones
        }

        let toJson: (_ phones: List<Phone>?) -> [[String: Any]]? = { phones in
            guard let phones = phones, phones.count > 0 else { return nil }

            var jsonPhones: [[String: Any]] = []

            for phone in phones {
                jsonPhones.append(phone.detached().toJSON())
            }

            return jsonPhones

        }

        return TransformOf<List<Phone>, [[String: Any]]>(fromJSON: fromJson, toJSON: toJson)
    }
    
}
