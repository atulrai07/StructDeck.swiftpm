//
//  DijkstraTopicOverviewView.swift
//  DSAK
//
//  Created by Atul on 11/02/26.

import SwiftUI

struct DijkstraTopicOverviewView: View {
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
                                desc: "Understand Shortest Paths, Nodes, Edges, and Weights."
                            )
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("Step 1. Learn the core idea. Understand Shortest Paths, Nodes, Edges, and Weights.")
                            
                            OverviewStepRow(
                                number: "2",
                                title: "See it in action",
                                desc: "Visualize how the algorithm finds the shortest path."
                            )
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("Step 2. See it in action. Visualize how the algorithm finds the shortest path.")
                            
                            OverviewStepRow(
                                number: "3",
                                title: "Check your understanding",
                                desc: "Verify your knowledge with a quiz of 5 questions."
                            )
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("Step 3. Check your understanding. Verify your knowledge with a quiz of 5 questions.")
                            
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
                                Text("Estimated time: 25 minutes")
                            }
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("Estimated time: 25 minutes.")
                            HStack(alignment: .top) {
                                Image(systemName: "target")
                                Text("Goal: Understand the greedy algorithm for finding shortest paths in graphs.")
                            }
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("Goal: Understand the greedy algorithm for finding shortest paths in graphs.")
                        }
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .padding(.top, 10)
                        
                        Spacer(minLength: 50)
                        
                        // Start Button
                        NavigationLink {
                            DijkstraTheoryCardsView()
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
                        .accessibilityHint("Double tap to begin the Dijkstra theory cards.")
                    }
                    .padding(.top, 35)
                }
            }
            .padding(.horizontal)
            .background(gradientAppBackground())
            .navigationTitle("Dijkstra")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationStack {
        DijkstraTopicOverviewView()
            .preferredColorScheme(.dark)
    }
}
