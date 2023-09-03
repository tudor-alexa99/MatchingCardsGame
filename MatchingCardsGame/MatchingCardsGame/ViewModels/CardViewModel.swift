//
//  CardViewModel.swift
//  MatchingCardsGame
//
//  Created by Tudor Alexa on 03.09.2023.
//

import Foundation

class CardViewModel: ObservableObject, Identifiable {
    var id = UUID()
    var card: Card
    
    init(card: Card) {
        self.card = card
    }
}
