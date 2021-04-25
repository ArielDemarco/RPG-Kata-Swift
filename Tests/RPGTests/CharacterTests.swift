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
    case enemyNotInRange
    
    var errorDescription: String? {
        switch self {
        case .cannotHurtSelf:
            return "A character cannot hurt himself"
        case .canOnlyHealSelf:
            return "A character can only heal himself"
        case .enemyNotInRange:
            return "Enemy is not in range"
        }
    }
}

struct Attack {
    func execute(attacker: RPGCharacter,
                 opponent: RPGCharacter,
                 damage: Double,
                 battlefield: Battlefield) throws -> RPGCharacter {
        guard attacker != opponent else { throw RPGException.cannotHurtSelf }
        guard battlefield.isInRange(attacker: attacker,
                                    opponent: opponent) else { throw RPGException.enemyNotInRange }
        let totalDamage = calculateDamage(fromAmount: damage,
                                          attackerLevel: attacker.level,
                                          opponentLevel: opponent.level)
        return opponent.receiveDamage(of: totalDamage)
    }
    
    private func calculateDamage(fromAmount baseAmount: Double,
                                 attackerLevel: Int,
                                 opponentLevel: Int) -> Double {
        var totalDamage = baseAmount
        if opponentLevel >= attackerLevel + 5 {
            totalDamage *= 0.5
        } else if opponentLevel + 5 <= attackerLevel {
            totalDamage *= 1.5
        }
        return totalDamage
    }
}

struct Heal {
    func execute(healer: RPGCharacter, target: RPGCharacter, amount: Double) throws -> RPGCharacter{
        guard healer == target else { throw RPGException.canOnlyHealSelf }
        return target.receiveHealing(amount)
    }
}

class MeleeCharacter: RPGCharacter {
    override init(health: Double = Constants.initialHealth,
                  level: Int = Constants.initialLevel) {
        super.init(health: health, level: level)
        self.maxRange = 2
    }
}

class RangedCharacter: RPGCharacter {
    override init(health: Double = Constants.initialHealth,
                  level: Int = Constants.initialLevel) {
        super.init(health: health, level: level)
        self.maxRange = 20
    }
}

class RPGCharacter: NSObject {
    struct Constants {
        static let initialHealth: Double = 1000
        static let maximumHealth: Double = 1000
        static let initialLevel: Int = 1
    }
    private let attack: Attack
    private let heal: Heal
    private(set) var level: Int
    private(set) var health: Double {
        didSet {
            health = max(0, min(health, Constants.maximumHealth))
        }
    }
    open var maxRange: Int
    var isAlive: Bool {
        health > 0
    }
    
    init(health: Double = Constants.initialHealth,
         level: Int = Constants.initialLevel) {
        self.health = health
        self.level = level
        self.attack = Attack()
        self.heal = Heal()
        self.maxRange = 0
    }
    
    func receiveDamage(of damageAmount: Double) -> RPGCharacter {
        health -= damageAmount
        return self
    }
    
    func attack(_ opponent: RPGCharacter,
                damage: Double,
                battlefield: Battlefield) throws -> RPGCharacter {
        try attack.execute(attacker: self,
                           opponent: opponent,
                           damage: damage,
                           battlefield: battlefield)
    }
    
    func receiveHealing(_ amount: Double) -> RPGCharacter {
        health += amount
        return self
    }
    
    func heal(_ amount: Double) throws -> RPGCharacter {
        return try heal.execute(healer: self, target: self, amount: amount)
    }
}

class Battlefield {
    private var charactersPosition: [RPGCharacter: Int]
    
    init(charactersPosition: [RPGCharacter: Int] = [:]) {
        self.charactersPosition = charactersPosition
    }
    
    func add(_ character: RPGCharacter, atPosition position: Int) {
        charactersPosition[character] = position
    }
    
    func isInRange(attacker: RPGCharacter, opponent: RPGCharacter) -> Bool {
        guard let attackerPosition = charactersPosition[attacker],
              let opponentPosition = charactersPosition[opponent] else { return false }
        return abs(attackerPosition - opponentPosition) <= attacker.maxRange
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
        let battleField = Battlefield()
        battleField.add(attacker, atPosition: 0)
        battleField.add(opponent, atPosition: 0)
        let damagedOponent = try attacker.attack(opponent,
                                                 damage: 100,
                                                 battlefield: battleField)
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
        XCTAssertThrowsError(try aCharacter.attack(aCharacter, damage: .random(in: 0...1000), battlefield: Battlefield()))
    }
    
    func testCharacter_canOnlyHealsHimself() throws {
        let damagedCharacer = RPGCharacter(health: 300)
        let healedCharacter = try damagedCharacer.heal(600)
        XCTAssertEqual(healedCharacter.health, 900)
    }
    
    func testCharacter_onAttackCharacter5levelsAbove_opponentReceivesHalfDamage() throws {
        let attacker = RPGCharacter(level: 2)
        let opponent = RPGCharacter(health: 1000, level: 7)
        let battleField = Battlefield()
        battleField.add(attacker, atPosition: 0)
        battleField.add(opponent, atPosition: 0)
        let attackedOpponent = try attacker.attack(opponent, damage: 1000, battlefield: battleField)
        XCTAssertEqual(attackedOpponent.health, 500)
    }
    
    func testCharacter_onAttackCharacter5levelsBelow_opponentReceives50PercentMoreDamage() throws {
        let attacker = RPGCharacter(level: 7)
        let opponent = RPGCharacter(health: 1000, level: 2)
        let battlefield = Battlefield()
        battlefield.add(attacker, atPosition: 0)
        battlefield.add(opponent, atPosition: 0)
        let attackedOpponent = try attacker.attack(opponent, damage: 200, battlefield: battlefield)
        XCTAssertEqual(attackedOpponent.health, 700)
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
        aCharacter = aCharacter.receiveDamage(of: amount)
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
