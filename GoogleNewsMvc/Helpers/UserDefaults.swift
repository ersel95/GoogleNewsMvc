//
//  UserDefaults.swift
//  GoogleNewsMvc
//
//  Created by Mr. T. on 29.02.2020.
//  Copyright © 2020 Mr. T. All rights reserved.
//

import Foundation
import Foundation
import UIKit

extension UserDefaults {
    
    //User Tokenı get ve set etmek için kullanılan userdefaults metodları.
    static func setFirstLogin(login: Bool) {
        UserDefaults.standard.set(login, forKey: "FirstLogin")
    }
    
    static func getFirstLogin() -> Bool {
        return UserDefaults.standard.bool(forKey: "FirstLogin")
    }
    
    static func deleteUserDefaultsSettings() {
        let defaults   = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
}
