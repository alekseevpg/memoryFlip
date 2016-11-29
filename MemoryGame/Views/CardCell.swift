//
//  CardCell.swift
//  MemoryGame
//
//  Created by Pavel Alekseev on 27/11/2016.
//  Copyright © 2016 Pavel Alekseev. All rights reserved.
//

import Foundation
import UIKit

class CardCell: UICollectionViewCell, CAAnimationDelegate {

	private let closedColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
	private let openColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)

	private var cardImageName: String!
	private var backImageName: String!

	private let label: UILabel!

	override init(frame: CGRect) {
		label = UILabel(frame: CGRect(x: 0, y: 0,
		                              width: frame.size.width,
		                              height: frame.size.height))
		label.font = label.font.withSize(20)
		label.textAlignment = NSTextAlignment.center
		label.backgroundColor = UIColor.clear
		super.init(frame: frame)
		contentView.backgroundColor = closedColor

		self.contentView.layer.shadowColor = UIColor.lightGray.cgColor
		self.contentView.layer.shadowOffset = CGSize(width:0,height: 0.5)
		self.contentView.layer.shadowRadius = 0.5
		self.contentView.layer.shadowOpacity = 0.5
		self.contentView.layer.masksToBounds = false
		self.contentView.layer.cornerRadius = 2.0
		contentView.addSubview(label)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func renderCardName(cardImageName: String){
		self.cardImageName = cardImageName
		label.text = ""
	}

	func upturn() {
		UIView.transition(with: contentView,
		                  duration: 1,
		                  options: [.transitionFlipFromRight, .allowAnimatedContent],
		                  animations: {
							self.contentView.backgroundColor = self.openColor
							self.label.text = self.cardImageName
			}, completion: nil)

	}

	func downturn() {
		UIView.transition(with: contentView,
		                  duration: 1,
		                  options: .transitionFlipFromLeft,
		                  animations: {
							self.contentView.backgroundColor = self.closedColor
							self.label.text = ""
		}, completion: nil)
	}
}
