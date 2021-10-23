//
//  EmojiMemoryGame.swift
//  CardGame
//
//  Created by Daichi Morihara on 2021/10/08.
//

import SwiftUI


class EmojiMemoryGame: ObservableObject {
    
//    static let emojis = ["🚗","🚀","✈️","🚁","🛥","⚓️","🦼","🚛","🚒","🧩","🎲","🎹","🎨","🏅"]
    
    @Published private var game: MemoryGame<String>
    
    var theme: Theme
    
    init(theme: Theme) {
        self.theme = theme
        game = Self.createEmojiMemoryGame(with: theme)
        }
    
    static private func createEmojiMemoryGame(with theme: Theme) -> MemoryGame<String> {
        MemoryGame(numberOfPairs: 4, createCardContent: { index in
//            emojis[index]
            theme.emojis.map{ String($0) }[index]
        })
    }
    
    var cards: [MemoryGame<String>.Card] {
        game.cards
    }
    
    // Mark Intent
    func choose(_ card: MemoryGame<String>.Card) {
        game.choose(card)
    }

    func shuffle() {
        game.shuffle()
    }
    
    func restart() {
        game = Self.createEmojiMemoryGame(with: theme)
    }
}

