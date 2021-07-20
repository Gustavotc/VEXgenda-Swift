//
//  UserData.swift
//  Agenda
//
//  Created by INDB on 23/06/21.
//

import Foundation

enum UserDefaultsKeys: String {
    case accessToken = "accessToken"
}

class UserData {
    
    let defaults = UserDefaults.standard
    static var shared: UserData = UserData()
    
    var userAccessToken: String {
        get {
            return defaults.string(forKey: UserDefaultsKeys.accessToken.rawValue) ?? ""
        }
        set {
            defaults.set(newValue, forKey: UserDefaultsKeys.accessToken.rawValue)
        }
    }
    
    private init() {
        
    }
}
