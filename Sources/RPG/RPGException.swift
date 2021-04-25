//
//  RPGException.swift
//  
//
//  Created by Ariel Demarco on 25/04/2021.
//

import Foundation

@frozen enum RPGException: LocalizedError {
    case cannotHurtSelf
    case canOnlyHealOrAllySelf
    case enemyNotInRange
    case cannotHurtAlly
    
    var errorDescription: String? {
        switch self {
        case .cannotHurtSelf:
            return "A character cannot hurt himself"
        case .canOnlyHealOrAllySelf:
            return "A character can only heal himself or an ally"
        case .enemyNotInRange:
            return "Enemy is not in range"
        case .cannotHurtAlly:
            return "Cannot attack a character from the same Faction"
        }
    }
}
