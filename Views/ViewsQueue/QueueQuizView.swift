//
//  QueueQuizView.swift
//  DSAK
//
//  Created by Atul on 13/02/26.
//
import SwiftUI

struct QueueQuizView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var currentQuestionIndex = 0
    @State private var selectedOption: Int? = nil
    @State private var isCorrect: Bool = false
    @State private var showFeedback: Bool = false
    @State private var wrongAnswers: Int = 0
    @State private var hasMadeWrongChoice: Bool = false
    
    @State private var questions: [QuizQuestion] = QuizData.queueQuestions
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
                        
                        Text("Structuring 5 fresh questions based on Queue concepts")
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
                                .font(.title)
                                .bold()
                                .foregroundStyle(.gray)
                                .padding(.top, 20)
                                .accessibilityLabel(isAIQuiz ? "AI Generated Question \(currentQuestionIndex + 1) out of \(questions.count)" : "Question \(currentQuestionIndex + 1) out of \(questions.count)")
                            
                            // Question
                            VStack(alignment: .leading, spacing: 12) {
                                Text(questions[currentQuestionIndex].question)
                                    .font(.title2)
                                    .bold()
                                    .foregroundStyle(.white)
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .accessibilityAddTraits(.isHeader)
                            }
                            .padding(.horizontal)
                            
                            // Options
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
                                    .accessibilityLabel(
                                        showFeedback ?
                                        (selectedOption == index ? (isCorrect ? "\(questions[currentQuestionIndex].options[index]), Selected, Correct" : "\(questions[currentQuestionIndex].options[index]), Selected, Incorrect") : "\(questions[currentQuestionIndex].options[index])")
                                        : "\(questions[currentQuestionIndex].options[index])"
                                    )
                                    .accessibilityHint("Double tap to select this option")
                                }
                            }
                            .padding(.horizontal)
                            
                            // Feedback
                            VStack(spacing: 16) {
                                // Feedback Text
                                Text(selectedOption == nil ? " " : (isCorrect ? questions[currentQuestionIndex].explanation : "Not quite. Try again!"))
                                    .font(.subheadline)
                                    .foregroundStyle(isCorrect ? .green : .red)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(minHeight: 40, alignment: .top)
                                
                                // Navigation Buttons
                                if currentQuestionIndex < questions.count - 1 {
                                    Button("Next Question") { nextQuestion() }
                                        .buttonStyle(PrimaryButtonStyle())
                                        .disabled(!isCorrect)
                                        .opacity(isCorrect ? 1.0 : 0.5)
                                } else {
                                    NavigationLink(destination: CompletionView(
                                        moduleId: "queue",
                                        moduleName: "Queue",
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
                    .navigationTitle("Queue Quiz")
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
    
    // Logic
    func handleOptionSelection(_ index: Int) {
        selectedOption = index
        showFeedback = true
        if index == questions[currentQuestionIndex].correctAnswerIndex {
            isCorrect = true
            //  Success Haptic
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        } else {
            isCorrect = false
            if !hasMadeWrongChoice {
                wrongAnswers += 1
                hasMadeWrongChoice = true
            }
            //  Error Haptic
            UINotificationFeedbackGenerator().notificationOccurred(.error)
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
                for: "Queue Data Structure",
                context: "FIFO principle, enqueue/dequeue operations, double-ended queues (Deque), priority queues, circular queues, queue underflow/overflow, and real-world queue processing applications."
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
        QueueQuizView()
            .preferredColorScheme(.dark)
    }
}
