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
    }
    
    func configure(with viewModel: CardViewModel) {
        // setup the view depending on the state of the view model
    }
    
}
