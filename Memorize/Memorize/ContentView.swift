//
//  ContentView.swift
//  Memorize
//
//  Created by Eric Di Gioia on 6/27/22.
//

import SwiftUI

struct ContentView: View {
    private let emojiArray = ["🚗","🚕","🚙","🚌","🚎","🏎","🚓","🚑","🚒","🚐","🛻","🚚","🚛","🚜","🛴","🚲","🛵","🏍","🛺","🚅"]
    @State private var numberOfCards = 4 {
        didSet { if numberOfCards < 1 { numberOfCards = 1 } }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                        ForEach(emojiArray[0..<numberOfCards], id: \.self) { emoji in
                            CardView(content: emoji)
                                .aspectRatio(2/3, contentMode: .fit)
                        }
                    }
                }
                
                Spacer()
                
                HStack {
                    Button() {
                        numberOfCards -= 1
                    } label: {
                        Image(systemName: "minus.circle")
                            .font(.largeTitle)
                    }
                    
                    Spacer()
                    
                    Button() {
                        numberOfCards += 1
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.largeTitle)
                    }
                }
            }
            .padding()
            .navigationTitle("Memorize!")
        }
    }
}

struct CardView: View {
    var content: String
    
    @State private var isFaceUp = true
    private let cardShape = RoundedRectangle(cornerRadius: 20)
    
    var body: some View {
        ZStack {
            if isFaceUp {
                cardShape
                    .fill()
                    .foregroundColor(.white)
                cardShape
                    .strokeBorder(lineWidth: 3)
                    .foregroundColor(.red)
                Text(content)
                    .font(.largeTitle)
            } else {
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
    }
}
