//
//  CardGameViewModel.swift
//  MatchingCardsGame
//
//  Created by Tudor Alexa on 03.09.2023.
//

import Foundation

class CardGameViewModel: ObservableObject {
    @Published var cards: [CardViewModel]

    init() {
        cards = []

        // generate a new game of cards
        for _ in 1 ... 8 {
            cards.append(CardViewModel(card: Card(imageName: "globe", isFaceUp: false, isMatched: false)))
        }
    }

    init(cards: [CardViewModel]) {
        self.cards = cards
    }

    func choose(card: CardViewModel) {
        print("Card tapped")
    }
}
