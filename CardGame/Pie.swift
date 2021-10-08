//
//  Pie.swift
//  CardGame
//
//  Created by Daichi Morihara on 2021/10/08.
//

import SwiftUI

struct Pie: Shape {
    let startAngle: Angle
    let endAngle: Angle
    let clockwise = false
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.size.width, rect.size.height) / 2
        let start = CGPoint(x: center.x + radius * CGFloat(cos(startAngle.radians)),
                            y: center.y + radius * CGFloat(sin(startAngle.radians)))
        var p = Path()
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(center: center,
                 radius: radius,
                 startAngle: startAngle,
                 endAngle: endAngle,
                 clockwise: !clockwise)
        p.addLine(to: center)
    
        
        return p
    }
    
    
}

