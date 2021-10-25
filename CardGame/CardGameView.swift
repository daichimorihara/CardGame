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
    @Environment (\.presentationMode) var presentationMode

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                cardbody.foregroundColor(themeColor(of: document.theme))
                HStack {
                    shuffle
                    Spacer()
                    restart
                }
            }
            instruction.blinkEffect().padding(.bottom, 110)
            deck.padding(.bottom).foregroundColor(themeColor(of: document.theme))
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: customedBackButton)
    }
    
    var customedBackButton: some View {
        Button(action: {
            document.restart()
            dealt.removeAll()
            presentationMode.wrappedValue.dismiss()
            
        }, label: {
            HStack {
                Image(systemName: "chevron.backward")
                Text("Back")
            }
            .foregroundColor(.blue)
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
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .frame(width: 60, height: 90)
        .onTapGesture {
            for card in document.cards {
                withAnimation(Animation.linear(duration: 0.5).delay(delayfunc(card))) {
                    deal(card)
                }
            }
                
            
        }
    }
    
    var restart: some View {
        Button("Restart") {
            withAnimation {
                document.restart()
                dealt = []
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
    
    var instruction: some View {
        Text("Tap this card")
            .opacity(dealt.isEmpty ? 1 : 0)
            .animation(Animation.linear(duration: 0.01))
    }
}
    

struct CardView: View {
    var card: MemoryGame<String>.Card
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .opacity(DrawingConstants.opacity)
                    .padding(DrawingConstants.padding)
//                Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(120-90))
//                    .opacity(DrawingConstants.opacity)
//                    .padding(DrawingConstants.padding)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(Animation.linear(duration: 1.0).repeatCount(2, autoreverses: false))
                    .font(Font.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
                   // .font(fontSize(in: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp)
            
        }
    }
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
//    private func fontSize(in size: CGSize) -> Font {
//        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
//    }
    
    struct DrawingConstants {
        static let opacity: Double = 0.3
        static let padding: CGFloat = 3
        static let fontScale:CGFloat = 0.7
        static let fontSize: CGFloat = 32
    }
}
