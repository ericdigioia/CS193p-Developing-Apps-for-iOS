//
//  ContentView.swift
//  Memorize
//
//  Created by Eric Di Gioia on 6/27/22.
//

import SwiftUI

struct ContentView: View {
    enum themes {
        case vehicles, animals, fruit
    }
    
    @State private var selectedTheme = themes.vehicles // theme defaults to vehicles at launch
    
    private let vehicleEmojis = ["🚗","🚕","🚙","🚌","🚎","🏎","🚓","🚑","🚒","🚐","🛻","🚚","🚛","🚜","🛴","🚲","🛵","🏍","🛺","🚅"]
    private let animalEmojis = ["🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼","🐻‍❄️","🐨","🐯","🦁","🐮","🐷","🐸","🐵"]
    private let foodEmojis = ["🍏","🍎","🍐","🍊","🍋","🍌","🍉","🍇","🍓","🫐","🍈","🍑","🥭","🍍","🥝","🍅 ","🍆","🥑"]
    
    private var emojiArray: [String] { // the emoji set corresponding to the currently selected theme
        switch selectedTheme {
        case .vehicles:
            return vehicleEmojis.shuffled()
        case .animals:
            return animalEmojis.shuffled()
        case .fruit:
            return foodEmojis.shuffled()
        }
    }
    
    private var numberOfCards: Int { // Extra Credit 1: show random number of cards between 4 and theme max every time new theme appears
        Int.random(in: 4...emojiArray.count)
    }
    
    var body: some View {
        VStack {
            Text("Memorize!")
                .font(.largeTitle)
            
            ScrollView { // card view area
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                    ForEach(emojiArray[0..<numberOfCards], id: \.self) { emoji in
                        CardView(content: emoji)
                            .aspectRatio(2/3, contentMode: .fit)
                    }
                }
            }
            
            Spacer()
            
            HStack { // theme buttons area
                Spacer()
                
                Button {
                    selectedTheme = .vehicles
                } label: {
                    VStack {
                        Image(systemName: "car").font(.title)
                        Text("vehicles").font(.footnote)
                    }
                }
                
                Spacer()
                
                Button {
                    selectedTheme = .animals
                } label: {
                    VStack {
                        Image(systemName: "pawprint").font(.title)
                        Text("animals").font(.footnote)
                    }
                }
                
                Spacer()
                
                Button {
                    selectedTheme = .fruit
                } label: {
                    VStack {
                        Image(systemName: "leaf").font(.title)
                        Text("fruits").font(.footnote)
                    }
                }
                
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}

struct CardView: View {
    var content: String
    
    @State private var isFaceUp = true
    private let cardShape = RoundedRectangle(cornerRadius: 20)
    
    var body: some View {
        ZStack {
            if isFaceUp { // front side
                cardShape
                    .fill()
                    .foregroundColor(.white)
                cardShape
                    .strokeBorder(lineWidth: 3)
                    .foregroundColor(.red)
                Text(content)
                    .font(.largeTitle)
            } else { // back side
                cardShape
                    .fill()
                    .foregroundColor(.white)
            }
        }
        .onTapGesture {
            isFaceUp.toggle()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
        ContentView()
            .preferredColorScheme(.light)
    }
}
