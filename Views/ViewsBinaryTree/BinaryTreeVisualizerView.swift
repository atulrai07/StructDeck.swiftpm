//
//  BinaryTreeVisualizerView.swift
//  DSAK
//
//  Created by Atul on 18/02/26.
//

import SwiftUI

// Mode Enum
enum VisualizerMode: String, CaseIterable {
    case binaryTree = "Binary Tree"
    case bst = "BST"
    case inOrder = "In-Order"
    case preOrder = "Pre-Order"
    case postOrder = "Post-Order"
    
    var icon: String {
        switch self {
        case .binaryTree: return "tree"
        case .bst: return "arrow.trianglehead.branch"
        case .inOrder: return "arrow.left.arrow.right"
        case .preOrder: return "arrow.down.to.line"
        case .postOrder: return "arrow.up.to.line"
        }
    }
    
    var navigationTitle: String {
        switch self {
        case .binaryTree: return "Binary Tree Visualizer"
        case .bst: return "BST Visualizer"
        case .inOrder: return "In-Order Traversal"
        case .preOrder: return "Pre-Order Traversal"
        case .postOrder: return "Post-Order Traversal"
        }
    }
    
    var isTraversal: Bool {
        switch self {
        case .inOrder, .preOrder, .postOrder: return true
        default: return false
        }
    }
}

struct BinaryTreeVisualizerView: View {
    @Environment(\.dismiss) var dismiss
    
    // Tree State
    @State private var rootNode: TreeNode? = nil
    @State private var codeHistory: [String] = ["BinaryTree tree = new BinaryTree();"]
    @State private var updateTrigger = UUID()
    
    // Mode & Animation State
    @State private var currentMode: VisualizerMode = .binaryTree
    @State private var highlightedNodeID: UUID? = nil
    @State private var visitedNodeIDs: Set<UUID> = []
    @State private var outputArray: [Int] = []
    @State private var isAnimating: Bool = false
    @State private var isPaused: Bool = false
    
