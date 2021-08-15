//
//  UserDefaults+SetGetValue.swift
//  RacingGameApp
//
//  Created by alexKoro on 6/6/21.
//

import Foundation

extension UserDefaults {
    func setValue(_ value: Any?, forKey key: UserDefaultsKeys) {
        setValue(value, forKey: key.rawValue)
    }

    func value(forKey key: UserDefaultsKeys) -> Any? {
        return value(forKey: key.rawValue)
    }
}
