//
//  CompletionView.swift
//  DSAK
//
//  Created by Atul on 30/12/25.
//

import SwiftUI

struct CompletionView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // 1. Success Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .frame(width: 120, height: 120)
                    .blur(radius: 10)
                    .opacity(0.5)
                
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.white)
                    .shadow(radius: 10)
            }
            .padding(.bottom, 20)
            
            // 2. Confidence Text
            VStack(spacing: 12) {
                Text("You're Conceptually Ready")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white)
                
                Text("Start practicing DSA questions online related to this topic online to strengthen your understanding.")

                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.gray)
                    .padding(.horizontal, 30)
            }
            
            Spacer()
            
            // 3. Summary Cards (Cosmetic)
            HStack(spacing: 12) {
                CompletionBadge(icon: "book.fill", text: "Concept")
                CompletionBadge(icon: "eye.fill", text: "Visuals")
                CompletionBadge(icon: "checkmark.shield.fill", text: "Quiz")
            }
            
            Spacer()
            
            // ✅ NEW: Hides only the "Back" button, keeps the Title visible
            NavigationLink(destination: OpeningScreenView().navigationBarBackButtonHidden(true)) {
                Text("Back to Topics")
                    .font(.headline)
                    .bold()
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            }
        }
        .padding()
        .background(Color.appBackground.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}

// Helper Badge View
struct CompletionBadge: View {
    let icon: String
    let text: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.green)
            Text(text)
                .font(.caption)
                .bold()
                .foregroundStyle(.gray)
        }
        .frame(width: 90, height: 80)
        .background(Color(uiColor: .secondarySystemBackground).opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    CompletionView()
        .preferredColorScheme(.dark)
}
