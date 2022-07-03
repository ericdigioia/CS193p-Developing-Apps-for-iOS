//
//  ContentView.swift
//  Memorize
//
//  Created by Eric Di Gioia on 6/27/22.
//
//  View

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView { // card view area
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                        ForEach(viewModel.cards) { card in
                            CardView(card: card, color: viewModel.theme.color)
                                .aspectRatio(2/3, contentMode: .fit)
                                .onTapGesture {
                                    // tell viewModel you want to choose this card
                                    viewModel.choose(card)
                                }
                        }
                    }
                }
                
                Text("Score: \(viewModel.score)")
            }
            .padding()
            .navigationTitle("Memorize!: \(viewModel.theme.name)")
            .toolbar {
                ToolbarItem {
                    Button("New Game") {
                        viewModel.resetGame()
                    }
                }
            }
        }
    }
}

// how cards should appear/look
struct CardView: View {
    let card: MemoryGame<String>.Card
    let color: String
    var cardColor: Color {
        switch color {
        case "red": return Color.red
        case "blue": return Color.blue
        case "yellow": return Color.yellow
        case "indigo": return Color.indigo
        case "green": return Color.green
        case "orange": return Color.orange
        case "gray": return Color.gray
        default: return Color.secondary
        }
    }
    
    var body: some View {
        let cardShape = RoundedRectangle(cornerRadius: 20)
        
        ZStack {
            if card.isFaceUp { // front side
                cardShape
                    .fill()
                    .foregroundColor(.white)
                cardShape
                    .strokeBorder(lineWidth: 3)
                    .foregroundColor(cardColor)
                Text(card.content)
                    .font(.largeTitle)
            } else if card.isMatched { // already matched: invisible
                cardShape.opacity(0)
            } else { // back side
                cardShape
                    .fill()
                    .foregroundColor(cardColor)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: EmojiMemoryGame())
            .preferredColorScheme(.dark)
        ContentView(viewModel: EmojiMemoryGame())
            .preferredColorScheme(.light)
    }
}
