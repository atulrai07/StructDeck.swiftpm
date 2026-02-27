//
//  BinaryTreeTheoryCardsView.swift
//  DSAK
//
//  Created by Atul on 18/02/26.
//

import SwiftUI

struct BinaryTreeTheoryCardsView: View {
    @Environment(\.dismiss) var dismiss

    
    // Page Number State
    @State private var currentCardID: TheoryCard.ID?
    
    // LOAD BINARY TREE DATA
    let cards: [TheoryCard] = TheoryData.binaryTreeCards
    
    var body: some View {
        ZStack {
            gradientAppBackground()
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(cards) { card in
                        BinaryTreeTheoryCardCell(card: card)
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
            // Page Counter
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
                        .foregroundStyle(.gray)
                        .accessibilityLabel("Page 1 of \(cards.count)")
                }
            }
            
            // Visualize Button
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    BinaryTreeVisualizerView()
                } label: {
                    HStack {
                        Text("Visualize")
                        Image(systemName: "chevron.left.forwardslash.chevron.right")
                    }
                    .foregroundStyle(.white)
                }
                .accessibilityLabel("Visualize")
                .accessibilityHint("Double tap to open the interactive Binary Tree visualizer.")
            }
        }

    }
}

struct BinaryTreeTheoryCardCell: View {
    let card: TheoryCard
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: card.iconName)
                .font(.system(size: 80))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(card.isBridge ? .green : .mint)
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
            
            if card.isBridge {
                NavigationLink(destination: BinaryTreeQuizView()) {
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
                .accessibilityLabel("Take the Quiz")
                .accessibilityHint("Double tap to start the Binary Tree quiz.")
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
                    .padding(.bottom, 40)
                    .accessibilityHidden(true)
            }
        }
        .padding()
        .background(gradientAppBackground().opacity(0))
    }
}

#Preview {
    NavigationStack {
        BinaryTreeTheoryCardsView()
            .preferredColorScheme(.dark)
    }
}

//Compatibility Modifiers

struct ContainerFrameModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content.containerRelativeFrame(.vertical)
        } else {
            content
        }
    }
}

struct ScrollTargetLayoutModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content.scrollTargetLayout()
        } else {
            content
        }
    }
}

struct ScrollTargetBehaviorModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content.scrollTargetBehavior(.paging)
        } else {
            content
        }
    }
}

struct ScrollPositionModifier: ViewModifier {
    @Binding var currentCardID: TheoryCard.ID?
    
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content.scrollPosition(id: $currentCardID)
        } else {
            content
        }
    }
}
