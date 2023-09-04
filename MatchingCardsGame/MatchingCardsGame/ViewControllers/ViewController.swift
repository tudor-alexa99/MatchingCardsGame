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
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var gameOverLabel: UILabel!
    @IBAction func buttonTappedAction(_ sender: Any) {
        if viewModel.hasGameStarted {
            resetGame()
        } else {
            startGame()
        }
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

        // setup the callback handles
        viewModel.flipCardCallback = flipCardsOnDeckAnimation
        viewModel.updateCountdownLabelCallback = updateCountdownLabel
        viewModel.updateScoreCallback = updateScoreLabel

        if !viewModel.hasGameStarted {
            actionButton.titleLabel?.text = "Start game"
        }

        // hide the game over label
        gameOverLabel.isHidden = true

        setupThemeSwitcher()
    }

    /** Create a switch theme button in the navigation bar */
    func setupThemeSwitcher() {
        let themeSwitcherButton = UIBarButtonItem(title: "Theme 🔮", style: .plain, target: self, action: #selector(switchThemeTapped))
        
        // Add it to the nav bar
        navigationItem.rightBarButtonItem = themeSwitcherButton
    }

    // MARK: - Private

    @objc private func switchThemeTapped() {
        // go to the next theme
        ThemeManager.shared.incrementToNextTheme()
        
        // Update the UI to reflect the new theme
        updateUIForCurrentTheme()
    }
    
    private func updateUIForCurrentTheme() {
        // Retrieve the current theme from UserDefaults or any other source
        let currentTheme = ThemeManager.shared.getCurrentTheme()

        // Apply the theme to the UI components
        navigationItem.title = currentTheme.title
        
        cardsContainerCollectionview.reloadData()
    }
    
    private func flipCardsOnDeckAnimation(index: Int, isFacingUp: Bool) {
        // get the index path for the cell that has to be flipped
        let indexPath = IndexPath(item: index, section: 0)

        // get the corresponding cell
        if let cell = cardsContainerCollectionview.cellForItem(at: indexPath) as? CardCell {
            // redraw the cell and animate the rotation
            cell.configure(with: viewModel.cards[index])
            cell.animateRotation(isFaceUp: isFacingUp)
        }
    }

    private func startGame() {
        // start the countdown timer
        viewModel.startCountdown()
        viewModel.hasGameStarted = true
        actionButton.setTitle("Reset Game", for: .normal)

        // hide the game over label and show the grid
        gameOverLabel.isHidden = true
        cardsContainerCollectionview.isHidden = false
    }

    private func resetGame() {
        // reset all the values to the initial state
        viewModel.resetAllCardsAndShuffle()
        cardsContainerCollectionview.reloadData()
        actionButton.setTitle("Start Game", for: .normal)
        viewModel.stopCountdown()
        viewModel.remainingTime = 60
        viewModel.totalScore = 0
        viewModel.hasGameStarted = false
    }

    private func endGame() {
        // hide the collection view and show the Game Over message instead
        cardsContainerCollectionview.isHidden = true
        gameOverLabel.isHidden = false

        // show the user his final score
        gameOverLabel.text = "Game Over! Your final score is \(viewModel.totalScore)"

        actionButton.setTitle("Restart Game", for: .normal)
    }

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
        guard viewModel.hasGameStarted == true else { return }

        // Get the selected cell
        if collectionView.cellForItem(at: indexPath) is CardCell {
            // get the corresponding view model
            let currentViewModel = viewModel.cards[indexPath.row]

            // if the card is already matched, return
            guard currentViewModel.isMatched == false else { return }

            viewModel.choose(cardIndex: indexPath.row)
        }
    }

    // MARK: - Countdown logic

    func updateCountdownLabel(with time: TimeInterval) {
        timeLabel.text = String(format: "%.0f seconds", time)
        // if you ran out of time, end the game
        if time == 0 {
            endGame()
        }
    }

    func updateScoreLabel(with score: Int) {
        scoreLabel.text = "Score: \(score)"
    }
}
