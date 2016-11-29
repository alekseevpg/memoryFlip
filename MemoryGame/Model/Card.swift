//
//  File.swift
//  MemoryGame
//
//  Created by Pavel Alekseev on 27/11/2016.
//  Copyright © 2016 Pavel Alekseev. All rights reserved.
//

import Foundation

struct Card: Equatable {
	let animal: Animal

	var description: String {
		return "\(animal.rawValue)"
	}
}

func ==(card1: Card, card2: Card) -> Bool {
	return card1.animal == card2.animal
}
