//
//  BinaryTreeTopicOverviewView.swift
//  DSAK
//
//  Created by Atul on 18/02/26.
//

import SwiftUI

struct BinaryTreeTopicOverviewView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Steps
                        VStack(spacing: 16) {
                            
                            OverviewStepRow(
                                number: "1",
                                title: "Learn the core idea",
                                desc: "Understand Root, Leaves, and Parent-Child relationships."
                            )
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("Step 1. Learn the core idea. Understand Root, Leaves, and Parent-Child relationships.")
                            OverviewStepRow(
                                number: "2",
                                title: "See it in action",
                                desc: "Visualize how nodes connect hierarchically."
                            )
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("Step 2. See it in action. Visualize how nodes connect hierarchically.")
                            OverviewStepRow(
                                number: "3",
                                title: "Check your understanding",
                                desc: "Verify your knowledge with a quiz of 6 questions."
                            )
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("Step 3. Check your understanding. Verify your knowledge with a quiz of 6 questions.")
                        }
                        
                        // Time & Goal
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "clock")
                                Text("Estimated time: 20 minutes")
                            }
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("Estimated time: 20 minutes.")
                            HStack(alignment: .top) {
                                Image(systemName: "target")
                                Text("Goal: Understand hierarchical data structure well enough to build logic.")
                            }
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("Goal: Understand hierarchical data structure well enough to build logic.")
                        }
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .padding(.top, 10)
                        
                        Spacer(minLength: 50)
                        
                        // Start Button
                        NavigationLink {
                            BinaryTreeTheoryCardsView()
                        } label: {
                            Text("Start Learning")
                                .font(.headline)
                                .bold()
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(16)
                        }
                        .accessibilityLabel("Start Learning")
                        .accessibilityHint("Double tap to begin the Binary Tree theory cards.")
                    }
                    .padding(.top, 35)
                }
            }
            .padding(.horizontal)
            .background(gradientAppBackground())
            .navigationTitle("Binary Tree")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationStack {
        BinaryTreeTopicOverviewView()
            .preferredColorScheme(.dark)
    }
}
