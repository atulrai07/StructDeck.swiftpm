//
//  LinkedListQuizView.swift
//  DSAK
//
//  Created by Atul on 13/02/26.
//
//

import SwiftUI

struct LinkedListQuizView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var currentQuestionIndex = 0
    @State private var selectedOption: Int? = nil
    @State private var isCorrect: Bool = false
    @State private var showFeedback: Bool = false
    
    let questions: [QuizQuestion] = QuizData.linkedListQuestions
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Header
                HStack(alignment: .top) {
                    Color.clear.frame(width: 20)
                }
                .padding()
                
                // Question
                VStack(alignment: .leading, spacing: 12) {
                    Text(questions[currentQuestionIndex].question)
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                Spacer()
                
                // Options
                VStack(spacing: 16) {
                    ForEach(0..<questions[currentQuestionIndex].options.count, id: \.self) { index in
                        Button(action: { handleOptionSelection(index) }) {
                            HStack {
                                Text(questions[currentQuestionIndex].options[index])
                                    .font(.headline)
                                Spacer()
                                if selectedOption == index {
                                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(getBackgroundColor(for: index))
                            .foregroundStyle(.white)
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                        }
                        .disabled(showFeedback && isCorrect)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Feedback
                if showFeedback {
                    VStack(spacing: 16) {
                        Text(isCorrect ? questions[currentQuestionIndex].explanation : "Not quite. Try again!")
                            .font(.subheadline)
                            .foregroundStyle(isCorrect ? .green : .red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        if isCorrect {
                            if currentQuestionIndex < questions.count - 1 {
                                Button("Next Question") { nextQuestion() }
                                    .buttonStyle(PrimaryButtonStyle())
                            } else {
                                NavigationLink(destination: CompletionView()) {
                                    Text("See Results")
                                        .font(.headline)
                                        .bold()
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.blue)
                                        .cornerRadius(16)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 30)
                    .padding(.horizontal)
                }
            }
            .background(Color.appBackground.ignoresSafeArea())
            //header
            .toolbar{
                ToolbarItem(placement:.title){
                    Text("Question \(currentQuestionIndex + 1) of \(questions.count)")
                        .font(.subheadline)
                        .bold()
                        .foregroundStyle(.gray)
                }
            }
        }
    }
    
    // Logic
    func handleOptionSelection(_ index: Int) {
        selectedOption = index
        showFeedback = true
        if index == questions[currentQuestionIndex].correctAnswerIndex {
            isCorrect = true
        } else {
            isCorrect = false
        }
    }
    
    func nextQuestion() {
        currentQuestionIndex += 1
        selectedOption = nil
        isCorrect = false
        showFeedback = false
    }
    
    func getBackgroundColor(for index: Int) -> Color {
        if selectedOption == index {
            return isCorrect ? Color.green.opacity(0.8) : Color.red.opacity(0.8)
        }
        return Color(uiColor: .secondarySystemBackground).opacity(0.2)
    }
}

#Preview {
    NavigationStack {
        LinkedListQuizView()
            .preferredColorScheme(.dark)
    }
}
