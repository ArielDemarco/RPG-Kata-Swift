//
//  File.swift
//  
//
//  Created by Ariel Demarco on 29/04/2021.
//

@testable import RPG

struct CharacterMother {
    func meleeCharacter() -> MeleeCharacter {
        return MeleeCharacter()
    }
    
    func rangedCharacter() -> RangedCharacter {
        return RangedCharacter()
    }
    
    static func character(health: Double = 1000,
                          level: Int = 1,
                          faction: Faction? = nil) -> RPGCharacter {
        let character = RPGCharacter(health: health, level: level)
        if let faction = faction {
            character.addFaction(faction)
        }
        return character
    }
    
    static func ofFaction(_ faction: Faction, health: Double = 1000) -> RPGCharacter {
        let character = RPGCharacter(health: health)
        character.addFaction(faction)
        return character
    }
}
