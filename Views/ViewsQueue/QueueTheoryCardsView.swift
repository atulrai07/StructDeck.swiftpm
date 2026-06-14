//
//  QueueTheoryCardsView.swift
//  DSAK
//
//  Created by Atul on 13/02/26.
//

import SwiftUI

struct QueueTheoryCardsView: View {
    @Environment(\.dismiss) var dismiss

    @State private var currentCardID: TheoryCard.ID?
    
    // LOAD QUEUE DATA
    let cards: [TheoryCard] = TheoryData.queueCards
    
    var body: some View {
        ZStack {
            gradientAppBackground()
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(cards) { card in
                        QueueTheoryCardCell(card: card)
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
            
            // Visualize Button
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    QueueVisualizerView()
                } label: {
                    HStack {
                        Text("Visualize")
                        Image(systemName: "chevron.left.forwardslash.chevron.right")
                    }
                    .foregroundStyle(.white)
                }
                .accessibilityHint("Opens the interactive Queue Visualizer.")
            }
            
            // Page Counter
            ToolbarItem(placement: .principal) {
                if let id = currentCardID,
                   let index = cards.firstIndex(where: { $0.id == id }) {
                    Text("\(index + 1) of \(cards.count)")
                        .font(.headline)
                        .foregroundStyle(.gray)
                        .accessibilityLabel("Page \(index + 1) of \(cards.count)") //page label
                } else {
                    Text("1 of \(cards.count)")
                        .font(.headline)
                        .foregroundStyle(.gray)
                        .accessibilityLabel("Page 1 of \(cards.count)") //page label
                }
            }
        }

    }
}

struct QueueTheoryCardCell: View {
    let card: TheoryCard
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: card.iconName)
                .font(.system(size: 80))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(card.isBridge ? .green : .teal)
                .accessibilityHidden(true) // Hide large icon
            
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
            .accessibilityElement(children: .combine) // Combine title and body text to read both of them and read them combined.
            
            Spacer()
            
            if card.isBridge {
                NavigationLink(destination: QueueQuizView()) {
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
                .accessibilityHint("Navigates to the Queue Quiz.")
                .onAppear {
                    UserProgressManager.shared.markTheoryCompleted(moduleId: "queue", moduleName: "Queue", category: "dataStructure")
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
                    .accessibilityHidden(true)
            }
        }
        .padding()
        .background(gradientAppBackground().opacity(0))
    }
}

#Preview {
    NavigationStack {
        QueueTheoryCardsView()
            .preferredColorScheme(.dark)
    }
}
