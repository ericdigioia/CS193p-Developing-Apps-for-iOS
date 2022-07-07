//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Eric Di Gioia on 6/27/22.
//
//  View

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame // viewmodel
    
    var body: some View {
        NavigationView {
            VStack {                
                AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
                    CardView(card, color: game.theme.color)
                        .padding(4)
                        .onTapGesture {
                            game.choose(card)
                        }
                }
                
                Text("Score: \(game.score)")
            }
            .padding()
            .navigationTitle("Memorize!: \(game.theme.name)")
            .toolbar {
                ToolbarItem {
                    Button("New Game") {
                        game.resetGame()
                    }
                }
            }
        }
    }
}

// how cards should appear/look
struct CardView: View {
    private let card: EmojiMemoryGame.Card
    private let color: Color
    
    init(_ card: EmojiMemoryGame.Card, color: String) {
        self.card = card
        
        switch color {
        case "red": self.color = Color.red
        case "blue": self.color = Color.blue
        case "yellow": self.color = Color.yellow
        case "indigo": self.color = Color.indigo
        case "green": self.color = Color.green
        case "orange": self.color = Color.orange
        case "gray": self.color = Color.gray
        default: self.color = Color.secondary
        }
    }
    
    var body: some View {
        let cardShape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
        
        GeometryReader { geometry in
            ZStack {
                if !card.isFaceUp { // front side
                    cardShape
                        .fill()
                        .foregroundColor(.white)
                    cardShape
                        .strokeBorder(lineWidth: DrawingConstants.lineWidth)
                        .foregroundColor(color)
                    Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 150-90))
                        .fill(color)
                        .padding(5)
                        .opacity(0.5)
                    Text(card.content)
                        .font(font(in: geometry.size))
                } else if card.isMatched { // already matched: invisible
                    cardShape.opacity(0)
                } else { // back side
                    cardShape
                        .fill()
                        .foregroundColor(color)
                }
            }
        }
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.7
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(game: EmojiMemoryGame())
            .preferredColorScheme(.dark)
        EmojiMemoryGameView(game: EmojiMemoryGame())
            .preferredColorScheme(.light)
    }
}
