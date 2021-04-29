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
    private var otherCharacter: RPGCharacter!
    private var battlefield: Battlefield!
    
    override func setUp() {
        aCharacter = RPGCharacter()
    }
}

// MARK: - Iteration 1
extension CharacterTests {
    func testCharacter_onInit_healthIs1000() {
        whenInvokingInitCharacter()
        thenCharacterHealthIs(1000)
    }
    
    func testCharacter_onInit_levelIs1() {
        whenInvokingInitCharacter()
        thenCharacterLevelIs(1)
    }
    
    func testCharacter_onInit_isAlive() {
        whenInvokingInitCharacter()
        thenCharacterIsAlive()
    }
    
    func testCharacter_receiveDamage_substractHealthEqualToDamageReceived() throws {
        givenCharacter(initialHealth: 1000)
        whenCharacterReceivesDamage(amount: 100)
        thenCharacterHealthIs(900)
    }
    
    func testCharater_receiveDamageSuperiorToHealth_characterHealthIsZero() throws {
        givenCharacter(initialHealth: 1000)
        whenCharacterReceivesDamage(amount: 2000)
        thenCharacterHealthIs(0)
    }
    
    func testCharacter_receiveDamageSuperiorToHealth_characterIsDead() {
        givenCharacter(initialHealth: 1000)
        whenCharacterReceivesDamage(amount: 1000)
        thenCharacterIsDead()
    }
    
    func testCharacter_dealsDamage() throws {
        givenCharacter()
        givenOtherCharacter(health: 1000)
        givenCharactersAreInABattleField()
        XCTAssertNoThrow(try whenACharacterAttackOtherCharacter(by: 100))
        thenOtherCharacterHealthIs(900)
    }
    
    func testCharacter_receivesHealing_addsHealingAmountToActualHealth() throws {
        givenCharacter(initialHealth: 500)
        XCTAssertNoThrow(try whenCharacterIsHealed(by: 400))
        thenCharacterHealthIs(900)
    }
    
    func testCharacter_receivesHealing_healthCannotGoBeyond1000() throws {
        givenCharacter(initialHealth: 900)
        XCTAssertNoThrow(try whenCharacterIsHealed(by: 200))
        thenCharacterHealthIs(1000)
    }
}

// MARK: - Iteration 2
extension CharacterTests {
    func testCharacter_onAttackHimself_throwsException() throws {
        givenCharacter()
        XCTAssertThrowsError(try whenCharacterAttacksHimself())
    }
    
    func testCharacter_canHealsHimself() throws {
        givenCharacter(initialHealth: 100)
        XCTAssertNoThrow(try whenCharacterIsHealed(by: 100))
        thenCharacterHealthIs(200)
    }
    
    func testCharacter_onAttackCharacter5levelsAbove_opponentReceivesHalfDamage() throws {
        givenCharacter(level: 2)
        givenOtherCharacter(health: 1000, level: 7)
        givenCharactersAreInABattleField()
        XCTAssertNoThrow(try whenACharacterAttackOtherCharacter(by: 1000))
        thenOtherCharacterHealthIs(500)
    }
    
    func testCharacter_onAttackCharacter5levelsBelow_opponentReceives50PercentMoreDamage() throws {
        givenCharacter(level: 7)
        givenOtherCharacter(health: 1000, level: 2)
        givenCharactersAreInABattleField()
        XCTAssertNoThrow(try whenACharacterAttackOtherCharacter(by: 200))
        thenOtherCharacterHealthIs(700)
    }
}

// MARK: - Private Methods
private extension CharacterTests {
    func givenCharacter(initialHealth: Double = 1000, level: Int = 1) {
        aCharacter = RPGCharacter(health: initialHealth, level: level)
    }
    
    func givenOtherCharacter(health: Double = 1000, level: Int = 1) {
        otherCharacter = RPGCharacter(health: health, level: level)
    }
    
    func givenCharactersAreInABattleField() {
        battlefield = BattlefieldMother.withElements([aCharacter, otherCharacter])
    }
    
    func whenInvokingInitCharacter() {
        aCharacter = RPGCharacter()
    }
    
    func whenCharacterReceivesDamage(amount: Double) {
        aCharacter.receiveDamage(of: amount)
    }
    
    func whenCharacterIsHealed(by amount: Double) throws {
        try aCharacter.heal(aCharacter, amount: amount)
    }
    
    func whenACharacterAttackOtherCharacter(by damage: Double) throws {
        try aCharacter.attack(otherCharacter, damage: damage, battlefield: battlefield)
    }
    
    func whenCharacterAttacksHimself() throws {
        try aCharacter.attack(aCharacter, damage: .random(in: 0...1000), battlefield: Battlefield())
    }
    
    func thenCharacterHealthIs(_ value: Double) {
        XCTAssertEqual(aCharacter.health, value)
    }
    
    func thenOtherCharacterHealthIs(_ value: Double) {
        XCTAssertEqual(otherCharacter.health, value)
    }
    
    func thenCharacterIsDead() {
        XCTAssertFalse(aCharacter.isAlive)
    }
    
    func thenCharacterLevelIs(_ value: Int) {
        XCTAssertEqual(aCharacter.level, value)
    }
    
    func thenCharacterIsAlive() {
        XCTAssertTrue(aCharacter.isAlive)
    }
}
