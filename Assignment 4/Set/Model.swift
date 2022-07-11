//
//  Model.swift
//  Set
//
//  Created by Eric Di Gioia on 7/5/22.
//

import Foundation
import SwiftUI

struct Model {
    private(set) var cards: [Card]
    private(set) var score: Int
 
    // chooses a card and then determines set or not
    mutating func choose(_ card: Card) {
        if let indexOfChosenCard = cards.firstIndex(where: { $0.id == card.id }) {
            // select or deselect card
            cards[indexOfChosenCard].isChosen.toggle()
            
            // if three cards have been selected
            let chosenCards = cards.filter({ $0.isChosen })
            if chosenCards.count == 3 {
                // first unmark the previous incorrectly matched set
                let previousInvalidSet = cards.filter({ $0.wasIncorrectlyMatched })
                if !previousInvalidSet.isEmpty {
                    previousInvalidSet.forEach { mismatchedCard in
                        cards[cards.firstIndex(where: { $0.id == mismatchedCard.id })!].wasIncorrectlyMatched = false
                    }
                }
                // determine if the three new cards make a valid set
                if checkIfSet(for: chosenCards) {
                    // chosen cards do make a valid set
                    chosenCards.forEach { matchedCard in
                        cards[cards.firstIndex(where: { $0.id == matchedCard.id })!].isMatched = true
                        cards[cards.firstIndex(where: { $0.id == matchedCard.id })!].isChosen = false
                        cards[cards.firstIndex(where: { $0.id == matchedCard.id })!].isInPlay = false
                    }
                    // replace matched cards with three new cards if there are still cards in the deck
                    // and also if there were only 12 cards in play
                    if cards.filter({ $0.isInPlay }).count < 12 { dealMoreCards() }
                    print("Matched!")
                    score += 1
                } else {
                    // user has attempted to make an invalid set, so deselect the cards.
                    // also have only this last mismatched set be marked as incorrectly matched.
                    // mark the new mismatched cards as incorrect and deselect them
                    chosenCards.forEach { mismatchedCard in
                        cards[cards.firstIndex(where: { $0.id == mismatchedCard.id })!].isChosen = false
                        cards[cards.firstIndex(where: { $0.id == mismatchedCard.id })!].wasIncorrectlyMatched = true
                    }
                    // then reselect that last (third) card
                    // cards[cards.firstIndex(where: { $0.id == card.id })!].isChosen = true
                    print("Not a match!")
                    score -= 1
                }
            }
        }
    }
    
    // deals three more cards to the player
    mutating func dealMoreCards(withPenalty: Bool = false) {
        let cardsStillInDeck = cards.filter({ !$0.isInPlay && !$0.isMatched }) // card is in deck if it is not in play and also not matched already
        if !cardsStillInDeck.isEmpty {
            for i in 0..<3 {
                cards[cards.firstIndex(where: { $0.id == cardsStillInDeck[i].id })!].isInPlay = true
            }
        }
        if withPenalty {
            score -= 1
        }
    }
    
    // deals initial 12 cards
    mutating func dealInitialCards() {
        for i in 0..<12 { cards[i].isInPlay = true }
    }
    
    // returns TRUE if currently chosen cards make a valid set
    private func checkIfSet(for potentialSet: [Card]) -> Bool {
        // make sure potential set contains only three cards
        guard potentialSet.count == 3 else {
            print("⚠️ Model.checkIfSet: attempted to check a set of \(potentialSet.count) card(s)")
            return false
        }
        // check if the three cards form a valid set
        if ((potentialSet[0].number.rawValue + potentialSet[1].number.rawValue + potentialSet[2].number.rawValue) % 3 == 0) &&
            ((potentialSet[0].shape.rawValue + potentialSet[1].shape.rawValue + potentialSet[2].shape.rawValue) % 3 == 0) &&
            ((potentialSet[0].shading.rawValue + potentialSet[1].shading.rawValue + potentialSet[2].shading.rawValue) % 3 == 0) &&
            ((potentialSet[0].color.rawValue + potentialSet[1].color.rawValue + potentialSet[2].color.rawValue) % 3 == 0) {
            return true
        } else {
            return false
        }
    }
    
    init() {
        // create the deck of 81 unique cards
        cards = []
        for cardNumber in Card.CardNumber.allCases {
            for cardShape in Card.CardShape.allCases {
                for cardShading in Card.CardShading.allCases {
                    for cardColor in Card.CardColor.allCases {
                        cards.append(Card(number: cardNumber, shape: cardShape, shading: cardShading, color: cardColor))
                    }
                }
            }
        }
        // shuffle deck
        cards = cards.shuffled()
        // init score to 0
        score = 0
    }
    
    struct Card: Identifiable {
        private(set) var id = UUID()
        var isInPlay = false
        var isChosen = false
        var isMatched = false
        var wasIncorrectlyMatched = false
        
        let number: CardNumber
        let shape: CardShape
        let shading: CardShading
        let color: CardColor
        
        // enum section, raw values are for checking potential sets
        enum CardNumber: Int, CaseIterable {
            case one = 1, two = 2, three = 3
        }
        enum CardShape: Int, CaseIterable {
            case ovals = 1, squiggles = 2, diamonds = 3
        }
        enum CardShading: Int, CaseIterable {
            case solid = 1, striped = 2, outlines = 3
        }
        enum CardColor: Int, CaseIterable {
            case red = 1, purple = 2, green = 3
        }
    }
}
