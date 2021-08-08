//
//  UIView+addShadow.swift
//  RacingGameApp
//
//  Created by alexKoro on 5/25/21.
//

import UIKit

extension UIView {
    func addShadow(color: UIColor, opacity: Float, offset: CGSize, radius: CGFloat) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
    }
}
