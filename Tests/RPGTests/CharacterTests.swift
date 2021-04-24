//
//  File.swift
//  
//
//  Created by Ariel Demarco on 24/04/2021.
//

import XCTest

struct RPGCharacter {
    let health: Int
    let level: Int
    var isAlive: Bool {
        health > 0
    }
    
    init(health: Int = 1000, level: Int = 1) {
        self.health = health
        self.level = level
    }
}

class CharacterTests: XCTestCase {
    private var sut: RPGCharacter!
    
    override func setUp() {
        sut = RPGCharacter()
    }
    
    func testCharacter_onInit_healthIs1000() {
        XCTAssertEqual(sut.health, 1000)
    }
    
    func testCharacter_onInit_levelIs1() {
        XCTAssertEqual(sut.level, 1)
    }
    
    func testCharacter_onInit_isAlive() {
        XCTAssertTrue(sut.isAlive)
    }
}
