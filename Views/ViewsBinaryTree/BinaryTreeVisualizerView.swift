//
//  BinaryTreeVisualizerView.swift
//  DSAK
//
//  Created by Atul on 18/02/26.
//

import SwiftUI

struct BinaryTreeVisualizerView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var rootNode: TreeNode? = nil
    @State private var codeSnippet: String = "BinaryTree tree = new BinaryTree();"
    @State private var updateTrigger = UUID()
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
//                HStack {
//                    Spacer()
//                    Text("Binary Tree Visualizer")
//                        .font(.headline)
//                        .foregroundStyle(.white)
//                    Spacer()
//                }
//                .padding(.top, 10)
//                .padding(.bottom, 20)
                
                // Canvas
                Spacer()
                ScrollView([.horizontal, .vertical], showsIndicators: false) {
                    ZStack {
                        if let root = rootNode {
                            // 1. Draw the Tree Nodes
                            TreeDiagramView(node: root)
                                .padding(50)
                                // 2. Draw the Lines as a Background Layer
                                .backgroundPreferenceValue(NodeBoundsKey.self) { preferences in
                                    GeometryReader { proxy in
                                        ZStack {
                                            // Iterate through all connections and draw lines
                                            ForEach(getAllLinks(node: root), id: \.childId) { link in
                                                if let pAnchor = preferences[link.parentId],
                                                   let cAnchor = preferences[link.childId] {
                                                    
                                                    Path { path in
                                                        let pPoint = proxy[pAnchor]
                                                        let cPoint = proxy[cAnchor]
                                                        path.move(to: pPoint)
                                                        path.addLine(to: cPoint)
                                                    }
                                                    .stroke(Color.gray, lineWidth: 2)
                                                }
                                            }
                                        }
                                    }
                                }
                        } else {
                            Text("Tree is Empty")
                                .foregroundStyle(.gray)
                                .frame(width: 300, height: 300)
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 400)
                    .id(updateTrigger)
                }
                .frame(height:450)
                .background(Color.appBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Color.gray.opacity(0.3), lineWidth: 2)
                )
                .padding(.horizontal)
                
                // Controls
                HStack(spacing: 30) {
                    // 1. RESET
                    Button(action: resetTree) {
                        VStack {
                            Image(systemName: "trash.circle")
                                .font(.system(size: 40))
                            Text("Reset")
                                .font(.caption2)
                                .bold()
                        }
                        .foregroundStyle(rootNode == nil ? .gray : .red)
                    }
                    .disabled(rootNode == nil)
                    
                    // 2. UNDO / DELETE LAST (New Button)
                    Button(action: deleteLastNode) {
                        VStack {
                            Image(systemName: "minus.circle.fill")
                                .font(.system(size: 44))
                            Text("Undo")
                                .font(.caption)
                                .bold()
                        }
                        .foregroundStyle(rootNode == nil ? .gray : .orange)
                    }
                    .disabled(rootNode == nil)
                    
                    // 3. INSERT
                    Button(action: insertNodeLevelOrder) {
                        VStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 44))
                            Text("Insert")
                                .font(.caption)
                                .bold()
                        }
                        .foregroundStyle(.green)
                    }
                }
                .padding(.vertical, 20)
                
                // Code Snippet
                VStack(alignment: .leading, spacing: 8) {
                    Text("JAVA CODE INSIGHT")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(.gray)
                        .padding(.horizontal)
                    
                    HStack {
                        Text(codeSnippet)
                            .font(.system(.body, design: .monospaced))
                            .foregroundStyle(.green)
                            .contentTransition(.numericText())
                        Spacer()
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground).opacity(0.1))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
                .frame(height:140)
            }
        }
        .navigationTitle("Binary Tree Visualizer")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .topBarTrailing){
                Button{
                    dismiss()
                }label: {
                    Text("Done")
                }
            }
        }
        
    }
    
    // MARK: - Logic
    
    func getAllLinks(node: TreeNode) -> [TreeLink] {
        var links: [TreeLink] = []
        if let left = node.left {
            links.append(TreeLink(parentId: node.id, childId: left.id))
            links.append(contentsOf: getAllLinks(node: left))
        }
        if let right = node.right {
            links.append(TreeLink(parentId: node.id, childId: right.id))
            links.append(contentsOf: getAllLinks(node: right))
        }
        return links
    }
    
    struct TreeLink {
        let parentId: UUID
        let childId: UUID
    }
    
    func insertNodeLevelOrder() {
        let newValue = Int.random(in: 10...99)
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            if rootNode == nil {
                rootNode = TreeNode(value: newValue)
                codeSnippet = "root = new Node(\(newValue));"
            } else {
                insertIntoFirstAvailableSpot(root: rootNode!, value: newValue)
                codeSnippet = "tree.insert(\(newValue));"
            }
            updateTrigger = UUID()
        }
    }
    
    func insertIntoFirstAvailableSpot(root: TreeNode, value: Int) {
        var queue: [TreeNode] = [root]
        while !queue.isEmpty {
            let current = queue.removeFirst()
            if current.left == nil {
                current.left = TreeNode(value: value)
                return
            } else { queue.append(current.left!) }
            
            if current.right == nil {
                current.right = TreeNode(value: value)
                return
            } else { queue.append(current.right!) }
        }
    }
    
    // NEW: Delete Last Node Logic
    func deleteLastNode() {
        guard let root = rootNode else { return }
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            // Case: Only root exists
            if root.left == nil && root.right == nil {
                rootNode = nil
                codeSnippet = "tree.clear();"
                updateTrigger = UUID()
                return
            }
            
            // Case: Find the last node (bottom-right-most) and its parent using BFS
            var queue: [TreeNode] = [root]
            var lastNode: TreeNode? = nil
            var parentMap: [UUID: TreeNode] = [:] // Map Child ID -> Parent Node
            
            while !queue.isEmpty {
                let current = queue.removeFirst()
                lastNode = current
                
                if let left = current.left {
                    parentMap[left.id] = current
                    queue.append(left)
                }
                if let right = current.right {
                    parentMap[right.id] = current
                    queue.append(right)
                }
            }
            
            // Disconnect lastNode from its parent
            if let target = lastNode, let parent = parentMap[target.id] {
                if parent.right?.id == target.id {
                    parent.right = nil
                } else if parent.left?.id == target.id {
                    parent.left = nil
                }
                codeSnippet = "tree.removeLast();"
            }
            
            updateTrigger = UUID()
        }
    }
    
    func resetTree() {
        withAnimation {
            rootNode = nil
            codeSnippet = "tree.clear();"
            updateTrigger = UUID()
        }
    }
}

