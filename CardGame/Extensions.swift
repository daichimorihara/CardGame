//
//  Extensions.swift
//  CardGame
//
//  Created by Daichi Morihara on 2021/10/23.
//
// code written below is exerped from internet


import SwiftUI

struct BlinkEffect: ViewModifier {
    @State var isOn: Bool = false
    let sizeRange: ClosedRange<CGFloat>
    let opacityRange: ClosedRange<Double>
    let interval: Double

    init(size: ClosedRange<CGFloat>, opacity: ClosedRange<Double>, interval: Double) {
        self.sizeRange = size
        self.opacityRange = opacity
        self.interval = interval
    }

    func body(content: Content) -> some View {
        content
            .opacity(self.isOn ? self.opacityRange.lowerBound : self.opacityRange.upperBound)
            .font(.system(size: self.isOn ? self.sizeRange.lowerBound : self.sizeRange.upperBound))
            .animation(Animation.linear(duration: self.interval).repeatForever())
            .onAppear(perform: {
                self.isOn = true
            })
    }
}

extension View {
    func blinkEffect(size: ClosedRange<CGFloat> = 30...100,
                     opacity: ClosedRange<Double> = 0.1...1,
                     interval: Double = 1.0) -> some View {
        self.modifier(BlinkEffect(size: size, opacity: opacity, interval: interval))
    }
}

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

struct IdentifiableAlert: Identifiable {
    var id: String
    var alert: () -> Alert
}
