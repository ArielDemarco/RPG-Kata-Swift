//
//  Battlefield.swift
//  
//
//  Created by Ariel Demarco on 25/04/2021.
//

import Foundation

class Battlefield {
    private var charactersPosition: [RPGCharacter: Int]
    
    init(charactersPosition: [RPGCharacter: Int] = [:]) {
        self.charactersPosition = charactersPosition
    }
    
    func add(_ character: RPGCharacter, atPosition position: Int) {
        charactersPosition[character] = position
    }
    
    func isInRange(attacker: RPGCharacter, opponent: RPGCharacter) -> Bool {
        guard let attackerPosition = charactersPosition[attacker],
              let opponentPosition = charactersPosition[opponent] else { return false }
        return abs(attackerPosition - opponentPosition) <= attacker.maxRange
    }
}
