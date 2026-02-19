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
                            OverviewStepRow(
                                number: "2",
                                title: "See it in action",
                                desc: "Visualize how nodes connect hierarchically."
                            )
                            OverviewStepRow(
                                number: "3",
                                title: "Check your understanding",
                                desc: "Verify your knowledge with a quiz."
                            )
                        }
                        
                        // Time & Goal
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "clock")
                                Text("Estimated time: 20 minutes")
                            }
                            HStack(alignment: .top) {
                                Image(systemName: "target")
                                Text("Goal: Understand Hierarchical Data")
                            }
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
                    }
                    .padding(.top, 35)
                }
            }
            .padding(.horizontal)
            .background(Color.appBackground.ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.white)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // Info action placeholder
                    } label: {
                        Image(systemName: "info.circle")
                            .foregroundStyle(.white)
                    }
                }
                ToolbarItem(placement: .principal) { // .principal places it in the center
                    Text("Binary Tree")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
        }
    }
}

#Preview {
    BinaryTreeTopicOverviewView()
        .preferredColorScheme(.dark)
}
