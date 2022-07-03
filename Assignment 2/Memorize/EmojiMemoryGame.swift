//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Eric Di Gioia on 7/1/22.
//
//  ViewModel

import Foundation

class EmojiMemoryGame: ObservableObject {
    // Model whose changes are published to observers (have to give it initial value and it is then set for real inside class init()
    @Published private var model: MemoryGame<String> = MemoryGame<String>(numberOfPairsOfCards: 0) { _ in "" }
    
    // Array of themes
    private var themes: [Theme<String>]
    
    // Current theme
    private(set) var theme: Theme<String>
    
    // card array sourced directly from Model
    var cards: [MemoryGame<String>.Card] {
        model.cards
    }
    
    // score sourced directly from Model
    var score: Int {
        model.score
    }
    
    // MARK: - Intent(s)
    
    // chooses a card
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    // resets the game
    func resetGame() {
        // re-initialize Model with new random theme
        theme = themes.filter({ $0.name != theme.name }).randomElement()!
        model = MemoryGame<String>(numberOfPairsOfCards: theme.numberOfPairsOfCards) { pairIndex in
            theme.contentSet[pairIndex]
        }
    }
    
    
    init() {
        // init themes array
        self.themes = [Theme<String>]()
        
        // add themes here
        self.themes.append(Theme(name: "Vehicles",
                               contentSet: ["🚗","🚕","🚙","🚌","🚎","🏎","🚓","🚑","🚒","🚐","🛻","🚚","🚛","🚜","🛴","🚲","🛵","🏍","🛺","🚅"].shuffled(),
                               numberOfPairsOfCards: 50, // purposely overly-large number of pairs to demonstrate safety measures / self-correction (see Theme.swift)
                               color: "red"))
        self.themes.append(Theme(name: "Animals",
                               contentSet: ["🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼","🐻‍❄️","🐨","🐯","🦁","🐮","🐷","🐸","🐵"].shuffled(),
                               numberOfPairsOfCards: 15,
                               color: "blue"))
        self.themes.append(Theme(name: "Fruits",
                               contentSet: ["🍏","🍎","🍐","🍊","🍋","🍌","🍉","🍇","🍓","🫐","🍈","🍑","🥭","🍍","🥝","🍅 ","🍆","🥑"].shuffled(),
                               numberOfPairsOfCards: 15,
                               color: "green"))
        self.themes.append(Theme(name: "Sports",
                                 contentSet: ["⚽️","🏀","🏈","⚾️","🎾","🏐","🥏","🏉","🏓","🏸","🏒","🥍","🏋️‍♀️","⛷","🏂"].shuffled(),
                                 numberOfPairsOfCards: 15,
                                 color: "orange"))
        self.themes.append(Theme(name: "Countries",
                                 contentSet: ["🇨🇦","🇧🇲","🇧🇷","🇯🇵","🇯🇲","🇮🇹","🇮🇳","🇲🇰","🇪🇸","🇹🇼","🇨🇭","🇸🇪","🇻🇳","🇬🇧","🇺🇸","🇰🇷","🇬🇪"].shuffled(),
                                 numberOfPairsOfCards: 15,
                                 color: "gray"))
        self.themes.append(Theme(name: "Tech",
                                 contentSet: ["🖥","⌨️","📠","📺","📻","🎙","☎️","🎥","📡","💡","🧲","⚙️","🪜","🧨","🔭","💊","🪥"].shuffled(),
                                 numberOfPairsOfCards: 15,
                                 color: "indigo"))
        
        // init current theme = random theme
        self.theme = self.themes.randomElement()!
        
        // init Model
        self.model = MemoryGame<String>(numberOfPairsOfCards: self.theme.numberOfPairsOfCards) { pairIndex in
            self.theme.contentSet[pairIndex]
        }
    }
}
