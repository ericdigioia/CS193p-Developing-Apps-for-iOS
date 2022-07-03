//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Eric Di Gioia on 6/27/22.
//

import SwiftUI

@main
struct MemorizeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: EmojiMemoryGame())
        }
    }
}
