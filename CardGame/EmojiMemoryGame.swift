//
//  EmojiMemoryGame.swift
//  CardGame
//
//  Created by Daichi Morihara on 2021/10/08.
//

import SwiftUI


class EmojiMemoryGame: ObservableObject {
    
    static let emojis = ["🚗","🚀","✈️","🚁","🛥","⚓️","🦼","🚛","🚒","🧩","🎲","🎹","🎨","🏅"]
    
    @Published private var game: MemoryGame<String>
    
    init() {
        game = Self.createEmojiMemoryGame()
        }
    
    static private func createEmojiMemoryGame() -> MemoryGame<String> {
        MemoryGame(numberOfPairs: 4, createCardContent: { index in
            emojis[index]
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
        game = Self.createEmojiMemoryGame()
    }
}

