//
//  Theme.swift
//  Memorize
//
//  Created by Eric Di Gioia on 7/1/22.
//

import Foundation

struct Theme<CardContent> {
    var name: String
    var contentSet: [CardContent]
    var numberOfPairsOfCards: Int
    var color: String
    
    init(name: String, contentSet: [CardContent], numberOfPairsOfCards: Int, color: String) {
        self.name = name
        self.contentSet = contentSet
        // make sure requested number of cards does not exceed number of unique emoji in theme
        if numberOfPairsOfCards > self.contentSet.count {
            print("⚠️ Theme \(self.name) is to have a numberOfPairsOfCards value of \(numberOfPairsOfCards)... Correcting to \(self.contentSet.count).")
            self.numberOfPairsOfCards = self.contentSet.count
        } else {
            self.numberOfPairsOfCards = numberOfPairsOfCards
        }
        self.color = color
    }
}
