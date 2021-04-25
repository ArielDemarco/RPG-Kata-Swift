//
//  RPGCharacter.swift
//  
//
//  Created by Ariel Demarco on 25/04/2021.
//

import Foundation

typealias Faction = String

class RPGCharacter: NSObject {
    struct Constants {
        static let initialHealth: Double = 1000
        static let maximumHealth: Double = 1000
        static let initialLevel: Int = 1
    }
    private let attack: Attack
    private let heal: Heal
    private(set) var factions: Set<Faction>
    private(set) var level: Int
    private(set) var health: Double {
        didSet {
            health = max(0, min(health, Constants.maximumHealth))
        }
    }
    open var maxRange: Int
    var isAlive: Bool {
        health > 0
    }
    
    init(health: Double = Constants.initialHealth,
         level: Int = Constants.initialLevel) {
        self.health = health
        self.level = level
        self.attack = Attack()
        self.heal = Heal()
        self.maxRange = 0
        self.factions = []
    }
    
    func addFaction(_ faction: Faction) {
        factions.insert(faction)
    }
    
    func leaveFaction(_ faction: Faction) {
        factions.remove(faction)
    }
    
    func receiveDamage(of damageAmount: Double) {
        health -= damageAmount
    }
    
    func attack(_ opponent: RPGCharacter,
                damage: Double,
                battlefield: Battlefield) throws {
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
    
    func isAlly(of character: RPGCharacter) -> Bool {
        return factions.first(where: { character.factions.contains($0) }) != nil 
    }
}
