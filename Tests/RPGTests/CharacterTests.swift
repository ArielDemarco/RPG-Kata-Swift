//
//  File.swift
//  
//
//  Created by Ariel Demarco on 24/04/2021.
//

import XCTest

@frozen
enum RPGException: LocalizedError {
    case cannotHurtSelf
    
    var errorDescription: String? {
        switch self {
        case .cannotHurtSelf:
            return "A character cannot hurt himself"
        }
    }
}

struct RPGCharacter {
    private struct Constants {
        static let initialHealth: Double = 1000
        static let maximumHealth: Double = 1000
    }
    private let id: String
    private(set) var health: Double
    private(set) var level: Int
    
    var isAlive: Bool {
        health > 0
    }
    
    init(health: Double = Constants.initialHealth, level: Int = 1) {
        self.health = health
        self.level = level
        self.id = UUID().uuidString
    }
    
    mutating func receiveDamage(of damageAmount: Double, attackerLevel: Int) {
        var totalDamage = damageAmount
        if level >= attackerLevel + 5 {
            totalDamage *= 0.5
        } else if level + 5 <= attackerLevel {
            totalDamage *= 1.5
        }
        health = max(health - totalDamage, 0)
    }
    
    func attack(_ opponent: RPGCharacter, damage: Double) throws -> RPGCharacter {
        guard self != opponent else { throw RPGException.cannotHurtSelf }
        var damagedOpponent = opponent
        damagedOpponent.receiveDamage(of: damage, attackerLevel: level)
        return damagedOpponent
    }
    
    mutating func heal(_ amount: Double) {
        health = min(health + amount, Constants.maximumHealth)
    }
}

extension RPGCharacter: Equatable {
    static func == (lhs: RPGCharacter, rhs: RPGCharacter) -> Bool {
        lhs.id == rhs.id
    }
}

class CharacterTests: XCTestCase {
    private var sut: RPGCharacter!
    
    override func setUp() {
        sut = RPGCharacter()
    }
}

// MARK: - Iteration 1
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
        let damagedOponent = try attacker.attack(opponent, damage: 100)
        XCTAssertEqual(damagedOponent.health, 900)
    }
    
    func testCharacter_receivesHealing_addsHealingAmountToActualHealth() throws {
        givenCharacter(initialHealth: 500)
        whenCharacterIsHealed(by: 400)
        try thenCharacterHealthIs(900)
    }
    
    func testCharacter_receivesHealing_healthCannotGoBeyond1000() throws {
        givenCharacter(initialHealth: 900)
        whenCharacterIsHealed(by: 200)
        try thenCharacterHealthIs(1000)
    }
}

// MARK: - Iteration 2
extension CharacterTests {
    func testCharacter_onAttackHimself_throwsException() {
        XCTAssertThrowsError(try sut.attack(sut, damage: .random(in: 0...1000)))
    }
    
    func testCharacter_canOnlyHealsHimself() {
        var healer = RPGCharacter(health: 100)
        healer.heal(600)
        XCTAssertEqual(healer.health, 700)
    }
    
    func testCharacter_onAttackCharacter5levelsAbove_opponentReceivesHalfDamage() throws {
        let attacker = RPGCharacter(level: 2)
        let opponent = RPGCharacter(health: 1000, level: 7)
        let attackedOpponent = try attacker.attack(opponent, damage: 1000)
        XCTAssertEqual(attackedOpponent.health, 500)
    }
    
    func testCharacter_onAttackCharacter5levelsBelow_opponentReceives50PercentMoreDamage() throws {
        let attacker = RPGCharacter(level: 7)
        let opponent = RPGCharacter(health: 1000, level: 2)
        let attackedOpponent = try attacker.attack(opponent, damage: 200)
        XCTAssertEqual(attackedOpponent.health, 700)
    }
}

private extension CharacterTests {
    func givenCharacter(initialHealth: Double) {
        sut = RPGCharacter(health: initialHealth)
    }
    
    func whenCharacterReceivesDamage(amount: Double) {
        sut.receiveDamage(of: amount, attackerLevel: 1)
    }
    
    func whenCharacterIsHealed(by amount: Double) {
        sut.heal(amount)
    }
    
    func thenCharacterHealthIs(_ value: Double) throws {
        XCTAssertEqual(sut.health, value)
    }
    
    func thenCharacterIsDead() {
        XCTAssertFalse(sut.isAlive)
    }
}
