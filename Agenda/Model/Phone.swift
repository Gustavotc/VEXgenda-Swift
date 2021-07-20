//
//  Phone.swift
//  Agenda
//
//  Created by INDB on 18/06/21.
//

import Foundation
import ObjectMapper
import RealmSwift

class Phone: Object ,Mappable{
    @objc dynamic var phone: String = ""
    @objc dynamic var type: String = ""
    
        
    required convenience init?(map: ObjectMapper.Map) {
        self.init()
    }
    
    func mapping(map: ObjectMapper.Map) {
        phone <- map["value"]
        type <- map["type"]
    }
    
   
}
