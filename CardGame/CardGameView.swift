//
//  CardGameView.swift
//  CardGame
//
//  Created by Daichi Morihara on 2021/10/23.
//

import SwiftUI

struct CardGameView: View {
    @ObservedObject var document: EmojiMemoryGame
    @Namespace var namespacing

    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                cardbody
                HStack {
                    shuffle
                    Spacer()
                    restart
                }
            }
            deck.padding(.bottom).foregroundColor(themeColor(of: document.theme))
        }
        .padding()
    }
    
    private func themeColor(of theme: Theme) -> Color {
        switch theme.color {
        case "red": return .red
        case "blue": return .blue
        case "green": return .green
        default: return .yellow
        }
    }
    var cardbody: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))]) {
                ForEach(document.cards) { card in
                    if undealt(card) || (card.isMatched && !card.isFaceUp){
                        Color.clear
                    } else {
                        CardView(card: card)
                            .matchedGeometryEffect(id: card.id, in: namespacing)
                            .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                withAnimation {
                                    document.choose(card)
                                }
                            }
                    }
                }
            }
            .padding()
        }
    }
    @State private var dealt = Set<Int>()
    
    private func undealt(_ card: MemoryGame<String>.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func deal(_ card: MemoryGame<String>.Card) {
        dealt.insert(card.id)
    }
    
    private func delayfunc(_ card: MemoryGame<String>.Card) -> Double {
        var delay = 0.0
        if let index = document.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) / Double(document.cards.count)
         }
        return delay
    }
    
    
    var deck: some View {
        ZStack {
            ForEach(document.cards.filter({ undealt($0) })) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: namespacing)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
            }
        }
        .frame(width: 60, height: 90)
        .onTapGesture {
            for card in document.cards {
                withAnimation(Animation.linear(duration: 1.0).delay(delayfunc(card))) {
                    deal(card)
                }
            }
                
            
        }
    }
    
    var restart: some View {
        Button("Restart") {
            withAnimation {
                dealt = []
                document.restart()
            }
        }
    }
    
        
    var shuffle: some View {
        Button("Shuffle") {
            withAnimation {
                document.shuffle()
            }
        }
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(120-90))
                    .opacity(DrawingConstants.opacity)
                    .padding(DrawingConstants.padding)
                Text(card.content)
                    .font(fontSize(in: geometry.size))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
            }
            .cardify(isFaceUp: card.isFaceUp)
            
        }
    }
    private func fontSize(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    struct DrawingConstants {
        static let opacity: Double = 0.3
        static let padding: CGFloat = 3
        static let fontScale:CGFloat = 0.7
    }
}


//struct CardGameView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardGameView(document: EmojiMemoryGame(theme: <#T##Theme#>))
//    }
//}
