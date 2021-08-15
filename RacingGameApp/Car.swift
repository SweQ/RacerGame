//
//  Car.swift
//  RacerGame
//
//  Created by alexKoro on 8/7/21.
//

import Foundation
import UIKit

class Car {
    var model: UIImageView
    var startPosition: CGPoint
    private var size: CGSize

    init(image: UIImage, size: CGSize, startPosition: CGPoint) {
        self.model = UIImageView(image: image)
        self.size = size
        self.model.contentMode = .scaleAspectFill
        // self.model.backgroundColor = .orange
        self.model.bounds.size = size
        self.model.center = startPosition
        self.startPosition = startPosition
    }
}
