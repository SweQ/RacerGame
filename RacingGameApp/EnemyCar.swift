//
//  EnemyCar.swift
//  RacerGame
//
//  Created by alexKoro on 8/7/21.
//

import Foundation
import UIKit

class EnemyCar: Car {
    var isOnRoad = false
    var enemySpeed: CGFloat = 10
    
    func goToStartPosition() {
        isOnRoad = false
        model.frame.origin.y = startPosition.y
    }
    
    func deleteFromView() {
        
    }
    
    func drive(to yPoint: CGFloat) {
        if model.frame.origin.y < yPoint {
            model.frame.origin.y += enemySpeed
            isOnRoad = true
        } else {
            isOnRoad = false
        }
    }
    
    deinit {
        print("enemy deinit")
    }
}
