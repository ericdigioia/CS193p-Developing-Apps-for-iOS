//
//  SetApp.swift
//  Set
//
//  Created by Eric Di Gioia on 7/4/22.
//

import SwiftUI

@main
struct SetApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ViewModel())
        }
    }
}
