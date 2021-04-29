//
//  TargetableElementTests.swift
//  
//
//  Created by Ariel Demarco on 29/04/2021.
//

import XCTest
@testable import RPG

// MARK: - Iteration 5
class TargetableElementTests: XCTestCase {
    func testGivenTargetableElementHealthIsZero_thenElementIsDestroyed() {
        let npc = NPC(health: 0)
        XCTAssertTrue(npc.isDestroyed)
    }
    
    func testGivenTargetableElementHealthIsGreaterThanZero_thenElementIsNotDestroyed() {
        let npc = NPC(health: Double.random(in: 1...1000))
        XCTAssertFalse(npc.isDestroyed)
    }
    
    func testGivenCharacter_onAttackingNPC_healthIsReducedByAttackDamage() throws {
        let npc = NPC(health: 1000)
        let character = MeleeCharacter()
        let battleField = Battlefield()
        battleField.add(npc, atPosition: 0)
        battleField.add(character, atPosition: 1)
        try character.attack(npc, damage: 500, battlefield: battleField)
        XCTAssertEqual(npc.health, 500)
    }
}

class NPC: BattlefieldElement {
    var isDestroyed: Bool { !isAlive }
    
    init(health: Double = Constants.initialHealth) {
        super.init(health: health)
    }
}
