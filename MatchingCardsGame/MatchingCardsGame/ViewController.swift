//
//  ViewController.swift
//  MatchingCardsGame
//
//  Created by Tudor Alexa on 03.09.2023.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK: - IBOutlets

    @IBOutlet var cardsContainerCollectionview: UICollectionView!
    @IBOutlet var actionButton: UIButton!

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // setup collection view properties
        cardsContainerCollectionview.dataSource = self
        cardsContainerCollectionview.delegate = self
    }
    
    // MARK: - Collection View Stubs
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
}
