//
//  LinkedListTopicOverviewView.swift
//  DSAK
//
//  Created by Atul on 13/02/26.
//
import SwiftUI

struct LinkedListTopicOverviewView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Steps
                        VStack(spacing: 16) {
                            OverviewStepRow(number: "1", title: "Learn the core idea", desc: "Understand Nodes, Data, and Pointers.")
                            OverviewStepRow(number: "2", title: "See it in action", desc: "Visualize how link list stores data by adding nodes to the chain.")
                            OverviewStepRow(number: "3", title: "Check your understanding", desc: "Verify your knowledge with a quick quiz of 3 questions.")
                            OverviewStepRow(
                                number: "4",
                                title: "Review your results",
                                desc: "Get instant feedback on your quiz and complete the module."
                            )
                        }
                        
                        // Time
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "clock")
                                Text("Estimated time: 15 minutes")
                            }
                            HStack(alignment: .top) {
                                Image(systemName: "target")
                                Text("Goal: Understand Dynamic Memory well enough to build logics for Coding.")
                            }
                        }
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .padding(.top, 10)
                        
                        // Start Button
                        NavigationLink {
                            LinkedListTheoryCardsView()
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
                    }
                    .padding(.top,35)
                }
            }
            .padding(.horizontal)
            .background(gradientAppBackground())
            .navigationTitle("Linked List")
            .navigationBarTitleDisplayMode(.inline)
            
            
        }
    }
}

#Preview {
    NavigationStack {
        LinkedListTopicOverviewView()
            .preferredColorScheme(.dark)
    }
}
