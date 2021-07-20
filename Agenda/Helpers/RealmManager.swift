//
//  RealmManager.swift
//  Agenda
//
//  Created by INDB on 29/06/21.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static func getInstance() -> Realm {
        do {
            return try Realm()
        } catch {
            preconditionFailure("Erro ao instânciar o Realm")
        }
    }
    
}