    var body: some View {
        ZStack {
            Color.VisualizerBackgroundColor.ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    treeCanvas
                    
                    if currentMode.isTraversal && !outputArray.isEmpty {
                        outputArrayView
                    }
                    
                    controlButtons
                    
                    ExpandableCodeInsightView(codeHistory: codeHistory, dataStructure: "Binary Tree")
                }
                .padding(.vertical)
            }
        }
        .navigationTitle(currentMode.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                modeMenu
            }
        }
        .onAppear {
            UserProgressManager.shared.markVisualizerVisited(moduleId: "binaryTree", moduleName: "Binary Tree", category: "dataStructure")
        }
    }
    
    
    @ViewBuilder
    private var treeCanvas: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: false) {
            ZStack {
                if let root = rootNode {
                    TreeDiagramView(
                        node: root,
                        highlightedNodeID: highlightedNodeID,
                        visitedNodeIDs: visitedNodeIDs
                    )
                    .padding(50)
                    .backgroundPreferenceValue(NodeBoundsKey.self) { preferences in
                        GeometryReader { proxy in
                            ZStack {
                                ForEach(getAllLinks(node: root), id: \.childId) { link in
                                    if let pAnchor = preferences[link.parentId],
                                       let cAnchor = preferences[link.childId] {
                                        Path { path in
                                            let pPoint = proxy[pAnchor]
                                            let cPoint = proxy[cAnchor]
                                            path.move(to: pPoint)
                                            path.addLine(to: cPoint)
                                        }
                                        .stroke(
                                            edgeColor(parentId: link.parentId, childId: link.childId),
                                            lineWidth: 2
                                        )
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
        .frame(height: currentMode.isTraversal ? 350 : 450)
        .background(.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.gray.opacity(0.3), lineWidth: 2)
        )
        .padding(.horizontal)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(treeAccessibilityLabel)
        .accessibilityHint("Use the Insert, Undo, and Reset buttons below to modify the tree.")
    }
    
    private var treeAccessibilityLabel: String {
        if let root = rootNode {
            return "Binary tree with \(countNodes(rootNode)) nodes. Root value is \(root.value)."
        }
        return "Tree is empty."
    }
    
    @ViewBuilder
    private var outputArrayView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("OUTPUT")
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundStyle(.gray)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(Array(outputArray.enumerated()), id: \.offset) { _, value in
                        Text("\(value)")
                            .font(.system(.callout, design: .monospaced))
                            .bold()
                            .foregroundStyle(.black)
                            .frame(width: 40, height: 40)
                            .background(Color.green)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.top, 10)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: outputArray.count)
    }
    
    @ViewBuilder
    private var controlButtons: some View {
        HStack(spacing: 30) {
            resetButton
            
            if currentMode.isTraversal {
                pauseButton
                traverseButton
            } else {
                undoButton
                insertButton
            }
        }
        .padding(.vertical, 20)
    }
    
    private var resetButton: some View {
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
        .disabled(rootNode == nil || isAnimating)
        .accessibilityLabel("Reset")
        .accessibilityHint("Double tap to clear the entire tree.")
    }
    
    private var undoButton: some View {
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
        .disabled(rootNode == nil || isAnimating)
        .accessibilityLabel("Undo")
        .accessibilityHint("Double tap to remove the last inserted node.")
    }
    
    private var pauseButton: some View {
        Button {
            isPaused.toggle()
        } label: {
            VStack {
                Image(systemName: isPaused ? "play.circle.fill" : "pause.circle.fill")
                    .font(.system(size: 44))
                Text(isPaused ? "Resume" : "Pause")
                    .font(.caption)
                    .bold()
            }
            .foregroundStyle(!isAnimating ? .gray : .orange)
        }
        .disabled(!isAnimating)
        .accessibilityLabel(isPaused ? "Resume Traversal" : "Pause Traversal")
        .accessibilityHint(isPaused ? "Double tap to resume the traversal." : "Double tap to pause the traversal.")
    }
    
    private var traverseButton: some View {
        Button(action: runTraversal) {
            VStack {
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 44))
                Text("Traverse")
                    .font(.caption)
                    .bold()
            }
            .foregroundStyle(rootNode == nil || isAnimating ? .gray : .cyan)
        }
        .disabled(rootNode == nil || isAnimating)
        .accessibilityLabel("Run \(currentMode.rawValue) Traversal")
        .accessibilityHint("Double tap to animate the traversal on the current tree.")
    }
    
    private var insertButton: some View {
        Button {
            if currentMode == .bst {
                insertBST()
            } else {
                insertNodeLevelOrder()
            }
        } label: {
            VStack {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 44))
                Text("Insert")
                    .font(.caption)
                    .bold()
            }
            .foregroundStyle(isAnimating ? .gray : .green)
        }
        .disabled(isAnimating)
        .accessibilityLabel("Insert")
        .accessibilityHint("Double tap to add a new node to the tree.")
    }
    

    
    // MARK: - Dropdown Menu
    @ViewBuilder
    private var modeMenu: some View {
        Menu {
            ForEach(VisualizerMode.allCases, id: \.self) { mode in
                Button {
                    switchMode(to: mode)
                } label: {
                    Label(mode.rawValue, systemImage: mode.icon)
                }
            }
        } label: {
            Image(systemName: "line.3.horizontal.decrease.circle")
                .font(.title3)
                .foregroundStyle(.white)
        }
        .disabled(isAnimating)
    }
    
    // MARK: - Mode Switching
    func switchMode(to mode: VisualizerMode) {
        guard !isAnimating else { return }
        withAnimation(.easeInOut(duration: 0.3)) {
            currentMode = mode
            highlightedNodeID = nil
            visitedNodeIDs.removeAll()
            outputArray.removeAll()
            
            switch mode {
            case .binaryTree:
                codeHistory = [rootNode == nil
                    ? "BinaryTree tree = new BinaryTree();"
                    : "// Level-order insertion mode"]
            case .bst:
                codeHistory = [rootNode == nil
                    ? "BST bst = new BST();"
                    : "// BST insertion mode"]
            case .inOrder:
                codeHistory = ["inOrder(node.left); visit(node); inOrder(node.right);"]
            case .preOrder:
                codeHistory = ["visit(node); preOrder(node.left); preOrder(node.right);"]
            case .postOrder:
                codeHistory = ["postOrder(node.left); postOrder(node.right); visit(node);"]
            }
        }
    }
    
    // MARK: - Edge Color
    func edgeColor(parentId: UUID, childId: UUID) -> Color {
        if visitedNodeIDs.contains(parentId) && visitedNodeIDs.contains(childId) {
            return .green.opacity(0.7)
        }
        if highlightedNodeID == childId || highlightedNodeID == parentId {
            return .yellow.opacity(0.7)
        }
        return .gray
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
    
    // MARK: - Level-Order Insert (Binary Tree mode)
    func insertNodeLevelOrder() {
        let newValue = Int.random(in: 10...99)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            if rootNode == nil {
                rootNode = TreeNode(value: newValue)
                codeHistory.append("root = new Node(\(newValue));")
            } else {
                insertIntoFirstAvailableSpot(root: rootNode!, value: newValue)
                codeHistory.append("tree.insert(\(newValue));")
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
    
    // BST Insert
    func insertBST() {
        let newValue = Int.random(in: 10...99)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        guard !isAnimating else { return }
        
        if rootNode == nil {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                rootNode = TreeNode(value: newValue)
                codeHistory.append("root = new Node(\(newValue));")
                updateTrigger = UUID()
            }
            return
        }
        
        var path: [TreeNode] = []
        var current: TreeNode? = rootNode
        var goLeft: [Bool] = []
        
        while let node = current {
            path.append(node)
            if newValue < node.value {
                goLeft.append(true)
                if node.left == nil { break }
                current = node.left
            } else {
                goLeft.append(false)
                if node.right == nil { break }
                current = node.right
            }
        }
        
        // Animate traversal then insert
        isAnimating = true
        Task { @MainActor in
            codeHistory.append("// Inserting \(newValue) into BST...")
            
            for (i, node) in path.enumerated() {
                withAnimation(.easeInOut(duration: 0.3)) {
                    highlightedNodeID = node.id
                    if i < goLeft.count {
                        let direction = goLeft[i] ? "left" : "right"
                        codeHistory.append("\(newValue) \(goLeft[i] ? "<" : ">=") \(node.value) → go \(direction)")
                    }
                }
                try? await Task.sleep(nanoseconds: 600_000_000)
            }
            
            // Insert the new node
            if let lastNode = path.last, let lastDirection = goLeft.last {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    let newNode = TreeNode(value: newValue)
                    if lastDirection {
                        lastNode.left = newNode
                    } else {
                        lastNode.right = newNode
                    }
                    codeHistory.append("node.\(lastDirection ? "left" : "right") = new Node(\(newValue));")
                    updateTrigger = UUID()
                }
            }
            
            try? await Task.sleep(nanoseconds: 400_000_000)
            
            withAnimation(.easeOut(duration: 0.3)) {
                highlightedNodeID = nil
                isAnimating = false
            }
        }
    }
    
    // Traversal Animations
    func runTraversal() {
        guard let root = rootNode, !isAnimating else { return }
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        isAnimating = true
        withAnimation {
            outputArray.removeAll()
            visitedNodeIDs.removeAll()
            highlightedNodeID = nil
        }
        
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 300_000_000)
            
            switch currentMode {
            case .inOrder:
                await traverseInOrder(node: root)
            case .preOrder:
                await traversePreOrder(node: root)
            case .postOrder:
                await traversePostOrder(node: root)
            default:
                break
            }
            
            withAnimation(.easeOut(duration: 0.3)) {
                highlightedNodeID = nil
                isAnimating = false
                codeHistory.append("// Traversal complete! [\(outputArray.map { String($0) }.joined(separator: ", "))]")
            }
        }
    }
    
    func traverseInOrder(node: TreeNode) async {
        // Left
        if let left = node.left {
            await traverseInOrder(node: left)
        }
        
        // Visit
        await visitNode(node)
        
        // Right
        if let right = node.right {
            await traverseInOrder(node: right)
        }
    }
    
    func traversePreOrder(node: TreeNode) async {
        // Visit
        await visitNode(node)
        
        // Left
        if let left = node.left {
            await traversePreOrder(node: left)
        }
        
        // Right
        if let right = node.right {
            await traversePreOrder(node: right)
        }
    }
    
    func traversePostOrder(node: TreeNode) async {
        // Left
        if let left = node.left {
            await traversePostOrder(node: left)
        }
        
        // Right
        if let right = node.right {
            await traversePostOrder(node: right)
        }
        
        // Visit
        await visitNode(node)
    }
    
    @MainActor
    func visitNode(_ node: TreeNode) async {
        //pause fundtion
        while isPaused {
            try? await Task.sleep(nanoseconds: 100_000_000)
        }
        
        withAnimation(.easeInOut(duration: 0.25)) {
            highlightedNodeID = node.id
            let snippet: String
            switch currentMode {
            case .inOrder:
                snippet = "inOrder: visit(\(node.value))"
            case .preOrder:
                snippet = "preOrder: visit(\(node.value))"
            case .postOrder:
                snippet = "postOrder: visit(\(node.value))"
            default:
                snippet = "visit(\(node.value))"
            }
            codeHistory.append(snippet)
        }
        
        let haptic = UIImpactFeedbackGenerator(style: .light)
        haptic.impactOccurred()
        
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        // Mark as visited and add to output
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            visitedNodeIDs.insert(node.id)
            outputArray.append(node.value)
            highlightedNodeID = nil
        }
        
        try? await Task.sleep(nanoseconds: 300_000_000)
    }
    
    // Delete Last Node
    func deleteLastNode() {
        guard let root = rootNode else { return }
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
        
        // Clear traversal state
        clearAnimationState()
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            if root.left == nil && root.right == nil {
                rootNode = nil
                codeHistory.append("tree.clear();")
                updateTrigger = UUID()
                return
            }
            
            var queue: [TreeNode] = [root]
            var lastNode: TreeNode? = nil
            var parentMap: [UUID: TreeNode] = [:]
            
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
            
            if let target = lastNode, let parent = parentMap[target.id] {
                if parent.right?.id == target.id {
                    parent.right = nil
                } else if parent.left?.id == target.id {
                    parent.left = nil
                }
                codeHistory.append("tree.removeLast(); // removed \(target.value)")
            }
            
            updateTrigger = UUID()
        }
    }
    
    func resetTree() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
        
        clearAnimationState()
        
        withAnimation {
            rootNode = nil
            codeHistory = [currentMode == .bst ? "BST bst = new BST();" : "BinaryTree tree = new BinaryTree();"]
            updateTrigger = UUID()
        }
    }
    
    func clearAnimationState() {
        highlightedNodeID = nil
        visitedNodeIDs.removeAll()
        outputArray.removeAll()
        isPaused = false
        isAnimating = false
    }
    
    func countNodes(_ node: TreeNode?) -> Int {
        guard let node = node else { return 0 }
        return 1 + countNodes(node.left) + countNodes(node.right)
    }
}

