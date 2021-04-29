//
//  Battlefield.swift
//  
//
//  Created by Ariel Demarco on 25/04/2021.
//

import Foundation

class Battlefield {
    private var charactersPosition: [BattlefieldElement: Int]
    
    init(charactersPosition: [BattlefieldElement: Int] = [:]) {
        self.charactersPosition = charactersPosition
    }
    
    func add(_ character: BattlefieldElement, atPosition position: Int) {
        charactersPosition[character] = position
    }
    
    func isInRange(attacker: BattlefieldElement, opponent: BattlefieldElement) -> Bool {
        guard let attackerPosition = charactersPosition[attacker],
              let opponentPosition = charactersPosition[opponent] else { return false }
        return abs(attackerPosition - opponentPosition) <= attacker.maxRange
    }
}
