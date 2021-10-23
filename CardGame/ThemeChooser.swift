//
//  ThemeChooser.swift
//  CardGame
//
//  Created by Daichi Morihara on 2021/10/23.
//

import SwiftUI

struct ThemeChooser: View {
    @ObservedObject var store: ThemeStore
    @State private var editMode: EditMode = .inactive
    @State private var isPresented = false
    @State private var selectedTheme: Theme?
//    @State private var themeAndGame: [Theme : EmojiMemoryGame ] = [:]
//    [Theme(name: "Animals", emojis: "🐱🐶🐭🐹🐼🐻🦊🐰🐨🐯🦁", numbers: 3, color: "red", id: 1) : EmojiMemoryGame(theme: Theme(name: "Animals", emojis: "🐱🐶🐭🐹🐼🐻🦊🐰🐨🐯🦁", numbers: 3, color: "red", id: 1)),
//     Theme(name: "Vehicles", emojis: "🚗🚕🚙🚌🚑🚓🏎🚎", numbers: 4, color: "blue", id: 2) : EmojiMemoryGame(theme: Theme(name: "Vehicles", emojis: "🚗🚕🚙🚌🚑🚓🏎🚎", numbers: 4, color: "blue", id: 2)),
//     Theme(name: "Food", emojis: "🍎🍏🍋🍌🍉🍇🍒🍈🍆🥒🥑", numbers: 5, color: "green", id: 3) : EmojiMemoryGame(theme: Theme(name: "Food", emojis: "🍎🍏🍋🍌🍉🍇🍒🍈🍆🥒🥑", numbers: 5, color: "green", id: 3))
//    ]
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes, id: \.self) { theme in
                    NavigationLink(destination: CardGameView(document: EmojiMemoryGame(theme: theme))) {
                        VStack(alignment: .leading) {
                            Text(theme.name)
                                .font(.title)
                                .foregroundColor(themeColor(of: theme))
                            HStack(spacing: 0) {
                                if theme.numbers == theme.emojis.map{ String($0) }.count {
                                    Text("All of ")
                                } else {
                                    Text("\(theme.numbers) pairs from ")
                                }
                                Text(theme.emojis)
                            }
                            .lineLimit(1)
                        }
                        .gesture(editMode == .active ? TapGesture().onEnded { selectedTheme = theme } : nil)
                        
                    }
                }
                .onDelete { indexSet in
                    store.themes.remove(atOffsets: indexSet)
                }
                .onMove { indexSet, newSet in
                    store.themes.move(fromOffsets: indexSet, toOffset: newSet)
                }
            }
            .navigationBarItems(leading: Button(action: {}) {
                Image(systemName: "plus")
            }, trailing: Button(action: {}) {
                EditButton()
            })
            .sheet(item: $selectedTheme) { theme in
                NavigationView {
                    ThemeEditor(theme: $store.themes[theme])
                        .navigationTitle("Theme Editor")
                        .navigationBarItems(leading: Button("Close") {
                            selectedTheme = nil
                        })
                }
            }
            .environment(\.editMode, $editMode)
            
            
        }
    }
    
//    var tap: some Gesture {
//        TapGesture()
//            .onEnded {
//                isPresented = true
//            }
//    }
    
    private func themeColor(of theme: Theme) -> Color {
        switch theme.color {
        case "red": return .red
        case "blue": return .blue
        case "green": return .green
        default: return .yellow
        }
    }
}

struct ThemeChooser_Previews: PreviewProvider {
    static var previews: some View {
        ThemeChooser(store: ThemeStore())
    }
}
