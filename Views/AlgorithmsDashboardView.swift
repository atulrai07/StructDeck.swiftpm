//
//  AlgorithmsDashboardView.swift
//  DSAK
//

import SwiftUI

struct AlgorithmsDashboardView: View {
    //Search State
    @State private var searchText = ""
    
    //The Data Source 
    let modules = ModuleItem.algorithmModules
    
    @State private var refreshTrigger = UUID()
    
    //Logic for search
    var filteredModules: [ModuleItem] {
        if searchText.isEmpty {
            return modules
        } else {
            return modules.filter { item in
                item.title.localizedCaseInsensitiveContains(searchText) ||
                item.subtitle.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    private func getProgress(for moduleId: String) -> (theory: Bool, visualizer: Bool, quiz: Bool) {
        if let progress = UserProgressManager.shared.getModuleProgress(moduleId: moduleId) {
            return (progress.theoryCompleted, progress.visualizerVisited, progress.quizCompleted)
        }
        return (false, false, false)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                //The Loop: Generate Cards from Data
                ForEach(filteredModules) { item in
                    let prog = getProgress(for: item.moduleId)
                    if item.isLocked {
                        TopicCard(
                            title: item.title,
                            subtitle: item.subtitle,
                            cardBackground: item.cardBackground,
                            iconName: item.iconName,
                            time: item.time,
                            theoryCompleted: prog.theory,
                            visualizerVisited: prog.visualizer,
                            quizCompleted: prog.quiz
                        )
                        .opacity(0.6)
                        .padding(.bottom, 5)
                        .accessibilityLabel("\(item.title). \(item.subtitle).")
                    } else {
                        NavigationLink(destination: item.destination()) {
                            // Topic cards is in Components
                            TopicCard(
                                title: item.title,
                                subtitle: item.subtitle,
                                cardBackground: item.cardBackground,
                                iconName: item.iconName,
                                time: item.time,
                                theoryCompleted: prog.theory,
                                visualizerVisited: prog.visualizer,
                                quizCompleted: prog.quiz
                            )
                            .padding(.bottom,5)
                        }
                        .accessibilityLabel("\(item.title). \(item.subtitle). \(item.time).")
                        .accessibilityHint("Double tap to open the \(item.title) module.")
                    }
                }
                .id(refreshTrigger)
                
                //Show message if no results found
                if filteredModules.isEmpty {
                    if #available(iOS 17.0, *) {
                        ContentUnavailableView.search(text: searchText)
                    } else {
                        EmptyStateView(text: searchText)
                    }
                }

            }
            .padding()
        }
        .background(gradientAppBackground())
        .navigationTitle("Algorithms")
        .navigationBarTitleDisplayMode(.large)
        // Modifier
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search topics")
        .onAppear {
            refreshTrigger = UUID()
        }
    }
}

#Preview {
    NavigationStack {
        AlgorithmsDashboardView()
            .preferredColorScheme(.dark)
    }
}
