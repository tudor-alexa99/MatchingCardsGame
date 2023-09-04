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
    var symbolValue: Int

    init(card: Card, symbolValue: Int) {
        self.card = card
        self.symbolValue = symbolValue
    }

    var isFaceUp: Bool {
        get { return card.isFaceUp }
        set { card.isFaceUp = newValue }
    }

    var isMatched: Bool {
        get { return card.isMatched }
        set { card.isMatched = newValue }
    }
}
