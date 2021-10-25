//
//  ThemeStore.swift
//  CardGame
//
//  Created by Daichi Morihara on 2021/10/23.
//

import SwiftUI

class ThemeStore: ObservableObject {
    @Published var themes = [Theme]() {
        didSet{
            storeDataInDefaults()
        }
    }
    
    init() {
        restoreDataFromDefaults()
        if themes.isEmpty {
            themes = [Theme(name: "Animals", emojis: "🐱🐶🐭🐹🐼🐻🦊🐰🐨🐯🦁", numbers: 3, color: "red", id: 1),
                      Theme(name: "Vehicles", emojis: "🚗🚕🚙🚌🚑🚓🏎🚎", numbers: 4, color: "blue", id: 2),
                      Theme(name: "Food", emojis: "🍎🍏🍋🍌🍉🍇🍒🍈🍆🥒🥑", numbers: 5, color: "green", id: 3)
            ]
        }
    }
    
    private var userDefaultsKey: String {
        "PrivateKey"
    }
    
    private func storeDataInDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(themes), forKey: userDefaultsKey)
    }
    
    private func restoreDataFromDefaults() {
        if let jsonData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedThemes = try? JSONDecoder().decode(Array<Theme>.self, from: jsonData) {
            themes = decodedThemes
        }
    }
    
    // Mark - Intent
    func updata(from theme: Theme) {
        var newTheme = themes.filter({ $0.id == theme.id }).onlyOne!
        newTheme.name = theme.name
        newTheme.emojis = theme.emojis
        newTheme.numbers = theme.numbers
        newTheme.color = theme.color
        if let index = themes.firstIndex(where: { $0.id == newTheme.id }) {
            themes[index] = newTheme
        }
    }
    
    
}
