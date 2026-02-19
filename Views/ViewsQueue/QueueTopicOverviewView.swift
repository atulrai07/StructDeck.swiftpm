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
                                Text("Estimated time: 12 minutes")
                            }
                            HStack(alignment: .top) {
                                Image(systemName: "target")
                                Text("Goal: Understand Queue behavior")
                            }
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
                    }
                    .padding(.top,15)
                }
            }
            .padding(.horizontal)
            .background(Color.appBackground.ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
            //header back button
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    Button{
                        dismiss()
                    }label: {
                        Image(systemName: "chevron.left")
                    }
                }
                ToolbarItem(placement: .topBarTrailing){
                    Button{
                        
                    }label: {
                        Image(systemName: "info")
                    }
                }
                ToolbarItem(placement: .title){
                    Text("Queue")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
        }
    }
}

#Preview {
    QueueTopicOverviewView()
}
