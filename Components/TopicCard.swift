//
//  TopicCard.swift
//  DSAK
//
//  Created by Atul on 30/12/25.
//

import SwiftUI

struct TopicCard: View {
    let title: String
    let subtitle: String
    let cardBackground: AnyShapeStyle
    let iconName: String
    let time: String
    
    var body: some View {
        ZStack {
            // Background Gradient
            RoundedRectangle(cornerRadius: 24)
                .fill(cardBackground)
                .opacity(0.9)
            
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top) {
                    Image(systemName: iconName)
                        .font(.system(size: 40))
                        .foregroundStyle(.blue)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.title)
                            .bold()
                            .foregroundStyle(.white)
                            .padding(.top,5)
                        
//                        Text(subtitle)
//                            .font(.caption)
//                            .foregroundStyle(.white.opacity(0.8))
                        
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(.white.opacity(0.6))
                }
                
                // Middle Row: Learning Path
                HStack(spacing: 8) {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                    
//                    Text("•")
//                    
//                    Image(systemName: "clock")
//                    Text(time)
                }
                .font(.caption2)
                .fontWeight(.bold)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.ultraThinMaterial.opacity(0.3)) // Glass effect
                .cornerRadius(20)
                .foregroundStyle(.white)
                
                // Bottom Row: Time
                HStack {
                    Image(systemName: "clock")
                    Text(time)
//                    Text("•")
//                    Image(systemName: "square.grid.2x2")
//                    Text("Interactive Module")
                }
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.white.opacity(0.8))
                .padding(.leading,10)
            }
            .padding(20)
        }
        .frame(height: 160)
    }
}

#Preview {
    TopicCard(title: "Something", subtitle: "subtitle", cardBackground: AnyShapeStyle(.thinMaterial), iconName: "trash", time: "23:45")
}
