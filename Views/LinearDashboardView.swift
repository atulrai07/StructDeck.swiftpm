//
//  LinearDashboardView.swift
//  DSAK
//
//  Created by Atul on 30/12/25.
//

import SwiftUI

struct LinearDashboardView: View {
    //Search State
    @State private var searchText = ""
    
    //Data Model (Holds the INFO for the card)
    struct ModuleItem: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
        let gradientColors: [Color]
        let iconName: String
        let time: String
        let destination: AnyView // Holds the view to open
    }
    
    //The Data Source
    let modules: [ModuleItem] = [
        ModuleItem(
            title: "Stack",
            subtitle: "Last In, First Out (LIFO)",
            gradientColors: [.blue, .red, .purple],
            iconName: "square.stack.3d.up.fill",
            time: "12 min",
            destination: AnyView(TopicOverviewView())
        ),
        ModuleItem(
            title: "Queue",
            subtitle: "First In, First Out (FIFO)",
            gradientColors: [.green, .blue, .yellow],
            iconName: "tray.full.fill",
            time: "12 min",
            destination: AnyView(QueueTopicOverviewView())
        ),
        ModuleItem(
            title: "Linked List",
            subtitle: "Nodes connected using pointers",
            gradientColors: [.blue, .cyan, .white],
            iconName: "point.3.filled.connected.trianglepath.dotted",
            time: "15 min",
            destination: AnyView(LinkedListTopicOverviewView())
        )
    ]
    
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
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                //The Loop: Generate Cards from Data
                ForEach(filteredModules) { item in
                    NavigationLink(destination: item.destination) {
                        // Topic cards is in Components
                        TopicCard(
                            title: item.title,
                            subtitle: item.subtitle,
                            gradientColors: item.gradientColors,
                            iconName: item.iconName,
                            time: item.time
                        )
                        .padding(.bottom,5)
                    }
                }
                
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
        .background(Color.appBackground.ignoresSafeArea())
        .navigationTitle("Modules")
        .navigationBarTitleDisplayMode(.large)
        // Modifier
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search topics...")
    }
}

#Preview {
    NavigationStack {
        LinearDashboardView()
            .preferredColorScheme(.dark)
    }
}
