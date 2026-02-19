//
//  TheoryCardsView.swift
//  DSAK
//
//  Created by Atul on 30/12/25.
//

import SwiftUI

struct TheoryCardsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var visualizeSheet : Bool = false
    @State private var currentCardID: TheoryCard.ID?
    
    let cards: [TheoryCard] = TheoryData.stackCards
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(cards) { card in
                        TheoryCardCell(card: card)
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
            ToolbarItem(placement : .topBarTrailing){
                Button{
                    visualizeSheet = true
                }label: {
                    HStack {
                        Text("Visualize")
                        Image(systemName: "chevron.left.forwardslash.chevron.right")
                    }
                }
                .accessibilityHint("Opens the interactive Stack Visualizer.")
            }
            
            ToolbarItem(placement: .principal) {
                if let id = currentCardID,
                   let index = cards.firstIndex(where: { $0.id == id }) {
                    Text("\(index + 1) of \(cards.count)")
                        .font(.headline)
                        .foregroundStyle(.gray)
                        .accessibilityLabel("Page \(index + 1) of \(cards.count)")
                } else {
                    Text("1 of \(cards.count)")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .accessibilityLabel("Page 1 of \(cards.count)")
                }
            }
        }
        .sheet(isPresented: $visualizeSheet){
             NavigationStack {
                StackVisualizerView()
                    .presentationDetents([.large])
            }
        }
    }
}

struct TheoryCardCell: View {
    let card: TheoryCard
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: card.iconName)
                .font(.system(size: 80))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(card.isBridge ? .green : .blue)
                .accessibilityHidden(true)
            
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
            .accessibilityElement(children: .combine)
            
            Spacer()
            
            if (card.isBridge) {
                NavigationLink(destination: StackQuizView()) {
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
                .accessibilityHint("Navigates to the Stack Quiz.")
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
                    .accessibilityHidden(true)
            }
        }
        .padding()
        .background(Color.appBackground)
    }
}

