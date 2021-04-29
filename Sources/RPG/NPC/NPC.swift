//
//  File.swift
//  
//
//  Created by Ariel Demarco on 29/04/2021.
//

import Foundation

class NPC: BattlefieldElement {
    var isDestroyed: Bool { !isAlive }
    
    init(health: Double = Constants.initialHealth) {
        super.init(health: health)
    }
}
