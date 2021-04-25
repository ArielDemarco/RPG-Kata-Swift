//
//  Attack.swift
//  
//
//  Created by Ariel Demarco on 25/04/2021.
//

import Foundation

struct Attack {
    func execute(attacker: RPGCharacter,
                 opponent: RPGCharacter,
                 damage: Double,
                 battlefield: Battlefield) throws {
        guard attacker != opponent else { throw RPGException.cannotHurtSelf }
        guard attacker.factions.first(where: { opponent.factions.contains($0) }) == nil else {
            throw RPGException.cannotHurtAlly
        }
        guard battlefield.isInRange(attacker: attacker,
                                    opponent: opponent) else { throw RPGException.enemyNotInRange }
        let totalDamage = calculateDamage(fromAmount: damage,
                                          attackerLevel: attacker.level,
                                          opponentLevel: opponent.level)
        opponent.receiveDamage(of: totalDamage)
    }
    
    private func calculateDamage(fromAmount baseAmount: Double,
                                 attackerLevel: Int,
                                 opponentLevel: Int) -> Double {
        var totalDamage = baseAmount
        if opponentLevel >= attackerLevel + 5 {
            totalDamage *= 0.5
        } else if opponentLevel + 5 <= attackerLevel {
            totalDamage *= 1.5
        }
        return totalDamage
    }
}
