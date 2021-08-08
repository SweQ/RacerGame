//
//  String+localized.swift
//  RacingGameApp
//
//  Created by alexKoro on 7/26/21.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
