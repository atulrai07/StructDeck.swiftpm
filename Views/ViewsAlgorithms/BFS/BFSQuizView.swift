//
//  BFSQuizView.swift
//  DSAK
//
//Created by Atul on 07/02/26.

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
    @State private var questions: [QuizQuestion] = QuizData.bfsQuestions
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
                        
                        Text("Structuring 5 fresh questions based on BFS concepts")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 24) {
                            // Header
                            Text("Question \(currentQuestionIndex + 1) of \(questions.count)")
                                .font(.title)
                                .bold()
                                .foregroundStyle(.gray)
                                .padding(.top, 20)
                                .accessibilityLabel(isAIQuiz ? "AI Generated Question \(currentQuestionIndex + 1) out of \(questions.count)" : "Question \(currentQuestionIndex + 1) out of \(questions.count)")
                            
                            // Question Text
                            VStack(alignment: .leading, spacing: 12) {
                                FormattedTextView(
                                    text: questions[currentQuestionIndex].question,
                                    defaultFont: .title3,
                                    defaultColor: .white
                                )
                            }
                            .padding(.horizontal)
                            .accessibilityAddTraits(.isHeader)
                            
                            // Options Grid
                            VStack(spacing: 16) {
                                ForEach(0..<questions[currentQuestionIndex].options.count, id: \.self) { index in
                                    Button(action: { handleOptionSelection(index) }) {
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
                                if selectedOption == nil {
                                    Text(" ")
                                        .frame(minHeight: 40)
                                } else {
                                    let feedbackText = isCorrect ? questions[currentQuestionIndex].explanation : "Not quite. Try again!"
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
                                    Button("Next Question") { nextQuestion() }
                                        .buttonStyle(PrimaryButtonStyle())
                                        .disabled(!isCorrect)
                                        .opacity(isCorrect ? 1.0 : 0.5)
                                        .accessibilityHint(isCorrect ? "Double tap to go to the next question." : "Answer correctly to proceed.")
                                } else {
                                    NavigationLink(destination: CompletionView(
                                        moduleId: "bfs",
                                        moduleName: "BFS",
                                        category: "algorithm",
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
                                    .accessibilityLabel("See Results")
                                    .accessibilityHint(isCorrect ? "Double tap to view your quiz score." : "Answer correctly to see your results.")
                                }
                            }
                            .padding(.bottom, 30)
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .task {
                await loadAIQuiz()
            }
            .navigationTitle("BFS Quiz")
            .navigationBarTitleDisplayMode(.inline)
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
    
    private func loadAIQuiz() async {
        guard AIQuizGenerator.shared.checkAvailability() else {
            isLoading = false
            return
        }
        
        do {
            let aiQuestions = try await AIQuizGenerator.shared.generateQuiz(
                for: "Breadth-First Search (BFS)",
                context: "Level-order traversal, queue-based queue processing, visited set to prevent cycles, shortest path in unweighted graphs, adjacent neighbors, and time/space complexity (O(V+E))."
            )
            self.questions = aiQuestions
            self.isAIQuiz = true
        } catch {
            print("AI Quiz generation failed, falling back to static questions: \(error)")
        }
        isLoading = false
    }
}

#Preview {
    NavigationStack {
        BFSQuizView()
            .preferredColorScheme(.dark)
    }
}
