//
//  CollectionCard.swift
//  DSAK
//
//  Created by Atul on 17/02/26.
//

import SwiftUI

struct CollectionCard: View {
    let title: String
    let books: [BookData]
    
    var body: some View {
        HStack(spacing: 0) {
            // Title Left
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .multilineTextAlignment(.leading)
                .padding(.leading, 20)
            
            Spacer()
            
            // The Books Visual Right
            ZStack(alignment: .trailing) {
                ForEach(Array(books.enumerated()), id: \.offset) { index, book in
                    BookView(color: book.color, icon: book.icon)
                        .offset(x: CGFloat(index * -35)) // Fan out to the left
                        .zIndex(Double(books.count - index)) // Front items on top
                        .scaleEffect(index == books.count - 1 ? 1.0 : 0.95) // Front item slightly larger
                }
            }
            .padding(.trailing, 24)
            .padding(.vertical, 20)
        }
        .frame(height: 190)
        .background(Color.gray.opacity(0.2)) // Card Background
        .cornerRadius(24)
    }
}

// Model for Books
struct BookData {
    let color: Color
    let icon: String
}

// The Single View
struct BookView: View {
    let color: Color
    let icon: String
    
    var body: some View {
        ZStack {
            // Book Spine
            RoundedRectangle(cornerRadius: 6)
                .fill(color.gradient)
                .frame(width: 80, height: 135)
                .overlay(
                    HStack {
                        Color.white.opacity(0.2)
                            .frame(width: 4)
                        Spacer()
                    }
                )
                .shadow(color: .black.opacity(0.3), radius: 5, x: -2, y: 0)
            
            // Icon on Spine
            VStack {
                Spacer()
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(.white.opacity(0.9))
                    .padding(.bottom, 12)
            }
        }
    }
}

#Preview {
    CollectionCard(
        title: "Linear\nStructures",
        books: [
            BookData(color: .blue, icon: "circle.grid.2x2.fill"),
            BookData(color: .green, icon: "tray.full.fill"),
            BookData(color: .pink, icon: "square.stack.3d.up.fill"),
            BookData(color: .cyan, icon: "link")
        ]
    )
    .padding()
    .background(gradientAppBackground())
}
