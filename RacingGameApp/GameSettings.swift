//
//  GameSettings.swift
//  RacingGameApp
//
//  Created by alexKoro on 6/6/21.
//

import UIKit

class GameSettings {
    static var playerName: String = "NoName"
    static var enemy: UIImage = UIImage(named: "enemy1_image") ?? UIImage()
    static var enemyName: String = "enemy1_image"
    static var isControllerAcceleration: Bool = false
    
    static func saveSettings() {
        let userDefaults = UserDefaults.standard
        
        userDefaults.setValue(GameSettings.playerName, forKey: .playerName)
        userDefaults.setValue(GameSettings.enemyName, forKey: .enemyType)
        userDefaults.setValue(GameSettings.isControllerAcceleration, forKey: .isControllerAcceleration)
        
    }
    
    static func loadSettings() {
        let userDefaults = UserDefaults.standard
        enemyName = userDefaults.value(forKey: .enemyType) as? String ?? enemyName
        enemy = UIImage(named: enemyName) ?? UIImage()
        playerName = userDefaults.value(forKey: .playerName) as? String ?? playerName
        isControllerAcceleration = userDefaults.value(forKey: .isControllerAcceleration) as? Bool ?? isControllerAcceleration
    }
}