// Recursive Tree Diagram
struct TreeDiagramView: View {
    let node: TreeNode
    var highlightedNodeID: UUID? = nil
    var visitedNodeIDs: Set<UUID> = []
    
    var body: some View {
        VStack(spacing: 30) {
            NodeCircleView(
                value: node.value,
                isHighlighted: highlightedNodeID == node.id,
                isVisited: visitedNodeIDs.contains(node.id)
            )
            .anchorPreference(key: NodeBoundsKey.self, value: .center) { anchor in
                [node.id: anchor]
            }
            .zIndex(2)
            
            if node.left != nil || node.right != nil {
                HStack(alignment: .top, spacing: 30) {
                    if let left = node.left {
                        TreeDiagramView(
                            node: left,
                            highlightedNodeID: highlightedNodeID,
                            visitedNodeIDs: visitedNodeIDs
                        )
                    } else if node.right != nil {
                        Color.clear.frame(width: 45, height: 45)
                    }
                    
                    if let right = node.right {
                        TreeDiagramView(
                            node: right,
                            highlightedNodeID: highlightedNodeID,
                            visitedNodeIDs: visitedNodeIDs
                        )
                    } else if node.left != nil {
                        Color.clear.frame(width: 45, height: 45)
                    }
                }
            }
        }
    }
}

