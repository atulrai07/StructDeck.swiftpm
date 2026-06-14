//
//  StackQuizView.swift
//  DSAK
//
//  Created by Atul on 30/12/25.
//

import SwiftUI

struct StackQuizView: View {
    @Environment(\.dismiss) var dismiss
    
    // Logic State
    @State private var currentQuestionIndex = 0
    @State private var selectedOption: Int? = nil
    @State private var isCorrect: Bool = false
    @State private var showFeedback: Bool = false
    @State private var wrongAnswers: Int = 0
    @State private var hasMadeWrongChoice: Bool = false
    
    @State private var questions: [QuizQuestion] = QuizData.stackQuestions
    @State private var isLoading = AIQuizGenerator.shared.checkAvailability()
    @State private var isAIQuiz = false
    @State private var isShowingInfoSheet = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                gradientAppBackground()
                    .ignoresSafeArea()
                
                if isLoading {
                    VStack(spacing: 20) {
                        ProgressView()
                            .tint(.purple)
                            .scaleEffect(1.5)
                        
                        Text("Generating Custom AI Quiz...")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text("Structuring 5 fresh questions based on Stack concepts")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 24) {
                            // Question X of Y Header
                            Text("Question \(currentQuestionIndex + 1) of \(questions.count)")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(.gray)
                                .accessibilityLabel(isAIQuiz ? "AI Generated Question \(currentQuestionIndex + 1) out of \(questions.count)" : "Question \(currentQuestionIndex + 1) out of \(questions.count)")
                                .padding(.bottom, 20)
                                .padding(.top, 20)
                            
                            // Question Text
                            VStack(alignment: .leading, spacing: 12) {
                                FormattedTextView(
                                    text: questions[currentQuestionIndex].question,
                                    defaultFont: .title3,
                                    defaultColor: .white
                                )
                            }
                            .padding(.horizontal)
                            
                            // Options Grid
                            VStack(spacing: 16) {
                                ForEach(0..<questions[currentQuestionIndex].options.count, id: \.self) { index in
                                    Button(action: {
                                        handleOptionSelection(index)
                                    }) {
                                        HStack {
                                            Text(questions[currentQuestionIndex].options[index])
                                                .font(.headline)
                                                .multilineTextAlignment(.leading)
                                                .fixedSize(horizontal: false, vertical: true)
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
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                    }
                                    .disabled(showFeedback && isCorrect)
                                    .accessibilityLabel(
                                        showFeedback ?
                                        (selectedOption == index ? (isCorrect ? "\(questions[currentQuestionIndex].options[index]), Selected, Correct" : "\(questions[currentQuestionIndex].options[index]), Selected, Incorrect") : "\(questions[currentQuestionIndex].options[index])")
                                        : "\(questions[currentQuestionIndex].options[index])"
                                    )
                                    .accessibilityHint("Double tap to select this option")
                                }
                            }
                            .padding(.horizontal)
                            
                            // Feedback & Navigation Area
                            VStack(spacing: 16) {
                                // Feedback Text
                                if selectedOption == nil {
                                    Text(" ")
                                        .frame(minHeight: 40)
                                } else {
                                    let feedbackText = isCorrect ? questions[currentQuestionIndex].explanation : "Not quite, select another option"
                                    FormattedTextView(
                                        text: feedbackText,
                                        defaultFont: .subheadline,
                                        defaultColor: isCorrect ? .green : .red,
                                        alignment: .center
                                    )
                                    .padding(.horizontal)
                                    .frame(minHeight: 40, alignment: .top)
                                }
                                
                                // Navigation Buttons
                                if currentQuestionIndex < questions.count - 1 {
                                    Button("Next Question") {
                                        nextQuestion()
                                    }
                                    .buttonStyle(PrimaryButtonStyle())
                                    .disabled(!isCorrect)
                                    .opacity(isCorrect ? 1.0 : 0.5)
                                } else {
                                    // Link to Completion Screen
                                    NavigationLink(destination: CompletionView(
                                        moduleId: "stack",
                                        moduleName: "Stack",
                                        category: "dataStructure",
                                        correctCount: questions.count - wrongAnswers,
                                        totalCount: questions.count,
                                        isAIQuiz: isAIQuiz
                                    )) {
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
                                }
                            }
                            .padding(.bottom, 30)
                            .padding(.horizontal)
                        }
                    }
                    .navigationTitle("Stack Quiz")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
            .task {
                await loadAIQuiz()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if isAIQuiz {
                        Button {
                            isShowingInfoSheet = true
                        } label: {
                            Image(systemName: "info.circle")
                                .font(.body)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .sheet(isPresented: $isShowingInfoSheet) {
                AIQuizInfoSheet()
                    .presentationDetents([.medium])
            }
        }
    }
    
    private func loadAIQuiz() async {
        guard AIQuizGenerator.shared.checkAvailability() else {
            isLoading = false
            return
        }
        
        do {
            let aiQuestions = try await AIQuizGenerator.shared.generateQuiz(
                for: "Stack Data Structure",
                context: "LIFO principle, push/pop operations (pushing elements onto stack, popping elements off stack), stack overflow/underflow, call stack, and matching parentheses matching/balancing algorithms."
            )
            self.questions = aiQuestions
            self.isAIQuiz = true
        } catch {
            print("AI Quiz generation failed, falling back to static questions: \(error)")
            // Keep default static questions
        }
        isLoading = false
    }
    
    // Logic
    
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

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .bold()
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .cornerRadius(16)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

#Preview {
    NavigationStack {
        StackQuizView()
            .preferredColorScheme(.dark)
    }
}
