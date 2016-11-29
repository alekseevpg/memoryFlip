//
//  Highscore.swift
//  MemoryGame
//
//  Created by Pavel Alekseev on 27/11/2016.
//  Copyright © 2016 Pavel Alekseev. All rights reserved.
//

import Foundation

let kTopTimeUserDefaultsKey = "TopTime"
let kTopScoreUserDefaultsKey = "TopScore"

class Highscore {
	static let sharedInstance = Highscore()

	func getTopScore() -> String {
		let (topTime, topScore) = getTopScore()
		return "TopScore : \(topTime) TopTime : \(topScore)"
	}

	func saveHighscore(time: Int, score: Int) {
		let (_, topScore) = getTopScore()
		if  topScore == 0 || score < topScore {
			userDefaults().set(time, forKey: kTopTimeUserDefaultsKey)
			userDefaults().set(score, forKey: kTopScoreUserDefaultsKey)
		}
	}

	private func getTopScore() -> (Int, Int) {
		let topTime = userDefaults().integer(forKey: kTopTimeUserDefaultsKey)
		let topScore = userDefaults().integer(forKey: kTopScoreUserDefaultsKey)

		return (topTime, topScore)
	}

	private func userDefaults() -> UserDefaults {
		return UserDefaults.standard
	}
}
