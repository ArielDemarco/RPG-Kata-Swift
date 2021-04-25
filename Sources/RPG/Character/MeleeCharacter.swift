//
//  MeleeCharacter.swift
//  
//
//  Created by Ariel Demarco on 25/04/2021.
//

import Foundation

class MeleeCharacter: RPGCharacter {
    override init(health: Double = Constants.initialHealth,
                  level: Int = Constants.initialLevel) {
        super.init(health: health, level: level)
        self.maxRange = 2
    }
}
