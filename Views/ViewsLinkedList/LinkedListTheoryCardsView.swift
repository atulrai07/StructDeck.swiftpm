//
//  LinkedListTheoryCardsView.swift
//  DSAK
//
//  Created by Atul on 13/02/26.
//

import SwiftUI

struct LinkedListTheoryCardsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var visualizeSheet: Bool = false
    @State private var currentCardID: TheoryCard.ID?
    
    let cards: [TheoryCard] = TheoryData.linkedListCards
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(cards) { card in
                        LinkedListTheoryCardCell(card: card)
                            .modifier(ContainerFrameModifier())
                    }
                }
                .modifier(ScrollTargetLayoutModifier())
            }
            .modifier(ScrollTargetBehaviorModifier())
            .ignoresSafeArea()
            .modifier(ScrollPositionModifier(currentCardID: $currentCardID))
            .onAppear {
                if currentCardID == nil {
                    currentCardID = cards.first?.id
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                if let id = currentCardID,
                   let index = cards.firstIndex(where: { $0.id == id }) {
                    Text("\(index + 1) of \(cards.count)")
                        .font(.headline)
                        .foregroundStyle(.gray)
                } else {
                    Text("1 of \(cards.count)")
                        .font(.headline)
                        .foregroundStyle(.gray)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    visualizeSheet = true
                } label: {
                    HStack {
                        Text("Visualize")
                        Image(systemName: "chevron.left.forwardslash.chevron.right")
                    }
                }
            }
        }
        .sheet(isPresented: $visualizeSheet) {
            NavigationStack {
                LinkedListVisualizerView()
            }
            .presentationDetents([.large])
        }
    }
}

struct LinkedListTheoryCardCell: View {
    let card: TheoryCard
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: card.iconName)
                .font(.system(size: 80))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(card.isBridge ? .green : .orange)
            
            VStack(spacing: 16) {
                Text(card.title)
                    .font(.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
                
                Text(card.bodyText)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.gray)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
            
            if card.isBridge {
                NavigationLink(destination: LinkedListQuizView()) {
                    HStack {
                        Text("Take the Quiz")
                            .font(.headline)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(12)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 50)
                }
            } else {
                Image(systemName: "chevron.compact.down")
                    .font(.system(size: 40))
                    .foregroundStyle(.gray.opacity(0.5))
                    .offset(y: isAnimating ? 10 : -10)
                    .animation(
                        .easeInOut(duration: 1.0)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
                    .onAppear {
                        isAnimating = true
                    }
                    .padding(.bottom, 50)
            }
        }
        .padding()
        .background(Color.appBackground)
    }
}

#Preview {
    NavigationStack {
        LinkedListTheoryCardsView()
            .preferredColorScheme(.dark)
    }
}
