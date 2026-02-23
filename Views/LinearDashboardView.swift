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
    
    //The Data Source (defined in Models/ModuleItem.swift)
    let modules = ModuleItem.linearModules
    
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
                    NavigationLink(destination: item.destination()) {
                        // Topic cards is in Components
                        TopicCard(
                            title: item.title,
                            subtitle: item.subtitle,
                            cardBackground: item.cardBackground,
                            iconName: item.iconName,
                            time: item.time
                        )
                        .padding(.bottom,5)
                    }
                    .accessibilityLabel("\(item.title). \(item.subtitle). \(item.time).")
                    .accessibilityHint("Double tap to open the \(item.title) module.")
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
        .background(gradientAppBackground())
        .navigationTitle("Modules")
        .navigationBarTitleDisplayMode(.large)
        // Modifier
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search topics")
    }
}

#Preview {
    NavigationStack {
        LinearDashboardView()
            .preferredColorScheme(.dark)
    }
}
