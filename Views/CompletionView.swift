//
//  CompletionView.swift
//  DSAK
//
//  Created by Atul on 30/12/25.
//

import SwiftUI

struct CompletionView: View {
    @Environment(\.dismiss) var dismiss
    
    let moduleId: String
    let moduleName: String
    let category: String
    let correctCount: Int
    let totalCount: Int
    let isAIQuiz: Bool
    
    @State private var pastAttempts: [QuizAttempt] = []
    
    private var scoreMessage: String {
        let percentage = totalCount > 0 ? (Double(correctCount) / Double(totalCount)) * 100 : 0
        if percentage == 100 {
            return "Perfect Score! You nailed every question."
        } else if percentage >= 70 {
            return "Great job! You have a solid understanding."
        } else if percentage >= 40 {
            return "Good effort! Review the concepts and try again."
        } else {
            return "Keep learning! Practice makes perfect."
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
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
            .padding(.bottom, 10)
            
            // 2. Score Text
            VStack(spacing: 8) {
                Text("\(correctCount) / \(totalCount)")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                
                Text(scoreMessage)
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
            
            // 4. Past Attempts History
            if !pastAttempts.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Past Attempts")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.8))
                        .padding(.horizontal, 4)
                    
                    ScrollView {
                        VStack(spacing: 8) {
                            ForEach(pastAttempts) { attempt in
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(attempt.wasAIGenerated ? "AI Generated Quiz" : "Standard Quiz")
                                            .font(.subheadline)
                                            .bold()
                                            .foregroundStyle(.white)
                                        Text(attempt.attemptDate.formatted(date: .abbreviated, time: .shortened))
                                            .font(.caption)
                                            .foregroundStyle(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    Text("\(attempt.correctCount) / \(attempt.totalCount)")
                                        .font(.system(.body, design: .rounded))
                                        .bold()
                                        .foregroundStyle(attempt.correctCount == attempt.totalCount ? .green : .blue)
                                }
                                .padding()
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(12)
                            }
                        }
                    }
                    .frame(maxHeight: 140)
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
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
        .background(gradientAppBackground())
        .navigationBarHidden(true)
        .onAppear {
            UserProgressManager.shared.recordQuizAttempt(
                moduleId: moduleId,
                moduleName: moduleName,
                category: category,
                correctCount: correctCount,
                totalCount: totalCount,
                wasAIGenerated: isAIQuiz
            )
            
            // Refresh past attempts from database
            if let progress = UserProgressManager.shared.getModuleProgress(moduleId: moduleId) {
                // We display previous attempts excluding the current one to see improvement, or including all attempts sorted by date.
                // The user request says "the user should also be able to see how much did he score in the previous quizes"
                // Sort attempts by newest first.
                pastAttempts = progress.quizAttempts.sorted(by: { $0.attemptDate > $1.attemptDate })
            }
        }
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
    CompletionView(moduleId: "stack", moduleName: "Stack", category: "dataStructure", correctCount: 2, totalCount: 3, isAIQuiz: false)
        .preferredColorScheme(.dark)
}
