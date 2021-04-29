//
//  File.swift
//  
//
//  Created by Ariel Demarco on 29/04/2021.
//

import Foundation

class BattlefieldElement: NSObject {
    struct Constants {
        static let initialHealth: Double = 1000
        static let maximumHealth: Double = 1000
        static let initialLevel: Int = 1
    }
    open var maxRange: Int
    var level: Int
    var health: Double {
        didSet {
            health = max(0, min(health, Constants.maximumHealth))
        }
    }
    
    var isAlive: Bool {
        health > 0
    }
    
    init(health: Double = Constants.initialHealth,
         level: Int = Constants.initialLevel) {
        self.health = health
        self.level = level

        self.maxRange = 0
    }
    
    func receiveDamage(of damageAmount: Double) {
        health -= damageAmount
    }
}
