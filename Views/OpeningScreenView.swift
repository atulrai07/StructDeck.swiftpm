//
//  OpeningScreenView.swift
//  DSAK
//
//  Created by Atul on 07/02/26.
//

import SwiftUI

struct OpeningScreenView: View {
    @State private var recentModule: ModuleProgress? = nil
    @State private var overallCompletedCount = 0
    @State private var overallCompletionPercent = 0.0
    @State private var refreshTrigger = UUID()
    
    private var hasAnyProgress: Bool {
        overallCompletionPercent > 0 || overallCompletedCount > 0 || recentModule != nil
    }
    
    private func getDestination(for moduleId: String) -> AnyView? {
        if let match = ModuleItem.dataStructureModules.first(where: { $0.moduleId == moduleId }) {
            return match.destination()
        }
        if let match = ModuleItem.algorithmModules.first(where: { $0.moduleId == moduleId }) {
            return match.destination()
        }
        return nil
    }
    
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
                        Text("Quick Start Modules")
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
                    
                    if hasAnyProgress {
                        // Progress Summary & Continue Learning Row/Stack
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Your Progress")
                                .font(.title2)
                                .bold()
                                .foregroundStyle(.white)
                                .padding(.horizontal)
                                .accessibilityAddTraits(.isHeader)
                            
                            HStack(spacing: 16) {
                                // Overall Stats Card
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Overall Progress")
                                        .font(.caption)
                                        .bold()
                                        .foregroundStyle(.gray)
                                    
                                    HStack(spacing: 12) {
                                        ZStack {
                                            Circle()
                                                .stroke(Color.white.opacity(0.1), lineWidth: 6)
                                                .frame(width: 50, height: 50)
                                            Circle()
                                                .trim(from: 0, to: CGFloat(overallCompletionPercent / 100.0))
                                                .stroke(
                                                    LinearGradient(colors: [.blue, .purple], startPoint: .top, endPoint: .bottom),
                                                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                                                )
                                                .frame(width: 50, height: 50)
                                                .rotationEffect(.degrees(-90))
                                            
                                            Text("\(Int(overallCompletionPercent))%")
                                                .font(.caption)
                                                .bold()
                                                .foregroundStyle(.white)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("\(overallCompletedCount) of 7")
                                                .font(.subheadline)
                                                .bold()
                                                .foregroundStyle(.white)
                                            Text("Completed")
                                                .font(.caption)
                                                .foregroundStyle(.gray)
                                        }
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                )
                                
                                // Continue Learning Card
                                if let recent = recentModule, let dest = getDestination(for: recent.moduleId) {
                                    NavigationLink(destination: dest) {
                                        VStack(alignment: .leading, spacing: 12) {
                                            Text("Continue Learning")
                                                .font(.caption)
                                                .bold()
                                                .foregroundStyle(.orange)
                                            
                                            Text(recent.moduleName)
                                                .font(.headline)
                                                .bold()
                                                .foregroundStyle(.white)
                                                .lineLimit(1)
                                            
                                            HStack {
                                                Text("Resume Module")
                                                    .font(.caption)
                                                    .bold()
                                                    .foregroundStyle(.gray)
                                                Image(systemName: "arrow.right")
                                                    .font(.caption)
                                                    .foregroundStyle(.gray)
                                            }
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color.white.opacity(0.05))
                                        .cornerRadius(20)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .id(refreshTrigger)
                    }
                }
                .padding(.bottom, 40)
            }
            .background(gradientAppBackground())
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
            }
            .onAppear {
                let allProg = UserProgressManager.shared.getAllProgress()
                let recent = UserProgressManager.shared.getRecentModules(limit: 1)
                recentModule = recent.first
                
                let completed = allProg.filter { $0.theoryCompleted && $0.visualizerVisited && $0.quizCompleted }
                overallCompletedCount = completed.count
                
                let totalModules = 7.0
                let totalPercent = allProg.reduce(0.0) { $0 + $1.completionPercentage }
                overallCompletionPercent = totalPercent / totalModules
                
                refreshTrigger = UUID()
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
