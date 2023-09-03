//
//  Card.swift
//  MatchingCardsGame
//
//  Created by Tudor Alexa on 03.09.2023.
//

import Foundation

struct Card: Identifiable {
    var id = UUID()
    
    var imageName: String
    var isFaceUp = false
    var isMatched = false
}
