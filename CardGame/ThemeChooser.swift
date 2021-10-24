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
    @State private var themeToAdd: Theme = Theme(name: "", emojis: "", numbers: 2, color: "red", id: 0)
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
                                .foregroundColor(editMode == .inactive ? themeColor(of: theme) : Color.black)
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
                    if store.themes.count > 1 {
                        store.themes.remove(atOffsets: indexSet)
                    }
                }
                .onMove { indexSet, newSet in
                    store.themes.move(fromOffsets: indexSet, toOffset: newSet)
                }
            }
            .navigationBarItems(leading: Button(action: {
                isPresented = true
            }) {
                Image(systemName: "plus")
            }, trailing: EditButton() )
            .sheet(item: $selectedTheme) { theme in
                NavigationView {
                    ThemeEditor(theme: $store.themes[theme])
                        .navigationTitle("Theme Editor")
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarItems(leading: Button("Close") {
                            selectedTheme = nil
                        })
                }
            }
            .sheet(isPresented: $isPresented) {
                NavigationView {
                    ThemeEditor(theme: $themeToAdd)
                        .alert(item: $alertToShow) { alertToShow in
                            alertToShow.alert()
                        }
                        .navigationTitle("Theme Editor")
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarItems(leading: Button("Cancel") {
                            themeToAdd = Theme(name: "New", emojis: "", numbers: 2, color: "red", id: 0)
                            isPresented = false
                        }, trailing: Button("Save") {
                            themeToAdd.id = store.themes.max(by: { $0.id < $1.id })!.id + 1
                            if themeToAdd.emojis.map({ String($0) }).count > 1 {
                                store.themes.append(themeToAdd)
                                themeToAdd = Theme(name: "New", emojis: "", numbers: 2, color: "red", id: 0)
                                isPresented = false
                            } else {
                                showMinimumNumberAlert()
                            }
//                            themeToAdd = Theme(name: "New", emojis: "", numbers: 2, color: "", id: 0)
//                            isPresented = false
                        })
                }
            }
            .environment(\.editMode, $editMode)
        }
    }
    
    @State private var alertToShow: IdentifiableAlert?

    private func showMinimumNumberAlert() {
        alertToShow = IdentifiableAlert(id: "can't save", alert: {
            Alert(title: Text("Emojis can't be less than 2"),
                  message: Text("Please add more than 2 emojis"),
                  dismissButton: .default(Text("OK"))
            )
        })
    }
    
    
    private func themeColor(of theme: Theme) -> Color {
        switch theme.color {
        case "red": return .red
        case "blue": return .blue
        case "green": return .green
        case "orange": return .orange
        case "yellow": return .yellow
        case "purple": return .purple
        case "gray": return .gray
        default: return .red
        }
    }
}

struct ThemeChooser_Previews: PreviewProvider {
    static var previews: some View {
        ThemeChooser(store: ThemeStore())
    }
}
