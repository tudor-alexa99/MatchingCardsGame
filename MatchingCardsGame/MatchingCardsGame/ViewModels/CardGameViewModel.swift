//
//  CardGameViewModel.swift
//  MatchingCardsGame
//
//  Created by Tudor Alexa on 03.09.2023.
//

import Foundation

class CardGameViewModel {
    var cards: [CardViewModel]
    var firstSelectedCard: CardViewModel?

    // MARK: Initializers

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

    // MARK: - Public

    /** Card tapped action */
    func choose(card: CardViewModel) {
        // if the card has already been matched, don't do anything
        guard card.card.isMatched == false else { return }

        // if this is the first selected card, save it and continue
        if firstSelectedCard == nil {
            firstSelectedCard = card
            firstSelectedCard?.card.isFaceUp = true
            return
        }
        
        // if the card that has been selected is the same one, flip it back
        if card.card.id == firstSelectedCard?.card.id {
            firstSelectedCard = nil
            card.card.isFaceUp = false
            return
        }

        // if 2 cards have been selected, check if they match
        if firstSelectedCard!.card.imageName == card.card.imageName {
            self.matchingCards(firstCardVM: firstSelectedCard!, secondCardVM: card)
        } else {
            
        }
    }

    /** Restart game */
    
    /** Flip all the card that are not matched back */
    func flipAllUnmatchedCardsBack() {
        for cardVM in cards {
            if cardVM.card.isFaceUp && !cardVM.card.isMatched {
                cardVM.card.isFaceUp = false
            }
        }
    }

    // MARK: - Private

    /** When a card has already been selected */

    /** Matching cards logic */
    private func matchingCards(firstCardVM: CardViewModel, secondCardVM: CardViewModel) {
        // mark the cards as matched and reset the variable
        firstCardVM.card.isMatched = true
        secondCardVM.card.isMatched = true
        firstSelectedCard = nil
    }
    
    /** Not matching pair logic */
    private func notMathcingCards() {
        // flip the cards that do not match back and reset the selected one
        self.firstSelectedCard = nil
        
    }

    /** Compute points */
    
}
