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
                            OverviewStepRow(number: "2", title: "See it in action", desc: "Visualize adding nodes to the chain.")
                            OverviewStepRow(number: "3", title: "Check your understanding", desc: "Verify your knowledge with a quiz.")
                        }
                        
                        // Time
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "clock")
                                Text("Estimated time: 15 minutes")
                            }
                            HStack(alignment: .top) {
                                Image(systemName: "target")
                                Text("Goal: Understand Dynamic Memory")
                            }
                        }
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .padding(.top, 10)
                        
                        Spacer(minLength: 50)
                        
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
            .background(Color.appBackground.ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
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
                    Text("Linked List")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
        }
    }
}

#Preview {
    LinkedListTopicOverviewView()
}
