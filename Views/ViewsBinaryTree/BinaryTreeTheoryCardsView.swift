//
//  BinaryTreeTheoryCardsView.swift
//  DSAK
//
//  Created by Atul on 18/02/26.
//

import SwiftUI

struct BinaryTreeTheoryCardsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var visualizeSheet: Bool = false
    
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
                } else {
                    Text("1 of \(cards.count)")
                        .font(.headline)
                        .foregroundStyle(.gray)
                }
            }
            
            // Visualize Button
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    visualizeSheet = true
                } label: {
                    HStack {
                        Text("Visualize")
                        Image(systemName: "swift")
                    }
                    .foregroundStyle(.white)
                }
            }
        }
        .sheet(isPresented: $visualizeSheet) {
            NavigationStack {
                BinaryTreeVisualizerView()
            }
            .presentationDetents([.large])
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

// MARK: - Compatibility Modifiers

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
