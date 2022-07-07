//
//  ContentView.swift
//  Set
//
//  Created by Eric Di Gioia on 7/4/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                AspectVGrid(items: viewModel.cards.filter({ $0.isInPlay }), aspectRatio: 2/3) { card in
                    CardView(card) // if there are more than 38 cards in play, enable scrolling
                        .padding(5)
                        .onTapGesture {
                            viewModel.choose(card)
                        }
                }
                .padding()
                
                Text("Score: \(viewModel.score)")
            }
            .navigationBarTitle("SET")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("New game") {
                        viewModel.resetGame()
                    }
                }
                 
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Deal 3 more cards") {
                        viewModel.dealMoreCards()
                    }
                    .disabled(viewModel.cards.filter({ !$0.isInPlay && !$0.isMatched }).isEmpty)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ViewModel())
            .preferredColorScheme(.dark)
    }
}
