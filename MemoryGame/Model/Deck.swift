//
//  Deck.swift
//  MemoryGame
//
//  Created by Pavel Alekseev on 27/11/2016.
//  Copyright © 2016 Pavel Alekseev. All rights reserved.
//

import Foundation
struct Deck {

	private var cards = [Card]()

	var count: Int {
		get {
			return cards.count
		}
	}

	subscript(index: Int) -> Card {
		get {
			return cards[index]
		}
	}

	static func create() -> Deck {
		var deck = Deck()

		for animal in Animal.allValues{
			let card1 = Card(animal: animal)
			let card2 = Card(animal: animal)
			deck.cards.append(card1)
			deck.cards.append(card2)
		}

		return deck
	}

	func shuffle() -> Deck {
		var list = cards
		for i in 0..<(list.count - 1) {
			let random = Int(arc4random_uniform(UInt32(list.count - i)))
			let j = random + i
			if(i != j)
			{
				swap(&list[i], &list[j])
			}
		}
		return Deck(cards: list)
	}
}
