//
//  CustomObject.swift
//  VExpenses
//
//  Created by Vitor Campos on 15/02/19.
//  Copyright © 2019 InDB. All rights reserved.
//

import Foundation
import RealmSwift

//Extension para criar cópias nao gerenciads de objetos realm
protocol DetachableObject: AnyObject {

	func detached() -> Self

}

extension Object: DetachableObject {

	func detached() -> Self {
		let detached = type(of: self).init()
		for property in objectSchema.properties {
			guard let value = value(forKey: property.name) else { continue }
			if let detachable = value as? DetachableObject {
				detached.setValue(detachable.detached(), forKey: property.name)
			} else {
				detached.setValue(value, forKey: property.name)
			}
		}
		return detached
	}

    func isInRealm() -> Bool {
        guard let pkName = type(of: self).primaryKey() else { return true }
        let primaryKey = self.value(forKeyPath: pkName)

        let realm = RealmManager.getInstance()
        let object = realm.object(ofType: type(of: self), forPrimaryKey: primaryKey)

        return object != nil
    }

}

extension List: DetachableObject where Element == Object {

	func detached() -> List<Element> {
		let result = List<Element>()
		forEach {
			result.append($0.detached())
		}
		return result
	}

}

//extension Object {
//
//    func createOrUpdate() -> Bool {
//        do {
//            let realm = try Realm()
//
//            try realm.write {
//                realm.add(self, update: .modified)
//            }
//        } catch {
//            return false
//        }
//
//        return true
//    }
//
//}
