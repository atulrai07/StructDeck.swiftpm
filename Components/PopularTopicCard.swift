//
//  PopularTopicCards.swift
//  DSAK
//
//  Created by Atul on 17/02/26.
//

import SwiftUI

// The Featured Topic Card 
struct PopularTopicCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let colors: [Color]
    
    var body: some View {
        VStack(alignment: .leading) {
            // Visual Top
            ZStack {
                LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
                
                Image(systemName: icon)
                    .font(.system(size: 44))
                    .foregroundStyle(.white)
            }
            .frame(height: 120)
            .padding(.bottom,-4)
            // Text Bottom
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            //.background(Color(white: 0.12)) // Dark gray text area
            .background(Color.gray.opacity(0.2))
        }
        .frame(width: 160)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    PopularTopicCard(
        title: "Stack",
        subtitle: "LIFO • 10 min",
        icon: "square.stack.3d.up.fill",
        colors: [.blue, .purple]
    )
    .padding()
    .background(gradientAppBackground())
    .preferredColorScheme(.dark)
}
