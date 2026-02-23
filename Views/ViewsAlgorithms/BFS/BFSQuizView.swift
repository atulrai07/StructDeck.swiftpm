//
//  BFSQuizView.swift
//  DSAK
//

import SwiftUI

struct BFSQuizView: View {
    @Environment(\.dismiss) var dismiss
    
    // State Logic
    @State private var currentQuestionIndex = 0
    @State private var selectedOption: Int? = nil
    @State private var isCorrect: Bool = false
    @State private var showFeedback: Bool = false
    @State private var wrongAnswers: Int = 0
    @State private var hasMadeWrongChoice: Bool = false
    
    // LOAD DATA
    let questions: [QuizQuestion] = QuizData.bfsQuestions
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Question \(currentQuestionIndex + 1) of \(questions.count)")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.gray)
                    .padding(.top,80)
                    .padding(.bottom, 20)
                    .accessibilityLabel("Question \(currentQuestionIndex + 1) of \(questions.count)")
                
                // Question Text
                VStack(alignment: .leading, spacing: 12) {
                    Text(questions[currentQuestionIndex].question)
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                .accessibilityAddTraits(.isHeader)
                
                Spacer()
                
                // Options Grid
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
                        .accessibilityLabel("\(questions[currentQuestionIndex].options[index]). Option \(index + 1) of \(questions[currentQuestionIndex].options.count)")
                        .accessibilityHint("Double tap to select this answer.")
                    }
                }
                .padding(.horizontal)
                
                // Feedback & Next Button
                VStack(spacing: 16) {
                    // Feedback Text
                    Text(selectedOption == nil ? " " : (isCorrect ? questions[currentQuestionIndex].explanation : "Not quite. Try again!"))
                        .font(.subheadline)
                        .foregroundStyle(isCorrect ? .green : .red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .frame(minHeight: 40, alignment: .top)
                    
                    // Navigation Buttons
                    if currentQuestionIndex < questions.count - 1 {
                        Button("Next Question") { nextQuestion() }
                            .buttonStyle(PrimaryButtonStyle())
                            .disabled(!isCorrect)
                            .opacity(isCorrect ? 1.0 : 0.5)
                            .accessibilityHint(isCorrect ? "Double tap to go to the next question." : "Answer correctly to proceed.")
                    } else {
                        NavigationLink(destination: CompletionView(correctCount: questions.count - wrongAnswers, totalCount: questions.count)) {
                            Text("See Results")
                                .font(.headline)
                                .bold()
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(16)
                        }
                        .disabled(!isCorrect)
                        .opacity(isCorrect ? 1.0 : 0.5)
                        .accessibilityLabel("See Results")
                        .accessibilityHint(isCorrect ? "Double tap to view your quiz score." : "Answer correctly to see your results.")
                    }
                }
                .padding(.bottom, 30)
                .padding(.horizontal)
            }
            .background(gradientAppBackground())
            .navigationTitle("BFS Quiz")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Logic Functions
    
    func handleOptionSelection(_ index: Int) {
        selectedOption = index
        showFeedback = true
        if index == questions[currentQuestionIndex].correctAnswerIndex {
            isCorrect = true
        } else {
            isCorrect = false
            if !hasMadeWrongChoice {
                wrongAnswers += 1
                hasMadeWrongChoice = true
            }
        }
    }
    
    func nextQuestion() {
        currentQuestionIndex += 1
        selectedOption = nil
        isCorrect = false
        showFeedback = false
        hasMadeWrongChoice = false
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
        BFSQuizView()
            .preferredColorScheme(.dark)
    }
}
