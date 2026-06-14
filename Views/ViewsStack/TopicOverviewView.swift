//
//  TopicOverviewView.swift
//  DSAK
//
//  Created by Atul on 30/12/25.
//

import SwiftUI

struct TopicOverviewView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                ScrollView(showsIndicators:false) {
                    VStack(alignment: .leading, spacing: 24) {
                        // Steps
                        VStack(spacing: 16) {
                            
                            OverviewStepRow(
                                number: "1",
                                title: "Learn the core idea",
                                desc: "Short, swipeable cards that explain how Stack works."
                            )
                            
                            OverviewStepRow(
                                number: "2",
                                title: "See it in action",
                                desc: "Interactive visualization where you push & pop elements."
                            )
                            
                            OverviewStepRow(
                                number: "3",
                                title: "Check your understanding",
                                desc: "3 quick questions to confirm you're ready."
                            )
                            
                            OverviewStepRow(
                                number: "4",
                                title: "Review your results",
                                desc: "Get instant feedback on your quiz and complete the module."
                            )
                        }
                        
                        // Time & Goal
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "clock")
                                    .accessibilityHidden(true)
                                Text("Estimated time: 10 minutes")
                            }
                            .accessibilityElement(children: .combine)
                            
                            HStack(alignment: .top) {
                                Image(systemName: "target")
                                    .accessibilityHidden(true)
                                Text("Goal: Understand Stack well enough to start coding")
                            }
                            .accessibilityElement(children: .combine)
                        }
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .padding(.top, 10)
                        
                        // Navigation Button
                        NavigationLink {
                            TheoryCardsView()
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
                        .accessibilityHint("Opens the interactive theory cards for Stack.")
                    }
                    .padding(.top, 15)
                }
            }
            .padding(.horizontal)
            .background(gradientAppBackground())
            .navigationTitle("Stack")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationStack {
        TopicOverviewView()
            .preferredColorScheme(.dark)
    }
}
