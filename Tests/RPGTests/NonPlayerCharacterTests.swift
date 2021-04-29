//
//  NonPlayerCharacterTests.swift
//  
//
//  Created by Ariel Demarco on 29/04/2021.
//

import XCTest
@testable import RPG

// MARK: - Iteration 5
class NonPlayerCharacterTests: XCTestCase {
    private var npc: NPC!
    private var aCharacter: RPGCharacter!
    private var battlefield: Battlefield!
    
    func testGivenNPCHealthIsZero_thenIsDestroyed() {
        givenNPC(health: .zero)
        thenIsDestroyed()
    }
    
    func testGivenNPCHealthIsGreaterThanZero_thenIsNotDestroyed() {
        givenNPC(health: Double.random(in: 1...1000))
        thenIsNotDestroyed()
    }
    
    func testGivenCharacter_onAttackingNPC_healthIsReducedByAttackDamage() throws {
        givenNPC(health: 1000)
        givenCharacter()
        givenElementsAreInBattlefield()
        givenElementsAreInBattlefield()
        XCTAssertNoThrow(try whenCharacterAttacksNpc(by: 500))
        thenNPCHealthIs(500)
    }
}

// MARK: - Private Methods
private extension NonPlayerCharacterTests {
    func givenNPC(health: Double) {
        npc = NPC(health: health)
    }
    
    func givenCharacter() {
        aCharacter = CharacterMother.default()
    }
    
    func givenElementsAreInBattlefield() {
        battlefield = BattlefieldMother.withElements([npc, aCharacter])
    }
    
    func whenCharacterAttacksNpc(by damage: Double) throws {
        try aCharacter.attack(npc, damage: damage, battlefield: battlefield)
    }
    
    func thenIsDestroyed() {
        XCTAssertTrue(npc.isDestroyed)
    }
    
    func thenIsNotDestroyed() {
        XCTAssertFalse(npc.isDestroyed)
    }
    
    func thenNPCHealthIs(_ amount: Double) {
        XCTAssertEqual(npc.health, amount)
    }
}
