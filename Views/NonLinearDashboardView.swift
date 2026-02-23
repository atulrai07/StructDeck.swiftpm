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
    
    // Data Source
    let modules = ModuleItem.nonLinearModules
    
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
                    NavigationLink(destination: item.destination()) {
                        TopicCard(
                            title: item.title,
                            subtitle: item.subtitle,
                            cardBackground: item.cardBackground,
                            iconName: item.iconName,
                            time: item.time
                        )
                    }
                    .accessibilityLabel("\(item.title). \(item.subtitle). \(item.time).")
                    .accessibilityHint("Double tap to open the \(item.title) module.")
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
        .background(gradientAppBackground())
        .navigationTitle("Modules")
        .navigationBarTitleDisplayMode(.large)
        //Search Bar
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search topics")
    }
}

#Preview {
    NavigationStack {
        NonLinearDashboardView()
            .preferredColorScheme(.dark)
    }
}
