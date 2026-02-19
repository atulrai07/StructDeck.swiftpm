//
//  OpeningScreenView.swift
//  DSAK
//
//  Created by Atul on 17/02/26.
//

import SwiftUI

struct OpeningScreenView: View {
    // State to control the presentation of the Accessibility Sheet
    @State private var showAccessibilitySheet = false
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 30) {
                    
                    // 2. "Start Learning" Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Start Learning")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(.white)
                            .padding(.horizontal)
                        
                        // Linear Structures Card
                        NavigationLink(destination: LinearDashboardView()) {
                            CollectionCard(
                                title: "Linear\nStructures",
                                books: [
                                    BookData(color: .pink, icon: "square.stack.3d.up.fill"),
                                    BookData(color: .green, icon: "tray.full.fill"),
                                    BookData(color: .cyan, icon: "link")
                                ]
                            )
                        }
                        .padding(.horizontal)
                        
                        // Non-Linear Structures Card
                        NavigationLink(destination: NonLinearDashboardView()) {
                            CollectionCard(
                                title: "Non-Linear\nStructures",
                                books: [
                                    BookData(color: .green, icon: "leaf.fill"),
                                    BookData(color: .orange, icon: "point.3.filled.connected.trianglepath.dotted"),
                                    BookData(color: .teal, icon: "network")
                                ]
                            )
                        }
                        .padding(.horizontal)
                    }
                    
                    // 3. "Popular Topics" Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Popular Topics")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(.white)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                // Stack
                                NavigationLink(destination: TopicOverviewView()) {
                                    PopularTopicCard(
                                        title: "Stack",
                                        subtitle: "LIFO • 12 min",
                                        icon: "square.stack.3d.up.fill",
                                        colors: [.blue,.red, .purple]
                                    )
                                }
                                
                                // tree
                                NavigationLink(destination: BinaryTreeTopicOverviewView()) {
                                    PopularTopicCard(
                                        title: "Binary Tree",
                                        subtitle: "Hierarchy • 20 min",
                                        icon: "leaf",
                                        colors: [.green,.mint, .blue,.yellow]
                                    )
                                }
                                
                                // Linked List
                                NavigationLink(destination: LinkedListTopicOverviewView()) {
                                    PopularTopicCard(
                                        title: "Linked List",
                                        subtitle: "Pointers • 15 min",
                                        icon: "link",
                                        colors: [.cyan, .blue,.white]
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.bottom, 40)
            }
            .background(Color.appBackground.ignoresSafeArea())
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
            // Accessibility Button
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAccessibilitySheet = true
                    } label: {
                        Image(systemName: "accessibility.fill")
                    }
                    .accessibilityLabel("Accessibility Information")
                }
            }
            // Present the Accessibility Sheet
            .sheet(isPresented: $showAccessibilitySheet) {
                AccessibilityInfoView()
                    .presentationDetents([.large])
            }
        }
    }
}

#Preview {
    NavigationStack {
        OpeningScreenView()
            .preferredColorScheme(.dark)
    }
}
