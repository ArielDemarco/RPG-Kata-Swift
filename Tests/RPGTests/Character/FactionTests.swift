//
//  File.swift
//  
//
//  Created by Ariel Demarco on 29/04/2021.
//

import XCTest
@testable import RPG

class FactionTests: XCTestCase {
    private var aCharacter: RPGCharacter!
    private var otherCharacter: RPGCharacter!
    private var battlefield: Battlefield!
    
    override func setUpWithError() throws {
        givenCharacter()
    }
}

// MARK: - Iteration 4
extension FactionTests {
    func testCharacter_onInit_doesntBelongToAnyFaction() {
        onInitCharacter()
        thenCharacterDoesntBelongToAnyFaction()
    }
    
    func testCharacter_joinFaction_addsFactionToCharactersFactions() {
        onCharacterJoiningFaction("alliance")
        thenCharacterContainsFaction("alliance")
    }
    
    func testCharacterInFaction_leaveFaction_removesTheFactionFromCharactersFaction() {
        givenCharacterWithFaction("alliance")
        onLeavingFaction("alliance")
        thenCharacterDoesntContainFaction("alliance")
    }
    
    func testCharacter_onAttackAlly_attackCantBeDone() throws {
        givenCharacterWithFaction("alliance")
        givenOtherCharacterWithFaction("alliance")
        givenCharactersOnBattlefield()
        XCTAssertThrowsError(try onCharacterAttackOtherCharacter())
    }
    
    func testCharacter_canHealAllies() throws {
        givenCharacterWithFaction("alliance")
        givenOtherCharacterWithFaction("alliance", health: 900)
        XCTAssertNoThrow(try onCharacterHealOtherCharacter(amount: 100))
        thenOtherCharactersHealthIs(1000)
    }
    
    func testCharacter_cantHealEnemies() {
        givenCharacterWithFaction("alliance")
        givenOtherCharacterWithFaction("horde")
        XCTAssertThrowsError(try onCharacterHealOtherCharacter(amount: 100))
    }
}

// MARK: - Private Methods
private extension FactionTests {
    func onInitCharacter() {
        givenCharacter()
    }
    
    func givenCharacter() {
        aCharacter = RPGCharacter()
    }
    
    func givenCharacterWithFaction(_ faction: Faction) {
        aCharacter = CharacterMother.ofFaction(faction)
    }
    
    func givenOtherCharacterWithFaction(_ faction: Faction, health: Double = 1000) {
        otherCharacter = CharacterMother.ofFaction(faction, health: health)
    }
    
    func givenCharactersOnBattlefield() {
        battlefield = BattlefieldMother.withElements([aCharacter, otherCharacter])
    }
    
    func onLeavingFaction(_ faction: Faction) {
        aCharacter.leaveFaction(faction)
    }
    
    func onCharacterJoiningFaction(_ faction: Faction) {
        aCharacter.addFaction(faction)
    }
    
    func onCharacterHealOtherCharacter(amount: Double) throws {
        try aCharacter.heal(otherCharacter, amount: amount)
    }
    
    func onCharacterAttackOtherCharacter() throws {
        try aCharacter.attack(otherCharacter,
                              damage: .random(in: 0...1000),
                              battlefield: battlefield)
    }
    
    func thenCharacterDoesntBelongToAnyFaction() {
        XCTAssertTrue(aCharacter.factions.isEmpty)
    }
    
    func thenCharacterContainsFaction(_ faction: Faction) {
        XCTAssertTrue(aCharacter.factions.contains(faction))
    }
    
    func thenCharacterDoesntContainFaction(_ faction: Faction) {
        XCTAssertFalse(aCharacter.factions.contains(faction))
    }
    
    func thenOtherCharactersHealthIs(_ value: Double) {
        XCTAssertEqual(otherCharacter.health, value)
    }
}
