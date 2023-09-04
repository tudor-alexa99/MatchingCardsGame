//
//  CardGameViewModel.swift
//  MatchingCardsGame
//
//  Created by Tudor Alexa on 03.09.2023.
//

import Foundation

class CardGameViewModel {
    // MARK: - Variables

    var cards: [CardViewModel]
    var firstSelectedCard: Int?
    var flipCardCallback: ((Int, Bool) -> Void)?
    var updateCountdownLabelCallback:((TimeInterval) -> Void)?
    var updateScoreCallback:((Int) -> Void)?
    var isCountdownRunning: Bool = false
    var countdownTimer: Timer?
    var correctStreak = 1 // will be used to count how many correct in a row there will be
    var totalScore = 0 {
        didSet {
            updateScoreCallback?(totalScore)
        }
    }
    var remainingTime: TimeInterval = 60 {
        didSet {
            updateCountdownLabelCallback?(remainingTime)
        }
    }

    // MARK: - Initializers

    init() {
        cards = []

        // generate a new game of cards
        for i in 1 ... 8 {
            cards.append(CardViewModel(card: Card(imageName: i % 2 == 0 ? "globe" : "phone", isFaceUp: false, isMatched: false)))
        }
    }

    init(cards: [CardViewModel]) {
        self.cards = cards
    }

    // MARK: - Public

    /** Card tapped action */
    func choose(cardIndex: Int) {
        let card = cards[cardIndex]

        // if the card has already been matched, don't do anything
        guard card.isMatched == false else { return }

        // if this is the first selected card, save it and continue
        if firstSelectedCard == nil {
            card.isFaceUp = true
            firstSelectedCard = cardIndex
            flipCardCallback?(cardIndex, false)
            correctStreak = 1
            return
        }

        // if the card that has been selected is the same one, flip it back
        if cardIndex == firstSelectedCard! {
            firstSelectedCard = nil
            card.isFaceUp = false
            flipCardCallback?(cardIndex, true)
            correctStreak = 1
            return
        }

        let firstCard = cards[firstSelectedCard!]

        // flip the second selected card
        card.isFaceUp = true
        flipCardCallback?(cardIndex, false)

        // if 2 cards have been selected, check if they match
        if firstCard.imageName == card.imageName {
            matchingCards(firstCardVM: firstCard, secondCardVM: card)
        } else {
            firstSelectedCard = nil
            DispatchQueue.main.async {
                self.flipAllUnmatchedCardsBack()
            }
        }
    }

    /** Restart game */

    /** Flip all the card that are not matched back */
    func flipAllUnmatchedCardsBack() {
        for cardIndice in cards.indices {
            if cards[cardIndice].isFaceUp && !cards[cardIndice].isMatched {
                cards[cardIndice].isFaceUp = false
                flipCardCallback?(cardIndice, true)
            }
        }
    }

    /** Reverse all the cards */
    func resetAllCardsAndShuffle() {
        for cardIndice in cards.indices {
            let cardVM = cards[cardIndice]
            if cardVM.isFaceUp {
                flipCardCallback?(cardIndice, true)
            }
            cardVM.isMatched = false
            cardVM.isFaceUp = false
        }

        cards.shuffle()
    }

    // MARK: - Private

    /** When a card has already been selected */

    /** Matching cards logic */
    private func matchingCards(firstCardVM: CardViewModel, secondCardVM: CardViewModel) {
        // mark the cards as matched and reset the variable
        firstCardVM.isMatched = true
        secondCardVM.isMatched = true
        firstSelectedCard = nil
        
        // add 2 points for each matched card, and multiply by streak
        totalScore += correctStreak * 2
        correctStreak += 1
    }

    /** Not matching pair logic */
    private func notMathcingCards() {
        // flip the cards that do not match back and reset the selected one
        firstSelectedCard = nil
    }

    // MARK: - Timer + Countdown

    /** Create and start a new countdown */
    func startCountdown() {
        isCountdownRunning = true

        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }

            // decrease the time each second
            if self.remainingTime > 0 {
                self.remainingTime -= 1
            } else {
                // stop the timer
                timer.invalidate()
                self.isCountdownRunning = false
                // TODO: change method to Game Over
                self.resetAllCardsAndShuffle()
            }
        }
    }

    func stopCountdown() {
        countdownTimer?.invalidate()
        isCountdownRunning = false
    }
}
