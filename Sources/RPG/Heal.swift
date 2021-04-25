//
//  Heal.swift
//  
//
//  Created by Ariel Demarco on 25/04/2021.
//

import Foundation

struct Heal {
    func execute(healer: RPGCharacter, target: RPGCharacter, amount: Double) throws {
        guard healer == target || healer.isAlly(of: target) else { throw RPGException.canOnlyHealOrAllySelf }
        target.receiveHealing(amount)
    }
}
