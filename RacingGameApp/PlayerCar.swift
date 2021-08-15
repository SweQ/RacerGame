//
//  PlayerCar.swift
//  RacerGame
//
//  Created by alexKoro on 8/7/21.
//

import Foundation
import UIKit

class PlayerCar: Car {
    private var turnConstant: CGFloat
    private let turnRotationConstant: CGFloat = 0.2
    var carIsTurning: Bool = false

    init(image: UIImage, size: CGSize, startPosition: CGPoint, turnConstant: CGFloat) {
        self.turnConstant = turnConstant
        super.init(image: image, size: size, startPosition: startPosition)
    }

    func turnToLeft() {
        model.transform = CGAffineTransform(rotationAngle: -turnRotationConstant)
        model.center.x -= turnConstant
    }

    func turnToRight() {
        model.transform = CGAffineTransform(rotationAngle: turnRotationConstant)
        model.center.x += turnConstant
    }

    func cancelTurn() {
        model.transform = CGAffineTransform.init(rotationAngle: 0)
    }
}
