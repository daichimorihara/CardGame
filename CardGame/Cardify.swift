//
//  Cardify.swift
//  CardGame
//
//  Created by Daichi Morihara on 2021/10/08.
//

import SwiftUI

struct Cardify: AnimatableModifier {

    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    var rotation: Double
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    func body(content: Content) -> some View {
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                if rotation < 90 {
                    shape.fill().foregroundColor(.white)
                    shape.stroke(lineWidth: DrawingConstants.lineWidth)
                } else {
                    shape.fill()
                }
                content.opacity(rotation < 90 ? 1 : 0)
            }
            .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
        }
    struct DrawingConstants {
        static let cornerRadius: CGFloat = 5
        static let lineWidth: CGFloat = 3
        static let fontScale:CGFloat = 0.7
    }
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}

