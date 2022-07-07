//
//  DiamondShape.swift
//  Set
//
//  Created by Eric Di Gioia on 7/5/22.
//

import SwiftUI

struct Diamond: InsettableShape {
    var insetAmount = 0.0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.closeSubpath()
        return path
    }
    
    // required for InsettableShape conformance (for strokeBorder)
    func inset(by amount: CGFloat) -> some InsettableShape {
        var diamond = self
        diamond.insetAmount += amount
        return diamond
    }
    
}
