//
//  ProductionRule.swift
//  
//
//  Created by Mukul Agarwal on 1/15/21.
//
import Foundation

public class ProductionRule<T: Hashable, U: Collection> : CustomStringConvertible
    where U.Element == T
{
    let predecessor: T;
    let successor: U;
    
    enum ProductionRuleError: Error {
        case validationError(_ invalid: T, predecessor: Bool, _ alphabet: Set<T>)
    }
    
    //impl: CustomStringConvertible
    public var description: String {
        "\(predecessor) -> \(successor)"
    }

    init(predecessor: T, successor: U) {
        self.predecessor = predecessor
        self.successor = successor
    }
    convenience init( _ p: T, _ s:U) {
        self.init(predecessor: p, successor: s)
    }

}
extension ProductionRule where T: Equatable{
    func validate(_ alphabet: Set<T>) throws {
        guard alphabet.contains(self.predecessor) else {
            throw ProductionRuleError.validationError(predecessor, predecessor: true, alphabet)
        }
        for item in self.successor {
            if !alphabet.contains(item) {
                throw ProductionRuleError.validationError(item, predecessor: false, alphabet)
            }
        }
    }
}
