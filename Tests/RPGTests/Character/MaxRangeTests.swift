//
//  File.swift
//  
//
//  Created by Ariel Demarco on 29/04/2021.
//

import XCTest
@testable import RPG

class MaxRangeTests: XCTestCase {
    private var aCharacter: RPGCharacter!
    private var opponent: RPGCharacter!
    private var battleField: Battlefield!
    
    override func setUpWithError() throws {
        givenCharacter()
    }
}

// MARK: - Iteration 3
extension MaxRangeTests {
    func testCharacter_onInit_hasMaxAttackRange() {
        onInitCharacter()
        thenCharacterHasMaxAttackRange()
    }
    
    func testMeleeCharacter_onInit_maxRngeIs2() {
        givenMeleeCharacter()
        thenCharacterMaxRangeIs(2)
    }
    
    func testRangedCharacter_onInit_maxRngeIs20() {
        givenRangedCharacter()
        thenCharacterMaxRangeIs(20)
    }
    
    func testCharacterFarAwayFromOpponent_onAttack_Misses() throws {
        givenMeleeCharacter()
        givenOpponentCharacter()
        givenMeleeCharacterIs(atRange: 3)
        XCTAssertThrowsError(try onCharacterAttackingOpponent())
    }
}

// MARK: - Private Methods
extension MaxRangeTests {
    func givenCharacter() {
        aCharacter = CharacterMother.default()
    }
    
    func givenOpponentCharacter() {
        opponent = CharacterMother.default()
    }
    
    func givenMeleeCharacter() {
        aCharacter = CharacterMother.melee()
    }
    
    func givenRangedCharacter() {
        aCharacter = CharacterMother.ranged()
    }
    
    func givenMeleeCharacterIs(atRange range: Int) {
        battleField = BattlefieldMother.withElements([aCharacter, opponent], distance: range)
    }
    
    func onInitCharacter() {
        givenCharacter()
    }
    
    func onCharacterAttackingOpponent() throws {
        try aCharacter.attack(opponent,
                              damage: Double.random(in: 0...1000),
                              battlefield: battleField)
    }
    
    func thenCharacterHasMaxAttackRange() {
        XCTAssertGreaterThanOrEqual(aCharacter.maxRange, 0)
    }
    
    func thenCharacterMaxRangeIs(_ range: Int) {
        XCTAssertEqual(aCharacter.maxRange, range)
    }
}
