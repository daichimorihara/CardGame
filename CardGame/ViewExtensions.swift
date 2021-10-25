//
//  ViewExtensions.swift
//  CardGame
//
//  Created by Daichi Morihara on 2021/10/25.
//
// code written below is exerpted from the internet

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

struct IdentifiableAlert: Identifiable {
    var id: String
    var alert: () -> Alert
}
