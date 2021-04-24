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
    case canOnlyHealSelf
    
    var errorDescription: String? {
        switch self {
        case .cannotHurtSelf:
            return "A character cannot hurt himself"
        case .canOnlyHealSelf:
            return "A character can only heal himself"
        }
    }
}

protocol Fighter {
    var attack: Attack { get }
    var heal: Heal { get }
}

struct Attack {
    func execute(attacker: RPGCharacter, opponent: RPGCharacter, damage: Double) -> RPGCharacter {
        return RPGCharacter()
    }
}

struct Heal {
    func execute(healer: RPGCharacter, target: RPGCharacter, amount: Double) throws -> RPGCharacter{
        guard healer == target else { throw RPGException.canOnlyHealSelf }
        return target.receiveHealing(amount)
    }
}

struct RPGCharacter: Fighter {
    private struct Constants {
        static let initialHealth: Double = 1000
        static let maximumHealth: Double = 1000
    }
    private let id: String
    private(set) var health: Double {
        didSet {
            health = min(health, Constants.maximumHealth)
        }
    }
    private(set) var level: Int
    private(set) var attack: Attack
    private(set) var heal: Heal
    
    var isAlive: Bool {
        health > 0
    }
    
    init(health: Double = Constants.initialHealth, level: Int = 1) {
        self.health = health
        self.level = level
        self.id = UUID().uuidString
        self.attack = Attack()
        self.heal = Heal()
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
    
    func receiveHealing(_ amount: Double) -> RPGCharacter {
        var healedSelf = self
        healedSelf.health += amount
        return healedSelf
    }
    
    func heal(_ amount: Double) throws -> RPGCharacter {
        return try heal.execute(healer: self, target: self, amount: amount)
    }
}

extension RPGCharacter: Equatable {
    static func == (lhs: RPGCharacter, rhs: RPGCharacter) -> Bool {
        lhs.id == rhs.id
    }
}

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
        let damagedOponent = try attacker.attack(opponent, damage: 100)
        XCTAssertEqual(damagedOponent.health, 900)
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
        XCTAssertThrowsError(try aCharacter.attack(aCharacter, damage: .random(in: 0...1000)))
    }
    
    func testCharacter_canOnlyHealsHimself() throws {
        let damagedCharacer = RPGCharacter(health: 300)
        let healedCharacter = try damagedCharacer.heal(600)
        XCTAssertEqual(healedCharacter.health, 900)
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
        aCharacter = RPGCharacter(health: initialHealth)
    }
    
    func whenCharacterReceivesDamage(amount: Double) {
        aCharacter.receiveDamage(of: amount, attackerLevel: 1)
    }
    
    func whenCharacterIsHealed(by amount: Double) throws {
        aCharacter = try aCharacter.heal(amount)
    }
    
    func thenCharacterHealthIs(_ value: Double) throws {
        XCTAssertEqual(aCharacter.health, value)
    }
    
    func thenCharacterIsDead() {
        XCTAssertFalse(aCharacter.isAlive)
    }
}
