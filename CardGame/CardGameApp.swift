//
//  CardGameApp.swift
//  CardGame
//
//  Created by Daichi Morihara on 2021/10/08.
//

import SwiftUI

@main
struct CardGameApp: App {
    @StateObject var store = ThemeStore()
    
    
    var body: some Scene {
        WindowGroup {
            ThemeChooser(store: store)
        }
    }
}
