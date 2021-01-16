//
//  File.swift
//  
//
//  Created by Mukul Agarwal on 1/15/21.
//

import Foundation

protocol Take {
    associatedtype T
    static func take(_ value: [T]) -> Self
    func give() -> [T]
}

extension Array : Take {
    typealias T = Element
    static func take(_ value: [T]) -> Self {
        return value
    }
    func give() -> [T] {
        self
    }
}

extension String: Take {
    typealias T = Character
    static func take(_ value: [T]) -> Self {
        String(value)
    }
    func give() -> [T] {
        Array(self)
    }
}
