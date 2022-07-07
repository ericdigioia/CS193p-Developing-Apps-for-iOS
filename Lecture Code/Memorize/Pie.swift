//
//  Pie.swift
//  Memorize
//
//  Created by Eric Di Gioia on 7/4/22.
//

import SwiftUI

struct Pie: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool = false
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY) // rect is the rectangular area of the View
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(x: center.x + radius * CGFloat(cos(startAngle.radians)), y: center.x + radius * CGFloat(sin(startAngle.radians)))
        
        var path = Path()
        path.move(to: center)
        path.addLine(to: start)
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: !clockwise)
        path.addLine(to: center)
        
        return path
    }
    
}
