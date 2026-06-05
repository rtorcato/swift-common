//
//  SetExt.swift
//  MatrixSwiftBase
//
//  Created by Richard Torcato on 2026-06-04.
//

import Foundation

public extension Set {

    /// Whether the set contains every element of the given sequence.
    func containsAll<S: Sequence>(_ elements: S) -> Bool where S.Element == Element {
        Set(elements).isSubset(of: self)
    }

    /// Whether the set contains at least one element of the given sequence.
    func containsAny<S: Sequence>(_ elements: S) -> Bool where S.Element == Element {
        !Set(elements).isDisjoint(with: self)
    }

    /// Insert the element if absent, remove it if present.
    mutating func toggle(_ element: Element) {
        if contains(element) {
            remove(element)
        } else {
            insert(element)
        }
    }
}
