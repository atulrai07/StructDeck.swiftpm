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
                    
                    // "Start Learning" Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Start Learning")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(.white)
                            .padding(.horizontal)
                            .accessibilityAddTraits(.isHeader)
                        
                        // Data Structures Card
                        NavigationLink(destination: DataStructuresDashboardView()) {
                            CollectionCard(
                                title: "Data\nStructures",
                                books: [
                                    BookData(color: .pink, icon: "square.stack.3d.up.fill"),
                                    BookData(color: .green, icon: "tray.full.fill"),
                                    BookData(color: .cyan, icon: "link")
                                ]
                            )
                        }
                        .accessibilityLabel("Data Structures. Explore stacks, queues, linked lists, and trees.")
                        .accessibilityHint("Double tap to browse data structure modules.")
                        .padding(.horizontal)
                        
                        // Algorithms Card
                        NavigationLink(destination: AlgorithmsDashboardView()) {
                            CollectionCard(
                                title: "Algorithms",
                                books: [
                                    BookData(color: .orange, icon: "point.topleft.down.curvedto.point.bottomright.up"),
                                    BookData(color: .purple, icon: "arrow.up.and.down.and.arrow.left.and.right"),
                                    BookData(color: .teal, icon: "arrow.down.to.line")
                                ]
                            )
                        }
                        .accessibilityLabel("Algorithms. Explore Dijkstra, BFS, and DFS.")
                        .accessibilityHint("Double tap to browse algorithm modules.")
                        .padding(.horizontal)
                        
                    }
                    
                    // "Popular Topics" Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Featured Topics")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(.white)
                            .padding(.horizontal)
                            .accessibilityAddTraits(.isHeader)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                // Stack
                                NavigationLink(destination: DijkstraTopicOverviewView()) {
                                    PopularTopicCard(
                                        title: "Dijkstra",
                                        subtitle: "Shortest Path • 25 min",
                                        icon: "point.topleft.down.curvedto.point.bottomright.up",
                                        colors: [.red,.red ,.orange,.blue, .blue]
                                    )
                                }
                                .accessibilityLabel("Stack. Last In, First Out. 12 minutes.")
                                .accessibilityHint("Double tap to learn about stacks.")
                                
                                // tree
                                NavigationLink(destination: BinaryTreeTopicOverviewView()) {
                                    PopularTopicCard(
                                        title: "Binary Tree",
                                        subtitle: "Hierarchy • 20 min",
                                        icon: "leaf",
                                        colors: [.green,.mint, .blue,.yellow]
                                    )
                                }
                                .accessibilityLabel("Binary Tree. Hierarchical structure. 20 minutes.")
                                .accessibilityHint("Double tap to learn about binary trees.")
                                
                                // Linked List
                                NavigationLink(destination: BFSTopicOverviewView()) {
                                    PopularTopicCard(
                                        title: "BFS",
                                        subtitle: "Traverse • 20 min",
                                        icon: "arrow.up.and.down.and.arrow.left.and.right",
                                        colors: [.blue,.purple,.red]
                                    )
                                }
                                .accessibilityLabel("Linked List. Pointer-based structure. 15 minutes.")
                                .accessibilityHint("coDouble tap to learn about linked lists.")
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.bottom, 40)
            }
            .background(gradientAppBackground())
            //.navigationTitle("Home")
            //.navigationBarTitleDisplayMode(.large)
            // Accessibility Button
            .toolbar {
                if #available(iOS 26.0, *) {
                    ToolbarItem(placement: .subtitle) {
                        Text("Home")
                            .font(.largeTitle)
                            .bold()
                            .padding(.trailing, 200)
                    }
                    
    
                } else {
                    ToolbarItem(placement: .topBarLeading) {
                        Text("Home")
                            .font(.title)
                            .bold()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAccessibilitySheet = true
                    } label: {
                        Image(systemName: "accessibility.fill")
                    }
                    .accessibilityLabel("Accessibility Information")
                    .accessibilityHint("Double tap to view accessibility features and settings.")
                }
            }
            
            // sheet for accessibility
            .sheet(isPresented: $showAccessibilitySheet) {
                AccessibilityInfoView()
                    .presentationDetents([.fraction(0.75)])
                    .presentationDragIndicator(.visible)
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
