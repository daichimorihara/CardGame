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
    @State private var plusIsPresented = false
    @State private var editIsPresented = false
    @State private var selectedTheme: Theme = Theme(name: "", emojis: "", numbers: 2, color: "red", id: 0)
    
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
                        .gesture(editMode == .active ? tap(theme: theme) : nil)
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
                plusIsPresented = true
            }) {
                Image(systemName: "plus")
            }, trailing: EditButton() )
            .sheet(isPresented: $editIsPresented) {
                NavigationView {
                    ThemeEditor(theme: $selectedTheme)
                        .navigationTitle("Theme Editor")
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarItems(leading: Button("Cancel") {
                            selectedTheme = Theme(name: "New", emojis: "", numbers: 2, color: "red", id: 0)
                            editIsPresented = false
                        }, trailing: Button("Save") {
                            store.updata(from: selectedTheme)
                            selectedTheme = Theme(name: "New", emojis: "", numbers: 2, color: "red", id: 0)
                            editIsPresented = false
                        })
                }
            }
            .sheet(isPresented: $plusIsPresented) {
                NavigationView {
                    ThemeEditor(theme: $selectedTheme)
                        .alert(item: $alertToShow) { alertToShow in
                            alertToShow.alert()
                        }
                        .navigationTitle("Theme Editor")
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarItems(leading: Button("Cancel") {
                            selectedTheme = Theme(name: "New", emojis: "", numbers: 2, color: "red", id: 0)
                            plusIsPresented = false
                        }, trailing: Button("Save") {
                            selectedTheme.id = store.themes.max(by: { $0.id < $1.id })!.id + 1
                            if selectedTheme.emojis.map({ String($0) }).count > 1 {
                                store.themes.append(selectedTheme)
                                selectedTheme = Theme(name: "New", emojis: "", numbers: 2, color: "red", id: 0)
                                plusIsPresented = false
                            } else {
                                showMinimumNumberAlert()
                            }
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
    
    private func tap(theme: Theme) -> some Gesture {
        TapGesture()
            .onEnded {
                editIsPresented = true
                selectedTheme = theme
            }
    }
}

struct ThemeChooser_Previews: PreviewProvider {
    static var previews: some View {
        ThemeChooser(store: ThemeStore())
    }
}
