//
//  Records.swift
//  RacingGameApp
//
//  Created by alexKoro on 6/6/21.
//

import Foundation

class Record: Codable {
    var playerName: String
    var score: Int
    var date: Date = Date()
    
    init(playerName: String, score: Int) {
        self.playerName = playerName
        self.score = score
    }
 
}
