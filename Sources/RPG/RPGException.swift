//
//  RPGException.swift
//  
//
//  Created by Ariel Demarco on 25/04/2021.
//

import Foundation

@frozen enum RPGException: LocalizedError {
    case cannotHurtSelf
    case canOnlyHealSelf
    case enemyNotInRange
    
    var errorDescription: String? {
        switch self {
        case .cannotHurtSelf:
            return "A character cannot hurt himself"
        case .canOnlyHealSelf:
            return "A character can only heal himself"
        case .enemyNotInRange:
            return "Enemy is not in range"
        }
    }
}
