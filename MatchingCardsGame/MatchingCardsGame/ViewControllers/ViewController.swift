//
//  ViewController.swift
//  MatchingCardsGame
//
//  Created by Tudor Alexa on 03.09.2023.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // MARK: - IBOutlets

    @IBOutlet var cardsContainerCollectionview: UICollectionView!
    @IBOutlet var actionButton: UIButton!
    @IBOutlet var scoreLabel: UILabel!
    @IBAction func buttonTappedAction(_ sender: Any) {
        self.viewModel.resetAllCardsAndShuffle()
        self.cardsContainerCollectionview.reloadData()
    }
    // MARK: - Variables

    var viewModel: CardGameViewModel = CardGameViewModel()

    // MARK: - Initializers + View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // setup collection view properties
        cardsContainerCollectionview.dataSource = self
        cardsContainerCollectionview.delegate = self

        // register custom card cell
        cardsContainerCollectionview.register(UINib(nibName: "CardCell", bundle: nil), forCellWithReuseIdentifier: "CardCell")
    }
    // MARK: - Private
    

    // MARK: - Collection View Stubs

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cards.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Dequeue a reusable cell using the registered identifier
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as? CardCell else {
            fatalError("Unable to dequeue CardCell")
        }

        // Get the view model and configure the cell
        let currentViewModel = viewModel.cards[indexPath.row]
        cell.configure(with: currentViewModel)

        return cell
    }
    
    /** Distance between item cells */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    /** Cell Margin */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    /** When tapping a card in the deck */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Get the selected cell
        if let cell = collectionView.cellForItem(at: indexPath) as? CardCell {
            // get the corresponding view model
            let currentViewModel = self.viewModel.cards[indexPath.row]
            
            // if the card is already matched, return
            guard currentViewModel.card.isMatched == false else { return }
            
            let isFaceUp = currentViewModel.card.isFaceUp
            
            // Perform the flip animation
            cell.animateRotation(isFaceUp: isFaceUp)
            
            viewModel.choose(card: currentViewModel)
        }
    }
}
