//
//  RPGCharacter.swift
//  
//
//  Created by Ariel Demarco on 25/04/2021.
//

import Foundation

class RPGCharacter: BattlefieldElement, NonNeutralElement {
    private let attack: Attack
    private let heal: Heal
    var factions: Set<Faction>
    
    override init(health: Double = Constants.initialHealth,
         level: Int = Constants.initialLevel) {
        self.attack = Attack()
        self.heal = Heal()
        self.factions = []
        super.init(health: health, level: level)
    }
}

// MARK: - Interaction related methods
extension RPGCharacter {
    func attack(_ opponent: BattlefieldElement,
                damage: Double,
                battlefield: Battlefield) throws {
        if let nonNeutralElement = opponent as? NonNeutralElement,
           isAlly(of: nonNeutralElement) {
            throw RPGException.cannotHurtAlly
        }
        try attack.execute(attacker: self,
                           opponent: opponent,
                           damage: damage,
                           battlefield: battlefield)
    }
    
    func receiveHealing(_ amount: Double) {
        health += amount
    }
    
    func heal(_ character: RPGCharacter, amount: Double) throws {
        try heal.execute(healer: self, target: character, amount: amount)
    }
}

// MARK: - Faction Related Methods
extension RPGCharacter {
    func addFaction(_ faction: Faction) {
        factions.insert(faction)
    }
    
    func leaveFaction(_ faction: Faction) {
        factions.remove(faction)
    }
    
    func isAlly(of character: NonNeutralElement) -> Bool {
        return factions.first(where: { character.factions.contains($0) }) != nil
    }
}
