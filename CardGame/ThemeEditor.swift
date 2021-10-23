//
//  ThemeEditor.swift
//  CardGame
//
//  Created by Daichi Morihara on 2021/10/23.
//

import SwiftUI

struct ThemeEditor: View {
    @Binding var theme: Theme
    var body: some View {
        Form {
            nameSection
            removeEmojisSection
            addEmojisSection
            cardCountSection
//            colorSection
        }
    }
    var nameSection : some View {
        Section(header: Text("THEME NAME")) {
            TextField("Name", text: $theme.name)
        }
    }
    
    var removeEmojisSection: some View {
        Section(header: Text("EMOJIS")) {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                let emojis = theme.emojis.map { String($0) }
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                theme.emojis.removeAll(where: { String($0) == emoji })
                            }
                        }
                }
            }
           
        }
    }
    @State private var emojisToAdd: String = ""
    
    var addEmojisSection: some View {
        Section(header: Text("ADD EMOJI")) {
            TextField("", text: $emojisToAdd)
                .onChange(of: emojisToAdd) { emojis in
                    addEmojis(emojis)
                }
        }
    }
    
    private func addEmojis(_ emojis: String) {
        theme.emojis = theme.emojis + emojis
            .filter{ $0.isEmoji }
            .removingDuplicateCharacters
        
    }
    
    
    var cardCountSection: some View {
        Section(header: Text("CARD COUNT")) {
            Stepper(value: $theme.numbers,
                    in: 2...theme.emojis.map{ String($0) }.count,
                    step: 1) {
                Text("\(theme.numbers) Pairs")
            }
        }
    }
}

//struct ThemeEditor_Previews: PreviewProvider {
//    static var previews: some View {
//        ThemeEditor()
//    }
//}
