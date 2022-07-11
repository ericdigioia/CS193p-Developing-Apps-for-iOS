//
//  CardView.swift
//  Set
//
//  Created by Eric Di Gioia on 7/5/22.
//

import SwiftUI

struct CardView: View {
    let card: Model.Card
    private let color: Color
    private let number: Int
    private var isFaceUp: Bool
    
    init(_ card: Model.Card, isFaceUp: Bool = true) {
        self.card = card
        switch card.color {
        case .red: color = .red
        case .green: color = .green
        case .purple: color = .purple
        }
        switch card.number {
        case .one: number = 1
        case .two: number = 2
        case .three: number = 3
        }
        self.isFaceUp = isFaceUp
    }
    
    var body: some View {
        let cardShape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            
        GeometryReader { geometry in
            if isFaceUp {
                ZStack {
                    cardShape
                    
                    if card.wasIncorrectlyMatched {
                        cardShape.foregroundColor(.red).opacity(0.3)
                    }
                    
                    VStack(spacing: geometry.size.height * DrawingConstants.shapeVerticalSpacing) {
                        
                        Group {
                            ForEach(0..<number, id: \.self) { _ in
                                switch card.shape {
                                case .squiggles:
                                    Rectangle()
                                        .strokeBorder(color, lineWidth: geometry.size.height * DrawingConstants.lineWidth)
                                        .overlay(Rectangle()).foregroundColor(card.shading == .solid ? color : color.opacity(0))
                                        .background(Stripes(config: StripesConfig(background: Color.clear, foreground: card.shading == .striped ? color : Color.clear, degrees: 90, barWidth: DrawingConstants.stripeSize * geometry.size.height, barSpacing: DrawingConstants.stripeSize * geometry.size.height)).clipShape(Rectangle()))
                                case .ovals:
                                    Capsule()
                                        .strokeBorder(color, lineWidth: geometry.size.height * DrawingConstants.lineWidth)
                                        .overlay(Capsule()).foregroundColor(card.shading == .solid ? color : color.opacity(0))
                                        .background(Stripes(config: StripesConfig(background: Color.clear, foreground: card.shading == .striped ? color : Color.clear, degrees: 90, barWidth: DrawingConstants.stripeSize * geometry.size.height, barSpacing: DrawingConstants.stripeSize * geometry.size.height)).clipShape(Capsule()))
                                case .diamonds:
                                    Diamond()
                                        .strokeBorder(color, lineWidth: geometry.size.height * DrawingConstants.lineWidth)
                                        .overlay(Diamond()).foregroundColor(card.shading == .solid ? color : color.opacity(0))
                                        .background(Stripes(config: StripesConfig(background: Color.clear, foreground: card.shading == .striped ? color : Color.clear, degrees: 90, barWidth: DrawingConstants.stripeSize * geometry.size.height, barSpacing: DrawingConstants.stripeSize * geometry.size.height)).clipShape(Diamond()))
                                }
                            }
                        }
                        //.frame(width: geometry.size.width * 0.55, height: geometry.size.height * 0.25)
                        .aspectRatio(DrawingConstants.shapeAspectRatio, contentMode: .fit)
                    }
                    .padding(geometry.size.height * DrawingConstants.paddingRatio)
                    
                    if card.isChosen {
                        cardShape.strokeBorder(.blue, lineWidth: geometry.size.height * DrawingConstants.lineWidth * 3)
                    }
                }
            } else { // backside of card
                ZStack {
                    Stripes(config: StripesConfig(background: Color.white,
                                                  foreground: Color.blue.opacity(0.7),
                                                  degrees: 45,
                                                  barWidth: DrawingConstants.stripeSize * geometry.size.height,
                                                  barSpacing: DrawingConstants.stripeSize * geometry.size.height))
                    Stripes(config: StripesConfig(background: Color.white,
                                                  foreground: Color.blue.opacity(0.3),
                                                  degrees: -45,
                                                  barWidth: DrawingConstants.stripeSize * geometry.size.height,
                                                  barSpacing: DrawingConstants.stripeSize * geometry.size.height))
                }
                .clipShape(cardShape)
                .overlay(cardShape.strokeBorder(.blue, lineWidth: geometry.size.height * DrawingConstants.lineWidth))
            }
        }
        .aspectRatio(DrawingConstants.cardAspectRatio, contentMode: .fit)
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 0.015
        static let cardAspectRatio: CGFloat = 2/3
        static let shapeAspectRatio: CGFloat = 5/3
        static let stripeSize: CGFloat = 0.02
        static let shapeVerticalSpacing: CGFloat = 0.05
        static let paddingRatio: CGFloat = 0.1
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(Model().cards.randomElement()!)
            .preferredColorScheme(.dark)
            .padding(180)
        CardView(Model().cards.randomElement()!)
            .preferredColorScheme(.dark)
            .padding(10)
    }
}
