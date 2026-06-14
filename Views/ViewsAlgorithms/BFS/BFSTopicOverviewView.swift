//
//  BFSTopicOverviewView.swift
//  DSAK
//
//  Created by Atul on 08/02/26.

import SwiftUI

struct BFSTopicOverviewView: View {
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
                                desc: "Understand level-by-level exploration."
                            )
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("Step 1. Learn the core idea. Understand level-by-level exploration.")
                            
                            OverviewStepRow(
                                number: "2",
                                title: "See it in action",
                                desc: "Visualize how BFS traverses a graph."
                            )
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("Step 2. See it in action. Visualize how BFS traverses a graph.")
                            
                            OverviewStepRow(
                                number: "3",
                                title: "Check your understanding",
                                desc: "Verify your knowledge with a quiz."
                            )
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("Step 3. Check your understanding. Verify your knowledge with a quiz.")
                            
                            OverviewStepRow(
                                number: "4",
                                title: "Review your results",
                                desc: "Get instant feedback on your quiz and complete the module."
                            )
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("Step 4. Review your results. Get instant feedback on your quiz and complete the module.")
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
                                Text("Goal: Understand the BFS algorithm.")
                            }
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("Goal: Understand the BFS algorithm.")
                        }
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .padding(.top, 10)
                        
                        // Start Button
                        NavigationLink {
                            BFSTheoryCardsView()
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
                        .accessibilityHint("Double tap to begin the BFS theory cards.")
                    }
                    .padding(.top, 35)
                }
            }
            .padding(.horizontal)
            .background(gradientAppBackground())
            .navigationTitle("Breadth-First Search")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationStack {
        BFSTopicOverviewView()
            .preferredColorScheme(.dark)
    }
}
