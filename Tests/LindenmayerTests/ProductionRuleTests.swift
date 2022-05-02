//
//  File.swift
//  
//
//  Created by Mukul Agarwal on 1/16/21.
//

import XCTest
@testable import Lindenmayer

final class ProductionRuleTests: XCTestCase {
    typealias StringRule = ProductionRule<Character, String>
    typealias EnumRule = ProductionRule<LState, [LState]>
    enum LState: Equatable {
        case F
        case B
        case L
        case R
    }
    
    func testProductionRuleCreationString() {
        let rule: StringRule = .init("A", "AB")
        XCTAssertEqual(rule.predecessor, "A")
        XCTAssertEqual(rule.successor, "AB")
    }
    func testProductionRuleCreationEnum() {
        let rule: EnumRule = .init(.F, [.B, .L, .R])
        XCTAssertEqual(rule.predecessor, .F)
        XCTAssertEqual(rule.successor, [.B, .L, .R])
    }
    func testProductionRuleValidationStringPredecessorError() {
        let rule: StringRule = .init("A", "BCD")
        let predecessorBadAlphabet: Set<Character> = Set(arrayLiteral: "B", "C")
        XCTAssertThrowsError(try rule.validate(predecessorBadAlphabet)) { error in
            let error = error as! StringRule.ProductionRuleError
            switch error {
            case .validationError(let invalid, let predecessor, let alphabet):
                XCTAssertEqual(invalid, "A")
                XCTAssertEqual(predecessor, true)
                XCTAssertEqual(alphabet, predecessorBadAlphabet)
            }
        }
    }
    func testProductionRuleValidationStringSuccessorError() {
        let rule: StringRule = .init("A", "BCD")
        let successorBadAlphabet: Set<Character> = Set(arrayLiteral: "A", "B", "C")
        XCTAssertThrowsError(try rule.validate(successorBadAlphabet)) { error in
            let error = error as! StringRule.ProductionRuleError
            switch error {
            case .validationError(let invalid, let predecessor, let alphabet):
                XCTAssertEqual(invalid, "D")
                XCTAssertEqual(predecessor, false)
                XCTAssertEqual(alphabet, successorBadAlphabet)
            }
        }

    }
    func testProductionRuleValidationStringShouldPass() {
        let rule: StringRule = .init("A", "BCD")
        let goodAlphabet: Set<Character> = Set(arrayLiteral: "A", "B", "C", "D")
        XCTAssertNoThrow(try rule.validate(goodAlphabet))
        
    }
}