// MARK: - Recursive Tree Diagram (Simplified)
struct TreeDiagramView: View {
    let node: TreeNode
    
    var body: some View {
        VStack(spacing: 30) {
            
            // 1. The Node (Anchored)
            NodeCircleView(value: node.value)
                .anchorPreference(key: NodeBoundsKey.self, value: .center) { anchor in
                    [node.id: anchor]
                }
                .zIndex(2)
            
            // 2. The Children
            if node.left != nil || node.right != nil {
                HStack(alignment: .top, spacing: 30) {
                    // Left Child
                    if let left = node.left {
                        TreeDiagramView(node: left)
                    } else if node.right != nil {
                        Color.clear.frame(width: 45, height: 45)
                    }
                    
                    // Right Child
                    if let right = node.right {
                        TreeDiagramView(node: right)
                    } else if node.left != nil {
                        Color.clear.frame(width: 45, height: 45)
                    }
                }
            }
        }
    }
}

// MARK: - Preference Key for Line Drawing
struct NodeBoundsKey: PreferenceKey {
    static let defaultValue: [UUID: Anchor<CGPoint>] = [:]
    
    static func reduce(
        value: inout [UUID: Anchor<CGPoint>],
        nextValue: () -> [UUID: Anchor<CGPoint>]
    ) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

// MARK: - Components
struct NodeCircleView: View {
    let value: Int
    var body: some View {
        Text("\(value)")
            .font(.headline)
            .bold()
            .foregroundStyle(.black)
            .frame(width: 45, height: 45)
            .background(Color.white)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.green, lineWidth: 3))
            .shadow(radius: 5)
            .transition(.scale)
    }
}

class TreeNode: Identifiable {
    let id = UUID()
    let value: Int
    var left: TreeNode?
    var right: TreeNode?
    init(value: Int) { self.value = value }
}

#Preview {
    NavigationStack {
        BinaryTreeVisualizerView()
            .preferredColorScheme(.dark)
    }
}
