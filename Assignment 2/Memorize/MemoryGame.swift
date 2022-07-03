//
//  MemoryGame.swift
//  Memorize
//
//  Created by Eric Di Gioia on 7/1/22.
//
//  Model

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: [Card]
    
    private(set) var score = 0
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int?
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }), // if card is chosen
           !cards[chosenIndex].isFaceUp, // and card not already face up
           !cards[chosenIndex].isMatched // and card not already matched
        {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard { // if there is already a card face up
                if cards[chosenIndex].content == cards[potentialMatchIndex].content { // if it matches the chosen card
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += 2
                } else { // mismatch has occurred, subtract 1 point for each card that has been previously seen
                    switch (cards[chosenIndex].hasBeenSeen, cards[potentialMatchIndex].hasBeenSeen) {
                    case (false, false) : break
                    case (false, true) : score -= 1
                    case (true, false) : score -= 1
                    case (true, true) : score -= 2
                    }
                    cards[chosenIndex].hasBeenSeen = true // set both card seen properties (property may already be set)
                    cards[potentialMatchIndex].hasBeenSeen = true
                }
                indexOfTheOneAndOnlyFaceUpCard = nil // now no card is face up
            } else { // if there is not already a card that is face up
                for index in cards.indices { // turn all cards face down
                    cards[index].isFaceUp = false
                }
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
            cards[chosenIndex].isFaceUp.toggle() // flip chosen card face up
        }
    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = [Card]()
        // add numberOfPairsOfCards x 2 cards to cards array
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content))
            cards.append(Card(content: content))
        }
        cards = cards.shuffled()
    }
    
    struct Card: Identifiable {
        var id = UUID()
        var isFaceUp = false
        var isMatched = false
        var hasBeenSeen = false // whether or not the card has been previously seen / chosen
        var content: CardContent // a type to be defined in the declaration of MemoryGame
    }
}
