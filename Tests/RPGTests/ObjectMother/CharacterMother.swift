//
//  File.swift
//  
//
//  Created by Ariel Demarco on 29/04/2021.
//

@testable import RPG

struct CharacterMother {
    static func melee() -> MeleeCharacter {
        return MeleeCharacter()
    }
    
    static func ranged() -> RangedCharacter {
        return RangedCharacter()
    }
    
    static func `default`() -> RPGCharacter {
        return RPGCharacter()
    }
    
    static func ofFaction(_ faction: Faction, health: Double = 1000) -> RPGCharacter {
        let character = RPGCharacter(health: health)
        character.addFaction(faction)
        return character
    }
}
