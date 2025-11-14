//
//  animation.swift
//  Cue
//
//  Created by Isaac Moore on 11/13/25.
//

import SwiftUI

struct ExpandingCardAnimation: View {
    @Namespace private var animation
    @State private var selectedCard: Int? = nil
    
    let cards = [1, 2, 3, 4]
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(cards, id: \.self) { card in
                        if selectedCard == card {
                            Color.clear.frame(height: 200) // Keeps layout stable
                        } else {
                            CardView(card: card)
                                .matchedGeometryEffect(id: card, in: animation)
                                .frame(height: 200)
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                        selectedCard = card
                                    }
                                }
                        }
                    }
                }
                .padding()
            }
            
            if let card = selectedCard {
                ZStack(alignment: .topTrailing) {
                    CardView(card: card)
                        .matchedGeometryEffect(id: card, in: animation)
                        .ignoresSafeArea()
                    
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
//                        withAnimation(.easeInOut) {
                            selectedCard = nil
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                            .padding()
                            .foregroundStyle(.white)
                    }
                }
                .transition(.opacity)
            }
        }
    }
}

struct CardView: View {
    let card: Int
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                .shadow(radius: 10)
            Text("Card \(card)")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
        }
    }
}

#Preview {
    ExpandingCardAnimation()
}
