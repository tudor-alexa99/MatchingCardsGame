//
//  CardCell.swift
//  MatchingCardsGame
//
//  Created by Tudor Alexa on 03.09.2023.
//

import UIKit

class CardCell: UICollectionViewCell {
    // MARK: - IBOutlets

    @IBOutlet var cardBackView: UIView!
    @IBOutlet var cardFrontView: UIView!
    @IBOutlet var symbolImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        // TODO: Setup Z indexes on views
    }

    func configure(with viewModel: CardViewModel) {
        // setup the view depending on the state of the view model
    }

    func animateRotation(isFaceUp: Bool) {
        
        // Check if the card is currently face up or face down
        let fromView = isFaceUp ? cardFrontView : cardBackView
        let toView = isFaceUp ? cardBackView : cardFrontView

        // Flip animation
        UIView.transition(from: fromView!, to: toView!, duration: 0.5, options: [.transitionFlipFromLeft, .showHideTransitionViews]) { _ in
            // This completion block can be used for any additional logic after the flip animation
        }
    }
}
