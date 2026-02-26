//
//  ModuleItem.swift
//  DSAK
//
//  Created by Atul on 22/02/26.
//

import SwiftUI

struct ModuleItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let cardBackground: AnyShapeStyle
    let iconName: String
    let time: String
    let isLocked: Bool
    let destination: () -> AnyView
    
    init(title: String, subtitle: String, cardBackground: AnyShapeStyle, iconName: String, time: String, isLocked: Bool = false, destination: @escaping () -> AnyView) {
        self.title = title
        self.subtitle = subtitle
        self.cardBackground = cardBackground
        self.iconName = iconName
        self.time = time
        self.isLocked = isLocked
        self.destination = destination
    }
}

// Data Structures
extension ModuleItem {
    nonisolated(unsafe) static let dataStructureModules: [ModuleItem] = [
        ModuleItem(
            title: "Binary Tree",
            subtitle: "Hierarchical Tree Structure",
            cardBackground: AnyShapeStyle(.gray.opacity(0.3)),
            iconName: "leaf.fill",
            time: "20 min",
            destination: { AnyView(BinaryTreeTopicOverviewView()) }
        ),
        ModuleItem(
            title: "Linked List",
            subtitle: "Nodes connected using pointers",
            cardBackground: AnyShapeStyle(.gray.opacity(0.3)),
            iconName: "point.3.filled.connected.trianglepath.dotted",
            time: "15 min",
            destination: { AnyView(LinkedListTopicOverviewView()) }
        ),
        ModuleItem(
            title: "Queue",
            subtitle: "First In, First Out (FIFO)",
            cardBackground: AnyShapeStyle(.gray.opacity(0.3)),
            iconName: "tray.full.fill",
            time: "12 min",
            destination: { AnyView(QueueTopicOverviewView()) }
        ),
        ModuleItem(
            title: "Stack",
            subtitle: "Last In, First Out (LIFO)",
            cardBackground: AnyShapeStyle(.gray.opacity(0.3)),
            iconName: "square.stack.3d.up.fill",
            time: "12 min",
            destination: { AnyView(TopicOverviewView()) }
        ),
        ModuleItem(
            title: "Upcoming",
            subtitle: "More modules coming soon",
            cardBackground: AnyShapeStyle(.gray.opacity(0.15)),
            iconName: "lock.fill",
            time: "",
            isLocked: true,
            destination: { AnyView(EmptyView()) }
        )
    ]
}

// Algorithms
extension ModuleItem {
    nonisolated(unsafe) static let algorithmModules: [ModuleItem] = [
        ModuleItem(
            title: "Dijkstra",
            subtitle: "Shortest Path Algorithm",
            cardBackground: AnyShapeStyle(.gray.opacity(0.3)),
            iconName: "point.topleft.down.curvedto.point.bottomright.up",
            time: "25 min",
            destination: { AnyView(DijkstraTopicOverviewView()) }
        ),
        ModuleItem(
            title: "BFS",
            subtitle: "Level-order Traversal",
            cardBackground: AnyShapeStyle(.gray.opacity(0.3)),
            iconName: "arrow.up.and.down.and.arrow.left.and.right",
            time: "20 min",
            destination: { AnyView(BFSTopicOverviewView()) }
        ),
        ModuleItem(
            title: "DFS",
            subtitle: "Depth-first Traversal",
            cardBackground: AnyShapeStyle(.gray.opacity(0.3)),
            iconName: "arrow.down.to.line",
            time: "20 min",
            destination: { AnyView(DFSTopicOverviewView()) }
        ),
        ModuleItem(
            title: "Upcoming",
            subtitle: "More modules coming soon",
            cardBackground: AnyShapeStyle(.gray.opacity(0.15)),
            iconName: "lock.fill",
            time: "",
            isLocked: true,
            destination: { AnyView(EmptyView()) }
        )
    ]
}
