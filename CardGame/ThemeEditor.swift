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
            colorSection
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
                                if emojis.count > 2 {
                                    if theme.numbers == emojis.count {
                                        theme.numbers -= 1
                                        theme.emojis.removeAll(where: { String($0) == emoji })
                                    } else {
                                        theme.emojis.removeAll(where: { String($0) == emoji })
                                    }
                                }
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
            let emojiCount = theme.emojis.map{ String($0) }.count
            Stepper(value: $theme.numbers,
                    in: emojiCount > 1 ? 2...emojiCount : 2...2,
                    step: 1) {
                Text("\(theme.numbers) Pairs")
            }
        }
    }
    
    var colorSection: some View {
        Section(header: Text("COLOR")) {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40 ))]) {
                let shape = RoundedRectangle(cornerRadius: 3)
                ForEach(colors, id: \.self) { color in
                    ZStack {
                        shape.foregroundColor(makingColor(from: color))
                        shape.stroke(lineWidth: 1).foregroundColor(.gray)
                        if theme.color == color {
                            Image(systemName: "checkmark.circle")
                                .scaleEffect(1.5)
                                .foregroundColor(.white)
                        }
                    }
                    .aspectRatio(2/3, contentMode: .fit)
                    .onTapGesture {
                        withAnimation {
                            theme.color = color
                        }
                    }
                }
            }
        }
    }
    
    
    var colors = ["red", "blue", "green", "orange", "yellow", "purple", "gray"]
    
    func makingColor(from color: String) -> Color {
        switch color  {
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



//struct ThemeEditor_Previews: PreviewProvider {
//    static var previews: some View {
//        ThemeEditor()
//    }
//}
