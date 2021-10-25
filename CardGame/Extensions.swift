//
//  Extensions.swift
//  CardGame
//
//  Created by Daichi Morihara on 2021/10/23.
//
// code written below is exerpted from the internet


import SwiftUI

extension Character {
    var isEmoji: Bool {
        if let firstScalar = unicodeScalars.first, firstScalar.properties.isEmoji {
            return (firstScalar.value >= 0x238d || unicodeScalars.count > 1)
        } else {
            return false
        }
    }
}

extension String {
    var removingDuplicateCharacters: String {
        reduce(into: "") { sofar, element in
            if !sofar.contains(element) {
                sofar.append(element)
            }
        }
    }
}

extension Collection where Element: Identifiable {
    func index(matching element: Element) -> Self.Index? {
        firstIndex(where: { $0.id == element.id })
    }
}

extension RangeReplaceableCollection where Element: Identifiable {
    
    subscript(_ element: Element) -> Element {
        get {
            if let index = index(matching: element) {
                return self[index]
            } else {
                return element
            }
        }
        set {
            if let index = index(matching: element) {
                replaceSubrange(index...index, with: [newValue])
            }
        }
    }
}


