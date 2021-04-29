//
//  File.swift
//  
//
//  Created by Ariel Demarco on 29/04/2021.
//

@testable import RPG

struct BattlefieldMother {
    static func withElements(_ elements: [BattlefieldElement], distance: Int = 0) -> Battlefield {
        let battlefield = Battlefield()
        var position = 0
        elements.forEach({
            battlefield.add($0, atPosition: position)
            position += distance
        })
        return battlefield
    }
}
