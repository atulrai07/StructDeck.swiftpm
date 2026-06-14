//
//  AIExplainView.swift
//    Visulo
//
//  Created by Atul on 12/06/26.
//

import SwiftUI

struct AIExplainButton: View {
    let codeSnippet: String
    let dataStructure: String
    
    @State private var isShowingSheet = false
    
    var isSupported: Bool {
        AIQuizGenerator.shared.checkAvailability()
    }
    
    var body: some View {
        Group {
            if isSupported {
                Button {
                    isShowingSheet = true
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 11, weight: .bold))
                        Text("Explain")
                            .font(.system(size: 11, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(LinearGradient(
                                colors: [Color.purple, Color.indigo],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                    )
                    .shadow(color: Color.purple.opacity(0.3), radius: 3, x: 0, y: 1)
                }
                .accessibilityLabel("Explain this code snippet")
                .accessibilityHint("Uses Apple Intelligence to explain the current Java code snippet in simple terms.")
                .sheet(isPresented: $isShowingSheet) {
                    AIExplainSheetView(codeSnippet: codeSnippet, dataStructure: dataStructure)
                }
            }
        }
    }
}

struct AIExplainSheetView: View {
    let codeSnippet: String
    let dataStructure: String
    
    @Environment(\.dismiss) private var dismiss
    @State private var explanation: String = ""
    @State private var isLoading = true
    @State private var errorMessage: String? = nil
    @State private var streamTask: Task<Void, Never>? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Title / Header
                        HStack(spacing: 8) {
                            Image(systemName: "sparkles")
                                .font(.title2)
                                .foregroundStyle(LinearGradient(
                                    colors: [.purple, .indigo, .blue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                            Text("Visulo Tutor")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            Spacer()
                        }
                        .padding(.top, 10)
                        
                        // Code Panel
                        VStack(alignment: .leading, spacing: 8) {
                            Text("CODE INSIGHT")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(.gray)
                            
                            Text(codeSnippet)
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.green)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(uiColor: .secondarySystemBackground).opacity(0.15))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                        }
                        
                        Divider()
                            .background(Color.gray.opacity(0.3))
                        
                        // Explanation Panel
                        VStack(alignment: .leading, spacing: 10) {
                            Text("EXPLANATION")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(.gray)
                            
                            if isLoading && explanation.isEmpty {
                                ShimmerLoadingView()
                                    .padding(.top, 10)
                            } else if let errorMessage = errorMessage {
                                VStack(spacing: 16) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.orange)
                                    Text("Explanation Unavailable")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text(errorMessage)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                    
                                    Button(action: startStreaming) {
                                        HStack {
                                            Image(systemName: "arrow.clockwise")
                                            Text("Try Again")
                                        }
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                        .background(Color.blue)
                                        .cornerRadius(20)
                                    }
                                    .padding(.top, 10)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 30)
                            } else {
                                FormattedTextView(text: explanation)
                                    .transition(.opacity)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                startStreaming()
            }
            .onDisappear {
                streamTask?.cancel()
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func startStreaming() {
        isLoading = true
        errorMessage = nil
        explanation = ""
        streamTask?.cancel()
        
        streamTask = Task {
            do {
                let stream = AIExplainService.shared.streamExplanation(for: codeSnippet, dataStructure: dataStructure)
                isLoading = false
                for try await chunk in stream {
                    guard !Task.isCancelled else { break }
                    withAnimation(.easeOut(duration: 0.15)) {
                        explanation = chunk
                    }
                }
            } catch {
                guard !Task.isCancelled else { return }
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
}

struct ShimmerLoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            ForEach(0..<4) { index in
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.15))
                    .frame(height: 14)
                    .frame(maxWidth: index == 3 ? 180 : .infinity)
                    .overlay(
                        GeometryReader { geo in
                            let size = geo.size
                            LinearGradient(
                                colors: [
                                    Color.clear,
                                    Color.white.opacity(0.1),
                                    Color.clear
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .frame(width: size.width * 0.3)
                            .offset(x: isAnimating ? size.width * 1.3 : -size.width * 0.3)
                        }
                    )
                    .clipped()
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                isAnimating = true
            }
        }
    }
}
