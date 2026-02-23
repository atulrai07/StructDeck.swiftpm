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
    let destination: () -> AnyView
}

// MARK: - Linear Data Structures
extension ModuleItem {
    nonisolated(unsafe) static let linearModules: [ModuleItem] = [
        ModuleItem(
            title: "Stack",
            subtitle: "Last In, First Out (LIFO)",
            cardBackground: AnyShapeStyle(.gray.opacity(0.3)),
            iconName: "square.stack.3d.up.fill",
            time: "12 min",
            destination: { AnyView(TopicOverviewView()) }
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
            title: "Linked List",
            subtitle: "Nodes connected using pointers",
            cardBackground: AnyShapeStyle(.gray.opacity(0.3)),
            iconName: "point.3.filled.connected.trianglepath.dotted",
            time: "15 min",
            destination: { AnyView(LinkedListTopicOverviewView()) }
        )
    ]
}

// MARK: - Non-Linear Data Structures
extension ModuleItem {
    nonisolated(unsafe) static let nonLinearModules: [ModuleItem] = [
        ModuleItem(
            title: "Binary Tree",
            subtitle: "Hierarchical Tree Structure",
            cardBackground: AnyShapeStyle(.gray.opacity(0.3)),
            iconName: "leaf.fill",
            time: "20 min",
            destination: { AnyView(BinaryTreeTopicOverviewView()) }
        )
    ]
}
