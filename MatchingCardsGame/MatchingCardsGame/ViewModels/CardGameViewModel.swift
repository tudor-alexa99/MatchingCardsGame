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
    var updateCountdownLabelCallback: ((TimeInterval) -> Void)?
    var updateScoreCallback: ((Int) -> Void)?
    var isCountdownRunning: Bool = false
    var countdownTimer: Timer?
    var correctStreak = 1 // will be used to count how many correct in a row there will be
    var hasGameStarted = false
    var currentTheme = ThemeManager.shared.getCurrentTheme()
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

        // create a list of pairs for the card symbols
        let pairValues = Array.generatePairs(maximumNumberOfPairs: 4)

        // generate a new game of cards
        for i in 1 ... 8 {
            cards.append(CardViewModel(card: Card(), symbolValue: pairValues[i - 1]))
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
        if firstCard.symbolValue == card.symbolValue {
            matchingCards(firstCardVM: firstCard, secondCardVM: card)
        } else {
            firstSelectedCard = nil
            
            // this will happen aync for the animation to have time to show the second card first and then reverse
            DispatchQueue.main.async { [weak self] in
                self?.flipAllUnmatchedCardsBack()
            }
        }
    }

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

        firstSelectedCard = nil
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

        // check if the deck is complete and shuffle again
        checkCompleteAndShuffle()
    }

    /** All cards have been matched, continue game */
    private func checkCompleteAndShuffle() {
        // check if there are no more unmatched cards
        if cards.first(where: { $0.isMatched == false }) != nil { return }

        // increase the score
        totalScore += 5

        resetAllCardsAndShuffle()
    }

    // MARK: - Timer + Countdown

    /** Create and start a new countdown */
    func startCountdown() {
        isCountdownRunning = true

        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self else { return }

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
