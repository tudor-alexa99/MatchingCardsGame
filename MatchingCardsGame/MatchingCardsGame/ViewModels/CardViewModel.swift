//
//  CardViewModel.swift
//  MatchingCardsGame
//
//  Created by Tudor Alexa on 03.09.2023.
//

import Foundation

class CardViewModel: ObservableObject, Identifiable {
    var id = UUID()
    private var card: Card

    init(card: Card) {
        self.card = card
    }

    var isFaceUp: Bool {
        get { return card.isFaceUp }
        set { card.isFaceUp = newValue }
    }

    var imageName: String {
        return card.imageName
    }

    var isMatched: Bool {
        get { return card.isMatched }
        set { card.isMatched = newValue }
    }
}
