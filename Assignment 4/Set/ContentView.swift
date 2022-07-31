//
//  ContentView.swift
//  Set
//
//  Created by Eric Di Gioia on 7/4/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    
    @State private var dealtCardIDs = Set<UUID>() // IDs of cards that have been dealt in the UI
    @Namespace private var dealingNameSpace // nameSpace for use with matchedGeometryEffect
    
    var body: some View {
        NavigationView {
            VStack {
                AspectVGrid(items: viewModel.cards.filter({ $0.isInPlay }), aspectRatio: viewConstants.cardAspectRatio) { card in
                    if dealtCardIDs.contains(card.id) {
                        CardView(card) // if there are more than 38 cards in play, enable scrolling
                            .matchedGeometryEffect(id: card.id, in: dealingNameSpace)
                            .padding(viewConstants.interCardPadding)
                            .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                            //.zIndex(zIndex(of: card))
                            .onTapGesture {
                                withAnimation {
                                    viewModel.choose(card)
                                }
                                updateDealtCards()
                            }
                    }
                }
                .padding()
                
                HStack {
                    deckBody
                    
                    Spacer()
                    
                    discardPileBody
                }
                .padding(.horizontal)
                
                Text("Score: \(viewModel.score)")
            }
            .navigationBarTitle("SET")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("New game") {
                        viewModel.resetGame()
                        dealtCardIDs = Set<UUID>()
                        updateDealtCards()
                    }
                }
                 
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("Deal 3 more cards") {
//                        withAnimation {
//                            viewModel.dealMoreCards()
//                        }
//                        updateDealtCards()
//                    }
//                    .disabled(viewModel.cards.filter({ !$0.isInPlay && !$0.isMatched }).isEmpty)
//                }
            }
        }
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(viewModel.cards.filter({ !dealtCardIDs.contains($0.id) })) { card in
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNameSpace)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
            .frame(width: viewConstants.deckWidth, height: viewConstants.deckHeight)
            .aspectRatio(viewConstants.cardAspectRatio, contentMode: .fit)
            .onTapGesture {
                if dealtCardIDs.isEmpty {
                    // deal initial 12 cards
                    viewModel.dealInitialCards()
                    updateDealtCards()
                } else {
                    withAnimation {
                        viewModel.dealMoreCards()
                        updateDealtCards()
                    }
                }
            }
        }
    }
    
    var discardPileBody: some View {
        ZStack {
            ForEach(viewModel.cards.filter({ $0.isMatched })) { card in
                CardView(card)
                    .transition(AnyTransition.asymmetric(insertion: .scale, removal: .identity))
            }
            .frame(width: viewConstants.deckWidth, height: viewConstants.deckHeight)
            .aspectRatio(viewConstants.cardAspectRatio, contentMode: .fit)
        }
    }
    
    // returns z index of card based on its order in the deck
    private func zIndex(of card: ViewModel.Card) -> Double {
        -Double(viewModel.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    // updates the dealtCardIDs Set which determines where cards are shown on screen
    private func updateDealtCards(useAnimation: Bool = true) {
        // for all cards that are in play but not yet dealt on the screen (newly dealt cards)
        for (index, card) in viewModel.cards.filter({ $0.isInPlay && !dealtCardIDs.contains($0.id)}).enumerated() {
            if useAnimation {
                _ = withAnimation(Animation.easeOut(duration: viewConstants.totalDealDuration).delay(Double(index)/7)) {
                    dealtCardIDs.insert(card.id)
                }
            }
            else { dealtCardIDs.insert(card.id) }
        }
    }
    
    // returns animation to use for dealing cards one at a time
    private func dealAnimation(for card: ViewModel.Card) -> Animation {
        
        if let indexOfCard = viewModel.cards.filter({ $0.isInPlay && !dealtCardIDs.contains($0.id) }).firstIndex(where: { $0.id == card.id }) {
            let delay = Double(indexOfCard) * viewConstants.totalDealDuration / Double(viewModel.cards.count)
            print("delay: \(delay)")
            return Animation.easeInOut(duration: viewConstants.totalDealDuration).delay(delay)
        } else {
            print("no delay")
            return Animation.easeInOut(duration: viewConstants.totalDealDuration).delay(0)
        }
    }
    
    private struct viewConstants {
        static let cardAspectRatio: CGFloat = 2/3
        static let interCardPadding: CGFloat = 5
        static let deckWidth: CGFloat = 60
        static let deckHeight: CGFloat = 90
        static let totalDealDuration: Double = 1
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ViewModel())
            .preferredColorScheme(.dark)
    }
}
