//
//  NonLinearDashboardView.swift
//  DSAK
//
//  Created by Atul on 17/02/26.
//

import SwiftUI

struct NonLinearDashboardView: View {
    //Search State
    @State private var searchText = ""
    
    //Data Model (Identical structure to LinearDashboardView)
    struct ModuleItem: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
        let gradientColors: [Color]
        let iconName: String
        let time: String
        let destination: AnyView // Holds the destination view
    }
    
    //The Data Source
    let modules: [ModuleItem] = [
        ModuleItem(
            title: "Binary Tree",
            subtitle: "Hierarchical Tree Structure",
            gradientColors: [.green, .mint, .blue],
            iconName: "leaf.fill",
            time: "20 min",
            destination: AnyView(BinaryTreeTopicOverviewView())
        )
    ]
    
    //Filter Logic
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
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                //Dynamic Loop
                ForEach(filteredModules) { item in
                    NavigationLink(destination: item.destination) {
                        TopicCard(
                            title: item.title,
                            subtitle: item.subtitle,
                            gradientColors: item.gradientColors,
                            iconName: item.iconName,
                            time: item.time
                        )
                    }
                }
                
                //Empty State (Optional)
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
        .background(Color.appBackground.ignoresSafeArea())
        .navigationTitle("Modules")
        .navigationBarTitleDisplayMode(.large)
        //Search Bar
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search topics...")
    }
}

#Preview {
    NavigationStack {
        NonLinearDashboardView()
            .preferredColorScheme(.dark)
    }
}
