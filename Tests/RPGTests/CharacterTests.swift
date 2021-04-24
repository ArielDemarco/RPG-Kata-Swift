//
//  File.swift
//  
//
//  Created by Ariel Demarco on 24/04/2021.
//

import XCTest

struct RPGCharacter {
    private struct Constants {
        static let initialHealth: Int = 1000
        static let maximumHealth: Int = 1000
    }
    private(set) var health: Int
    private(set) var level: Int
    var isAlive: Bool {
        health > 0
    }
    
    init(health: Int = Constants.initialHealth, level: Int = 1) {
        self.health = health
        self.level = level
    }
    
    mutating func receiveDamage(of damageAmount: Int) {
        health = max(health - damageAmount, 0)
    }
    
    mutating func receiveHealing(of healingAmount: Int) {
        health = min(health + healingAmount, Constants.maximumHealth)
    }
    
    func attack(_ opponent: RPGCharacter, damage: Int) -> RPGCharacter {
        var damagedOpponent = opponent
        damagedOpponent.receiveDamage(of: damage)
        return damagedOpponent
    }
    
    func heal(_ character: RPGCharacter, amount: Int) -> RPGCharacter {
        var healedCharacter = character
        healedCharacter.receiveHealing(of: amount)
        return healedCharacter
    }
}

class CharacterTests: XCTestCase {
    private var sut: RPGCharacter!
    
    override func setUp() {
        sut = RPGCharacter()
    }
}

// MARK:- Iteration 1
extension CharacterTests {
    func testCharacter_onInit_healthIs1000() {
        XCTAssertEqual(sut.health, 1000)
    }
    
    func testCharacter_onInit_levelIs1() {
        XCTAssertEqual(sut.level, 1)
    }
    
    func testCharacter_onInit_isAlive() {
        XCTAssertTrue(sut.isAlive)
    }
    
    func testCharacter_receiveDamage_substractHealthEqualToDamageReceived() {
        givenCharacter(initialHealth: 1000)
        whenCharacterReceivesDamage(amount: 100)
        thenCharacterHealthIs(900)
    }
    
    func testCharater_receiveDamageSuperiorToHealth_characterHealthIsZero() {
        givenCharacter(initialHealth: 1000)
        whenCharacterReceivesDamage(amount: 2000)
        thenCharacterHealthIs(0)
    }
    
    func testCharacter_receiveDamageSuperiorToHealth_characterIsDead() {
        givenCharacter(initialHealth: 1000)
        whenCharacterReceivesDamage(amount: 1000)
        thenCharacterIsDead()
    }
    
    func testCharacter_dealsDamage() {
        let attacker = RPGCharacter()
        let opponent = RPGCharacter(health: 1000)
        let damagedOponent = attacker.attack(opponent, damage: 100)
        XCTAssertEqual(damagedOponent.health, 900)
    }
    
    func testCharacter_receivesHealing_addsHealingAmountToActualHealth() {
        givenCharacter(initialHealth: 500)
        whenCharacterReceivesHealing(of: 400)
        thenCharacterHealthIs(900)
    }
    
    func testCharacter_receivesHealing_healthCannotGoBeyond1000() {
        givenCharacter(initialHealth: 900)
        whenCharacterReceivesHealing(of: 200)
        thenCharacterHealthIs(1000)
    }
    
    func testCharacter_healsAnotherCharacter() {
        let healer = RPGCharacter()
        let hurtCharacter = RPGCharacter(health: 100)
        let healedCharacter = healer.heal(hurtCharacter, amount: 600)
        XCTAssertEqual(healedCharacter.health, 700)
    }
}

private extension CharacterTests {
    func givenCharacter(initialHealth: Int) {
        sut = RPGCharacter(health: initialHealth)
    }
    
    func whenCharacterReceivesDamage(amount: Int) {
        sut.receiveDamage(of: amount)
    }
    
    func whenCharacterReceivesHealing(of amount: Int) {
        sut.receiveHealing(of: amount)
    }
    
    func thenCharacterHealthIs(_ value: Int) {
        XCTAssertEqual(sut.health, value)
    }
    
    func thenCharacterIsDead() {
        XCTAssertFalse(sut.isAlive)
    }
}
