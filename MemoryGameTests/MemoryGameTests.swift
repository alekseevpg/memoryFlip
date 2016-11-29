//
//  MemoryGameTests.swift
//  MemoryGameTests
//
//  Created by Pavel Alekseev on 27/11/2016.
//  Copyright © 2016 Pavel Alekseev. All rights reserved.
//

import XCTest
@testable import MemoryGame

class MemoryGameTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {

		let deck = Deck.create()
		assert(deck.count == 16)
	}

	func testCard()
	{
		let card1 = Card(animal: Animal.Beetle)
		let card2 = Card(animal: Animal.Beetle)

		assert(card1.description == "🐞")
		assert(card1 == card2)
	}
}
