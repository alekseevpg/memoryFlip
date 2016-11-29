//
//  ViewController.swift
//  MemoryGame
//
//  Created by Pavel Alekseev on 27/11/2016.
//  Copyright © 2016 Pavel Alekseev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

	private var collectionView: UICollectionView!
	private var deck: Deck!

	private var selectedIndexes = Array<IndexPath>()
	private var pairedIndexes = Array<IndexPath>()
	private var numberOfPairs = 0
	private var score = 0
	private var restartBtn : UIButton!
	private var timerLbl : UILabel!
	private var scoreLbl : UILabel!
	private var highscoreLbl : UILabel!

	private var timer : Timer?

	private var secondsPassed : Int = 0
	private var timerEnabled = true

	var deckSize: CGFloat {
		get {
			return 4
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = UIColor.white

		let topScore = Highscore.sharedInstance.getTopScore()

		timerLbl = createLbl(rect: CGRect(x: 0, y: 50, width: view.frame.width, height: 25), title: "Timer : 0")
		scoreLbl = createLbl(rect: CGRect(x: 0, y: 75, width: view.frame.width, height: 25), title: "Score : 0")
		highscoreLbl = createLbl(rect: CGRect(x: 0, y: 100, width: view.frame.width, height: 25), title: topScore)

		restartBtn = createRestartBtn(frame: CGRect(x: 0, y: 135, width: view.frame.width, height: 50),
		                              title: "Restart",
		                              action: #selector(restartGame))

		let space: CGFloat = 5

		let (covWidth, covHeight) = collectionViewSize(space: space)
		let layout = layoutCardSize(cardSize: cardSize(space: space), space: space)

		collectionView = UICollectionView(frame: CGRect(x: 0, y: 185, width: covWidth, height: covHeight),
		                                  collectionViewLayout: layout)
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.isScrollEnabled = false
		collectionView.register(CardCell.self, forCellWithReuseIdentifier: "cardCell")
		collectionView.backgroundColor = UIColor.white

		self.view.addSubview(collectionView)

		deck = initDeck()
		collectionView.reloadData()
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		stopTimer()
	}

	private func checkIfFinished(){
		if numberOfPairs == deck.count / 2 {
			stopTimer()
			Highscore.sharedInstance.saveHighscore(time: secondsPassed, score: score)
			restartBtn.isHidden = false
		}
	}

	private func initDeck() -> Deck {
		score = 0
		numberOfPairs = 0
		pairedIndexes = Array<IndexPath>()
		selectedIndexes = Array<IndexPath>()
		return Deck.create().shuffle()
	}

	func restartGame() {
		timerLbl.text = "Timer : 0"
		scoreLbl.text = "Score : 0"
		highscoreLbl.text = Highscore.sharedInstance.getTopScore()

		deck = initDeck()
		collectionView.reloadData()
		restartBtn.isHidden = true
		startTimer()
	}

	private func startTimer() {
		secondsPassed = 0
		timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerTicked), userInfo: nil, repeats: true)
	}

	private func stopTimer(){
		if timer != nil {
			timer!.invalidate()
			timer = nil
		}
	}

	func timerTicked() {
		secondsPassed = secondsPassed + 1
		timerLbl.text = "Timer : \(secondsPassed)"
	}

	private func turnCardsFaceDown(){
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			for index in self.selectedIndexes {
				let cardCell = self.collectionView.cellForItem(at: index)
					as! CardCell
				cardCell.downturn()
			}
			self.selectedIndexes = Array<IndexPath>()
		}
	}

	// MARK: CollectionViewDelegate

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if(timer == nil) {
			startTimer()
		}
		if selectedIndexes.count == 2 || selectedIndexes.contains(indexPath) ||
			pairedIndexes.contains(indexPath)
		{
			return
		}
		selectedIndexes.append(indexPath)
		let cell = collectionView.cellForItem(at: indexPath)
			as! CardCell

		score += 1
		scoreLbl.text = "Score : \(score)"

		cell.upturn()

		if selectedIndexes.count < 2 {
			return
		}
		let card1 = deck[selectedIndexes[0].row]
		let card2 = deck[selectedIndexes[1].row]

		if card1 == card2 {
			numberOfPairs += 1
			pairedIndexes.append(selectedIndexes[0])
			pairedIndexes.append(selectedIndexes[1])
			self.selectedIndexes = Array<IndexPath>()
			checkIfFinished()
		} else {
			turnCardsFaceDown()
		}
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return deck.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath as IndexPath) as! CardCell

		let card = deck[indexPath.row]
		cell.renderCardName(cardImageName: card.description)
		return cell
	}
}

private extension ViewController {

	func createRestartBtn(frame: CGRect, title: String, action: Selector) -> UIButton {
		let button = UIButton(frame: frame)
		button.setTitle(title, for: .normal)
		button.setTitleColor(UIColor.black, for: .normal)
		button.addTarget(self, action: action, for: .touchUpInside)
		button.isHidden = true
		view.addSubview(button)
		return button
	}

	func createLbl(rect: CGRect, title: String) -> UILabel
	{
		let label = UILabel(frame: rect)
		label.textColor = UIColor.black
		label.text = title
		label.textAlignment = NSTextAlignment.left
		view.addSubview(label)

		return label
	}

	func collectionViewSize(space: CGFloat) -> (CGFloat, CGFloat) {
		let size = cardSize(space: space)
		let covWidth = deckSize * (size + 2 * space)
		let covHeight = deckSize * (size + 2 * space)
		return (covWidth, covHeight)
	}

	func cardSize(space: CGFloat) -> (CGFloat) {
		let cardSize: CGFloat = view.frame.width / deckSize - 2 * space
		return (cardSize)
	}

	func layoutCardSize(cardSize: CGFloat, space: CGFloat) -> UICollectionViewLayout {
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
		layout.itemSize = CGSize(width: cardSize, height: cardSize)
		layout.minimumLineSpacing = space
		return layout
	}
}

