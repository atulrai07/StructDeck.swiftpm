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
    
    var theoryCompleted: Bool = false
    var visualizerVisited: Bool = false
    var quizCompleted: Bool = false
    
    private var progressText: String? {
        let count = [theoryCompleted, visualizerVisited, quizCompleted].filter { $0 }.count
        if count == 3 {
            return "Completed"
        } else if count > 0 {
            return "\(Int(Double(count) / 3.0 * 100))%"
        }
        return nil
    }
    
    private var progressColor: Color {
        let count = [theoryCompleted, visualizerVisited, quizCompleted].filter { $0 }.count
        if count == 3 {
            return .green
        } else {
            return .orange
        }
    }
    
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
                    }
                    
                    Spacer()
                    
                    if let progressText = progressText {
                        Text(progressText)
                            .font(.caption2)
                            .bold()
                            .foregroundStyle(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(progressColor.opacity(0.8))
                            .clipShape(Capsule())
                            .padding(.trailing, 4)
                            .padding(.top, 8)
                    }
                    
                    Image(systemName: "chevron.right")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(.white.opacity(0.6))
                        .padding(.top, 8)
                }
                
                // Middle Row: Learning Path
                HStack(spacing: 8) {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                }
                .font(.caption2)
                .fontWeight(.bold)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.ultraThinMaterial.opacity(0.3))
                .cornerRadius(20)
                .foregroundStyle(.white)
                
                HStack {
                    Image(systemName: "clock")
                    Text(time)
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
