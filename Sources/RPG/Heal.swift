//
//  Heal.swift
//  
//
//  Created by Ariel Demarco on 25/04/2021.
//

import Foundation

struct Heal {
    func execute(healer: RPGCharacter, target: RPGCharacter, amount: Double) throws {
        guard healer == target else { throw RPGException.canOnlyHealSelf }
        target.receiveHealing(amount)
    }
}
