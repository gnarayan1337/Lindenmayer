//
//  ProductionRule.swift
//  
//
//  Created by Mukul Agarwal on 1/15/21.
//

import Foundation

public class ProductionRule<T, U: Collection> : CustomStringConvertible
    where U.Element == T
{
    let predecessor: T;
    let successor: U;

    //impl: CustomStringConvertible
    public var description: String {
        "\(predecessor) -> \(successor)"
    }

    init(predecessor: T, successor: U) {
        self.predecessor = predecessor
        self.successor = successor
    }

}
extension ProductionRule where T: Equatable{
    func validate(_ validator: (T) -> Bool) -> Bool {
        guard validator(self.predecessor) else {
            return false
        }
        /*for item in self.successor {
            
        }*/
        return true
    }
}
