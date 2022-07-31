//
//  ViewModel.swift
//  Set
//
//  Created by Eric Di Gioia on 7/5/22.
//

import Foundation

class ViewModel: ObservableObject {
    typealias Card = Model.Card
    
    @Published private var model = Model()
    
    var cards: [Card] {
        model.cards
    }
    
    var score: Int {
        model.score
    }
    
    // MARK: intents
    
    // chooses a card
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    // deals three more cards (1 point penalty incurred)
    func dealMoreCards() {
        model.dealMoreCards(withPenalty: true)
    }
    
    // resets game
    func resetGame() {
        model = Model()
    }
    
    // deals initial 12 cards for game
    func dealInitialCards() {
        model.dealInitialCards()
    }
    
    // deals one card
    func dealCard() {
        model.dealCard()
    }
    
}
