//
//  DFSVisualizerView.swift
//  DSAK
//
//  Created by Atul on 09/02/26.

import SwiftUI

struct DFSTreeNode: Identifiable, Equatable {
    let id: Int
    var position: CGPoint
}

struct DFSTreeEdge: Equatable, Hashable {
    let source: Int
    let destination: Int
}

struct DFSStep {
    var visitedNodes: Set<Int>
    var stack: [Int]
    var exploringNode: Int?
    var exploringEdge: DFSTreeEdge?
    var stepDescription: String
    var codeStatement: String
}

struct DFSVisualizerView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var nodes: [DFSTreeNode] = []
    @State private var edges: [DFSTreeEdge] = []
    
    @State private var steps: [DFSStep] = []
    @State private var currentStepIndex: Int = 0
    
    let timeComplexity = "O(V + E)"
    
    let depth = 4 // Levels
    let nodeRadius: CGFloat = 20
    
    var codeHistory: [String] {
        if steps.isEmpty {
            return ["stack.push(0);"]
        }
        return steps.prefix(currentStepIndex + 1).map { $0.codeStatement }
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                // Visualizer Canvas Area
                GeometryReader { geometry in
                    ZStack {
                        Color.VisualizerBackgroundColor.opacity(0.8)
                        
                        // Draw Edges
                        ForEach(edges, id: \.self) { edge in
                            if let srcNode = nodes.first(where: { $0.id == edge.source }),
                               let dstNode = nodes.first(where: { $0.id == edge.destination }) {
                                Path { path in
                                    path.move(to: srcNode.position)
                                    path.addLine(to: dstNode.position)
                                }
                                .stroke(getEdgeColor(edge), lineWidth: getEdgeWidth(edge))
                            }
                        }
                        
                        // Draw Nodes
                        ForEach(nodes) { node in
                            ZStack {
                                Circle()
                                    .fill(getNodeColor(node.id))
                                    .frame(width: nodeRadius * 2, height: nodeRadius * 2)
                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                
                                Text("\(node.id)")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                            }
                            .position(node.position)
                        }
                        
                        // Draw Stack
                        if let step = currentStep {
                            VStack(alignment: .leading) {
                                Text("Stack (LIFO)")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                                HStack {
                                    Text("Bottom")
                                        .font(.caption2)
                                        .foregroundStyle(.white)
                                    ForEach(step.stack, id: \.self) { sNode in
                                        Text("\(sNode)")
                                            .font(.caption)
                                            .bold()
                                            .frame(width: 30, height: 30)
                                            .background(Color.blue)
                                            .foregroundStyle(.black)
                                            .clipShape(RoundedRectangle(cornerRadius: 6))
                                    }
                                    Text("Top")
                                        .font(.caption2)
                                        .foregroundStyle(.white)
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                            .position(x: geometry.size.width / 2, y: geometry.size.height - 50)
                        }
                    }
                    .onAppear {
                        if nodes.isEmpty {
                            generateRandomTree()
                        }
                    }
                }
                .frame(height: 350)
                
                // Controls & Stats Area
                VStack(spacing: 16) {
                    // Info Text
                    Text(currentStep?.stepDescription ?? "Generate a tree to start.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                        .frame(height: 50)
                        .padding(.horizontal)
                    
                    HStack(spacing: 40) {
                        VStack {
                            Text("Steps Taken")
                                .font(.caption)
                                .foregroundStyle(.gray)
                            Text("\(currentStepIndex) / \(max(0, steps.count - 1))")
                                .font(.headline)
                                .foregroundStyle(.white)
                        }
                        
                        VStack {
                            Text("Time Complexity")
                                .font(.caption)
                                .foregroundStyle(.gray)
                            Text(timeComplexity)
                                .font(.headline)
                                .foregroundStyle(.white)
                        }
                    }
                    
                    // Navigation Buttons
                    HStack(spacing: 30) {
                        Button(action: stepBackward) {
                            Image(systemName: "backward.fill")
                                .font(.title)
                                .foregroundStyle(currentStepIndex > 0 ? .white : .gray)
                                .padding()
                                .background(Circle().fill(Color.blue.opacity(currentStepIndex > 0 ? 1 : 0.3)))
                        }
                        .disabled(currentStepIndex == 0)
                        .accessibilityLabel("Step Backward")
                        
                        Button(action: stepForward) {
                            Image(systemName: "forward.fill")
                                .font(.title)
                                .foregroundStyle(currentStepIndex < steps.count - 1 ? .white : .gray)
                                .padding()
                                .background(Circle().fill(Color.blue
                                    .opacity(currentStepIndex < steps.count - 1 ? 1 : 0.3)))
                        }
                        .disabled(currentStepIndex >= steps.count - 1)
                        .accessibilityLabel("Step Forward")
                    }
                }
                .padding(.vertical, 20)
                .background(Color(uiColor: .systemBackground).opacity(0))
                
                ExpandableCodeInsightView(codeHistory: codeHistory, dataStructure: "DFS")
                    .padding(.bottom, 20)
            }
        }
        .navigationTitle("Depth-First Search")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            Button(action: generateRandomTree) {
                Image(systemName: "arrow.clockwise")
            }
            .accessibilityLabel("Generate a New Tree")
        }
        .background(Color.VisualizerBackgroundColor)
        .onAppear {
            UserProgressManager.shared.markVisualizerVisited(moduleId: "dfs", moduleName: "DFS", category: "algorithm")
        }
        
    }
    
    //Helper Getters
    
    var currentStep: DFSStep? {
        if steps.isEmpty { return nil }
        return steps[currentStepIndex]
    }
    
    func getNodeColor(_ id: Int) -> Color {
        guard let step = currentStep else { return .gray }
        if step.exploringNode == id { return .yellow }
        if step.visitedNodes.contains(id) { return .green }
        if step.stack.contains(id) { return .blue }
        return .gray
    }
    
    func getEdgeColor(_ edge: DFSTreeEdge) -> Color {
        guard let step = currentStep else { return .gray.opacity(0.3) }
        if step.exploringEdge == edge { return .yellow }
        if step.visitedNodes.contains(edge.destination) { return .green }
        return .gray.opacity(0.3)
    }
    
    func getEdgeWidth(_ edge: DFSTreeEdge) -> CGFloat {
        guard let step = currentStep else { return 2 }
        if step.exploringEdge == edge { return 6 }
        if step.visitedNodes.contains(edge.destination) { return 4 }
        return 2
    }
    
    func stepForward() {
        if currentStepIndex < steps.count - 1 {
            currentStepIndex += 1
        }
    }
    
    func stepBackward() {
        if currentStepIndex > 0 {
            currentStepIndex -= 1
        }
    }
    
    func generateRandomTree() {
        let size = CGSize(width: UIScreen.main.bounds.width, height: 350)
        generateTreeData(in: size)
    }
    
    func generateTreeData(in size: CGSize) {
        nodes.removeAll()
        edges.removeAll()
        steps.removeAll()
        currentStepIndex = 0
        
        let width = size.width
        let height = size.height - 100
        var activeNodes = [Bool](repeating: false, count: 15)
        
        repeat {
            activeNodes = [Bool](repeating: false, count: 15)
            activeNodes[0] = true // Root is always there
            
            for i in 0..<7 {
                if activeNodes[i] {
                    let hasLeft = Bool.random() || i < 2
                    let hasRight = Bool.random() || i < 2
                    
                    if hasLeft { activeNodes[2 * i + 1] = true }
                    if hasRight { activeNodes[2 * i + 2] = true }
                }
            }
        } while activeNodes.filter({ $0 }).count < 10
        
        // Assign positions
        let levelHeight = height / CGFloat(depth)
        
        for i in 0..<15 {
            if activeNodes[i] {
                let lvl = Int(log2(Double(i + 1)))
                let positionInLevel = i - (1 << lvl) + 1
                let itemsInLevel = 1 << lvl
                
                let xSpacing = width / CGFloat(itemsInLevel + 1)
                let x = xSpacing * CGFloat(positionInLevel + 1)
                let y = (CGFloat(lvl) + 0.5) * levelHeight
                
                nodes.append(DFSTreeNode(id: i, position: CGPoint(x: x, y: y)))
                
                // Add edge from parent
                if i > 0 {
                    let parent = (i - 1) / 2
                    edges.append(DFSTreeEdge(source: parent, destination: i))
                }
            }
        }
        
        computeDFS()
    }
    
    func computeDFS() {
        guard !nodes.isEmpty else { return }
        let root = 0
        
        var visited = Set<Int>()
        var stack = [root]
        
        steps.append(DFSStep(
            visitedNodes: visited,
            stack: stack,
            exploringNode: nil,
            exploringEdge: nil,
            stepDescription: "Start at Root Node \(root). Push \(root) onto Stack.",
            codeStatement: "stack.push(\(root)); // start DFS"
        ))
        
        while !stack.isEmpty {
            let current = stack.removeLast()
            
            if !visited.contains(current) {
                visited.insert(current)
                
                steps.append(DFSStep(
                    visitedNodes: visited,
                    stack: stack,
                    exploringNode: current,
                    exploringEdge: nil,
                    stepDescription: "Pop Node \(current). Mark as visited.",
                    codeStatement: "int current = stack.pop(); // visiting Node \(current)"
                ))
                
                let childrenEdges = edges.filter { $0.source == current }
                let children = childrenEdges.map { $0.destination }.sorted(by: >)
                
                for child in children {
                    let childEdge = childrenEdges.first(where: { $0.destination == child })!
                    
                    steps.append(DFSStep(
                        visitedNodes: visited,
                        stack: stack,
                        exploringNode: current,
                        exploringEdge: childEdge,
                        stepDescription: "Explore edge to Node \(child).",
                        codeStatement: "// exploring edge from Node \(current) to \(child)"
                    ))
                    
                    if !visited.contains(child) {
                        stack.append(child)
                        steps.append(DFSStep(
                            visitedNodes: visited,
                            stack: stack,
                            exploringNode: current,
                            exploringEdge: childEdge,
                            stepDescription: "Node \(child) discovered. Push \(child) onto Stack.",
                            codeStatement: "stack.push(\(child)); // discovered Node \(child)"
                        ))
                    }
                }
            } else {
                steps.append(DFSStep(
                    visitedNodes: visited,
                    stack: stack,
                    exploringNode: nil,
                    exploringEdge: nil,
                    stepDescription: "Pop Node \(current) but it is already visited. Skipping.",
                    codeStatement: "int current = stack.pop(); // \(current) already visited, skipped"
                ))
            }
        }
        
        steps.append(DFSStep(
            visitedNodes: visited,
            stack: [],
            exploringNode: nil,
            exploringEdge: nil,
            stepDescription: "Stack is empty. DFS Traversal Complete.",
            codeStatement: "// stack is empty: DFS traversal complete!"
        ))
        
        currentStepIndex = 0
    }
}

#Preview {
    NavigationStack {
        DFSVisualizerView()
            .preferredColorScheme(.dark)
    }
}
