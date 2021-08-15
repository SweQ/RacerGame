//
//  GameSettings.swift
//  RacingGameApp
//
//  Created by alexKoro on 6/6/21.
//

import UIKit

class GameSettings {
    static var playerName: String = "NoName"
    static var isControllerAcceleration: Bool = false
    static var playerCarImg: UIImage = UIImage(named: GameImage.playerCar1.rawValue) ?? UIImage()
    static var playerCarName = GameImage.playerCar1.rawValue

    static func saveSettings() {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(GameSettings.playerName, forKey: .playerName)
        userDefaults.setValue(GameSettings.isControllerAcceleration, forKey: .isControllerAcceleration)
        userDefaults.setValue(GameSettings.playerCarName, forKey: .playerCar)
    }

    static func loadSettings() {
        let userDefaults = UserDefaults.standard
        playerName = userDefaults.value(forKey: .playerName) as? String ?? playerName
        isControllerAcceleration = userDefaults.value(
            forKey: .isControllerAcceleration
        ) as? Bool ?? isControllerAcceleration
        playerCarName = userDefaults.value(forKey: .playerCar) as? String ?? GameImage.playerCar1.rawValue
        guard let carImage = UIImage(named: playerCarName) else { return }
        playerCarImg = carImage
    }
}
