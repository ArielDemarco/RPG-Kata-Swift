//
//  File.swift
//  
//
//  Created by Ariel Demarco on 24/04/2021.
//

import XCTest
@testable import RPG

class CharacterTests: XCTestCase {
    private var aCharacter: RPGCharacter!
    
    override func setUp() {
        aCharacter = RPGCharacter()
    }
}

// MARK: - Iteration 1
extension CharacterTests {
    func testCharacter_onInit_healthIs1000() {
        XCTAssertEqual(aCharacter.health, 1000)
    }
    
    func testCharacter_onInit_levelIs1() {
        XCTAssertEqual(aCharacter.level, 1)
    }
    
    func testCharacter_onInit_isAlive() {
        XCTAssertTrue(aCharacter.isAlive)
    }
    
    func testCharacter_receiveDamage_substractHealthEqualToDamageReceived() throws {
        givenCharacter(initialHealth: 1000)
        whenCharacterReceivesDamage(amount: 100)
        try thenCharacterHealthIs(900)
    }
    
    func testCharater_receiveDamageSuperiorToHealth_characterHealthIsZero() throws {
        givenCharacter(initialHealth: 1000)
        whenCharacterReceivesDamage(amount: 2000)
        try thenCharacterHealthIs(0)
    }
    
    func testCharacter_receiveDamageSuperiorToHealth_characterIsDead() {
        givenCharacter(initialHealth: 1000)
        whenCharacterReceivesDamage(amount: 1000)
        thenCharacterIsDead()
    }
    
    func testCharacter_dealsDamage() throws {
        let attacker = RPGCharacter()
        let opponent = RPGCharacter(health: 1000)
        let battleField = Battlefield()
        battleField.add(attacker, atPosition: 0)
        battleField.add(opponent, atPosition: 0)
        try attacker.attack(opponent, damage: 100, battlefield: battleField)
        XCTAssertEqual(opponent.health, 900)
    }
    
    func testCharacter_receivesHealing_addsHealingAmountToActualHealth() throws {
        givenCharacter(initialHealth: 500)
        try whenCharacterIsHealed(by: 400)
        try thenCharacterHealthIs(900)
    }
    
    func testCharacter_receivesHealing_healthCannotGoBeyond1000() throws {
        givenCharacter(initialHealth: 900)
        try whenCharacterIsHealed(by: 200)
        try thenCharacterHealthIs(1000)
    }
}

// MARK: - Iteration 2
extension CharacterTests {
    func testCharacter_onAttackHimself_throwsException() {
        XCTAssertThrowsError(try aCharacter.attack(aCharacter, damage: .random(in: 0...1000), battlefield: Battlefield()))
    }
    
    func testCharacter_canOnlyHealsHimself() throws {
        let damagedCharacter = RPGCharacter(health: 300)
        try damagedCharacter.heal(600)
        XCTAssertEqual(damagedCharacter.health, 900)
    }
    
    func testCharacter_onAttackCharacter5levelsAbove_opponentReceivesHalfDamage() throws {
        let attacker = RPGCharacter(level: 2)
        let opponent = RPGCharacter(health: 1000, level: 7)
        let battleField = Battlefield()
        battleField.add(attacker, atPosition: 0)
        battleField.add(opponent, atPosition: 0)
        try attacker.attack(opponent, damage: 1000, battlefield: battleField)
        XCTAssertEqual(opponent.health, 500)
    }
    
    func testCharacter_onAttackCharacter5levelsBelow_opponentReceives50PercentMoreDamage() throws {
        let attacker = RPGCharacter(level: 7)
        let opponent = RPGCharacter(health: 1000, level: 2)
        let battlefield = Battlefield()
        battlefield.add(attacker, atPosition: 0)
        battlefield.add(opponent, atPosition: 0)
        try attacker.attack(opponent, damage: 200, battlefield: battlefield)
        XCTAssertEqual(opponent.health, 700)
    }
}

// MARK: - Iteration 3
extension CharacterTests {
    func testCharacter_onInit_hasMaxAttackRange() {
        XCTAssertGreaterThanOrEqual(aCharacter.maxRange, 0)
    }
    
    func testMeleeCharacter_onInit_maxRngeIs2() {
        aCharacter = MeleeCharacter()
        XCTAssertEqual(aCharacter.maxRange, 2)
    }
    
    func testRangedCharacter_onInit_maxRngeIs20() {
        aCharacter = RangedCharacter()
        XCTAssertEqual(aCharacter.maxRange, 20)
    }
    
    func testCharacterFarAwayFromOpponent_onAttack_Misses() throws {
        let attacker = MeleeCharacter()
        let opponent = MeleeCharacter(health: 1000)
        let battlefield = Battlefield()
        battlefield.add(attacker, atPosition: 2)
        battlefield.add(opponent, atPosition: 5)
        XCTAssertThrowsError(try attacker.attack(opponent, damage: 200, battlefield: battlefield))
    }
}

private extension CharacterTests {
    func givenCharacter(initialHealth: Double) {
        aCharacter = RPGCharacter(health: initialHealth)
    }
    
    func whenCharacterReceivesDamage(amount: Double) {
        aCharacter.receiveDamage(of: amount)
    }
    
    func whenCharacterIsHealed(by amount: Double) throws {
        try aCharacter.heal(amount)
    }
    
    func thenCharacterHealthIs(_ value: Double) throws {
        XCTAssertEqual(aCharacter.health, value)
    }
    
    func thenCharacterIsDead() {
        XCTAssertFalse(aCharacter.isAlive)
    }
}