// Preference Key for Line Drawing
struct NodeBoundsKey: PreferenceKey {
    static let defaultValue: [UUID: Anchor<CGPoint>] = [:]
    
    static func reduce(
        value: inout [UUID: Anchor<CGPoint>],
        nextValue: () -> [UUID: Anchor<CGPoint>]
    ) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

// Node Circle View
struct NodeCircleView: View {
    let value: Int
    var isHighlighted: Bool = false
    var isVisited: Bool = false
    
    var body: some View {
        Text("\(value)")
            .font(.headline)
            .bold()
            .foregroundStyle(isHighlighted ? .black : (isVisited ? .black : .black))
            .frame(width: 45, height: 45)
            .background(nodeBackground)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(nodeBorderColor, lineWidth: 3)
            )
            .shadow(color: shadowColor, radius: isHighlighted ? 10 : 5)
            .scaleEffect(isHighlighted ? 1.2 : 1.0)
            .animation(.easeInOut(duration: 0.25), value: isHighlighted)
            .animation(.easeInOut(duration: 0.25), value: isVisited)
            .transition(.scale)
    }
    
    private var nodeBackground: Color {
        if isHighlighted {
            return .yellow
        } else if isVisited {
            return .green
        }
        return .white
    }
    
    private var nodeBorderColor: Color {
        if isHighlighted {
            return .orange
        } else if isVisited {
            return .green.opacity(0.8)
        }
        return .green
    }
    
    private var shadowColor: Color {
        if isHighlighted {
            return .yellow.opacity(0.6)
        } else if isVisited {
            return .green.opacity(0.4)
        }
        return .black.opacity(0.3)
    }
}

@MainActor
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
