//
//  QueueTopicOverviewView.swift
//  DSAK
//
//  Created by Atul on 13/02/26.
//
import SwiftUI

struct QueueTopicOverviewView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        Spacer()
                        // Steps
                        VStack(spacing: 16) {
                            OverviewStepRow(number: "1", title: "Learn the core idea", desc: "Short, swipeable cards that explain how Queue works.")
                            OverviewStepRow(number: "2",
                                            title: "See it in action", desc: "Interactive visualization where you enqueue & dequeue elements.")
                            OverviewStepRow(number: "3", title: "Check your understanding", desc: "3 quick questions to confirm you're ready.")
                        }
                        
                        // Time
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "clock")
                                    .accessibilityHidden(true)
                                Text("Estimated time: 12 minutes")
                            }
                            .accessibilityElement(children: .combine)
                            
                            HStack(alignment: .top) {
                                Image(systemName: "target")
                                    .accessibilityHidden(true)
                                Text("Goal: Understand Queue behavior well enough to build logics and solve problems.")
                            }
                            .accessibilityElement(children: .combine)
                        }
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .padding(.top, 10)
                        
                        Spacer(minLength: 50)
                        
                        // Start Button
                        NavigationLink {
                            QueueTheoryCardsView()
                        } label: {
                            Text("Start Learning")
                                .font(.headline)
                                .bold()
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    Color.blue
                                )
                                .cornerRadius(16)
                        }
                        .accessibilityHint("Opens the interactive theory cards for Queue.")
                    }
                    .padding(.top,15)
                }
            }
            .padding(.horizontal)
            .background(Color.appBackground.ignoresSafeArea())
            .navigationTitle("Queue")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationStack {
        QueueTopicOverviewView()
            .preferredColorScheme(.dark)
    }
}
