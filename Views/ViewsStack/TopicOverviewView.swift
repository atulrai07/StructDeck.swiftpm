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
                ScrollView {
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
                        }
                        
                        // Time & Goal
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "clock")
                                    .accessibilityHidden(true)
                                Text("Estimated time: 10 minutes")
                            }
                            .accessibilityElement(children: .combine) // Groups icon and text for VO
                            
                            HStack(alignment: .top) {
                                Image(systemName: "target")
                                    .accessibilityHidden(true)
                                Text("Goal: Understand Stack well enough to start coding")
                            }
                            .accessibilityElement(children: .combine) // Groups icon and text for VO
                        }
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .padding(.top, 10)
                        
                        Spacer(minLength: 50)
                        
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
                    .padding(.top,15)
                }
            }
            .padding(.horizontal)
            .background(Color.appBackground.ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    Button{
                        dismiss()
                    }label: {
                        Image(systemName: "chevron.left")
                    }
                    .accessibilityLabel("Back to Dashboard")
                }
                ToolbarItem(placement: .topBarTrailing){
                    Button{
                        
                    }label: {
                        Image(systemName: "info")
                    }
                    .accessibilityLabel("More Information")
                }
                ToolbarItem(placement: .title){
                    Text("Stack")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.white)
                        .accessibilityAddTraits(.isHeader)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        TopicOverviewView()
            .preferredColorScheme(.dark)
    }
}
