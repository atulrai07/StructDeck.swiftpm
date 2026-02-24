//
//  BFSVisualizerView.swift
//  DSAK
//

import SwiftUI

struct BFSTreeNode: Identifiable, Equatable {
    let id: Int
    var position: CGPoint
}

struct BFSTreeEdge: Equatable, Hashable {
    let source: Int
    let destination: Int
}

struct BFSStep {
    var visitedNodes: Set<Int>
    var queue: [Int]
    var exploringNode: Int?
    var exploringEdge: BFSTreeEdge?
    var stepDescription: String
}

struct BFSVisualizerView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var nodes: [BFSTreeNode] = []
    @State private var edges: [BFSTreeEdge] = []
    
    @State private var steps: [BFSStep] = []
    @State private var currentStepIndex: Int = 0
    
    let timeComplexity = "O(V + E)"
    
    // Layout parameters
    let depth = 4 // Levels 0, 1, 2, 3 -> Up to 15 nodes
    let nodeRadius: CGFloat = 20
    
    var body: some View {
        VStack(spacing: 0) {
            // Visualizer Canvas Area
            GeometryReader { geometry in
                ZStack {
                    Color.VisualizerBackgroundColor
                    
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
                    
                    // Draw Queue
                    if let step = currentStep {
                        VStack(alignment: .leading) {
                            Text("Queue (FIFO)")
                                .font(.caption)
                                .foregroundStyle(.gray)
                            HStack {
                                Text("Front")
                                    .font(.caption2)
                                    .foregroundStyle(.white)
                                ForEach(step.queue, id: \.self) { qNode in
                                    Text("\(qNode)")
                                        .font(.caption)
                                        .bold()
                                        .frame(width: 30, height: 30)
                                        .background(Color.blue)
                                        .foregroundStyle(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 6))
                                }
                                Text("Rear")
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
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
                            .background(Circle().fill(Color.blue.opacity(currentStepIndex < steps.count - 1 ? 1 : 0.3)))
                    }
                    .disabled(currentStepIndex >= steps.count - 1)
                    .accessibilityLabel("Step Forward")
                }
            }
            .padding(.vertical, 20)
            .background(Color(uiColor: .systemBackground).opacity(0))

        }
        .navigationTitle("Breadth-First Search (BFS)")
        .navigationBarTitleDisplayMode(.inline)
        //toolbar
        .toolbar{
            ToolbarItem(placement: .topBarTrailing){
                Button(action: generateRandomTree) {
                    Image(systemName: "arrow.clockwise")
                }
                .accessibilityLabel("Generate Random Tree")
            }
        }
        .background(Color.VisualizerBackgroundColor)
    }
    
    // MARK: - Helper Getters
    
    var currentStep: BFSStep? {
        if steps.isEmpty { return nil }
        return steps[currentStepIndex]
    }
    
    func getNodeColor(_ id: Int) -> Color {
        guard let step = currentStep else { return .gray }
        if step.exploringNode == id { return .yellow }
        if step.visitedNodes.contains(id) { return .green }
        if step.queue.contains(id) { return .blue } // Discovered but not explored
        return .gray
    }
    
    func getEdgeColor(_ edge: BFSTreeEdge) -> Color {
        guard let step = currentStep else { return .gray.opacity(0.3) }
        if step.exploringEdge == edge { return .yellow }
        if step.visitedNodes.contains(edge.destination) { return .green }
        return .gray.opacity(0.3)
    }
    
    func getEdgeWidth(_ edge: BFSTreeEdge) -> CGFloat {
        guard let step = currentStep else { return 2 }
        if step.exploringEdge == edge { return 6 }
        if step.visitedNodes.contains(edge.destination) { return 4 }
        return 2
    }
    
    // MARK: - Logic
    
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
        let size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.6)
        generateTreeData(in: size)
    }
    
    func generateTreeData(in size: CGSize) {
        nodes.removeAll()
        edges.removeAll()
        steps.removeAll()
        currentStepIndex = 0
        
        let width = size.width
        let height = size.height - 100 // Leave space for queue UI
        
        // Generate a random binary tree using an array up to index 14
        // Ensure at least 10 nodes are generated
        var activeNodes = [Bool](repeating: false, count: 15)
        
        repeat {
            activeNodes = [Bool](repeating: false, count: 15)
            activeNodes[0] = true // Root is always there
            
            for i in 0..<7 {
                if activeNodes[i] {
                    let hasLeft = Bool.random() || i < 2 // First two levels always branch
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
                
                nodes.append(BFSTreeNode(id: i, position: CGPoint(x: x, y: y)))
                
                // Add edge from parent
                if i > 0 {
                    let parent = (i - 1) / 2
                    edges.append(BFSTreeEdge(source: parent, destination: i))
                }
            }
        }
        
        computeBFS()
    }
    
    func computeBFS() {
        guard !nodes.isEmpty else { return }
        let root = 0
        
        var visited = Set<Int>()
        var queue = [root]
        
        steps.append(BFSStep(
            visitedNodes: visited,
            queue: queue,
            exploringNode: nil,
            exploringEdge: nil,
            stepDescription: "Start at Root Node \(root). Enqueue \(root)."
        ))
        
        while !queue.isEmpty {
            let current = queue.removeFirst()
            visited.insert(current)
            
            steps.append(BFSStep(
                visitedNodes: visited,
                queue: queue,
                exploringNode: current,
                exploringEdge: nil,
                stepDescription: "Dequeue Node \(current). Mark as visited."
            ))
            
            // Find children (neighbors)
            let childrenEdges = edges.filter { $0.source == current }
            let children = childrenEdges.map { $0.destination }.sorted() // Visit left to right usually
            
            for childEdges in childrenEdges {
                let child = childEdges.destination
                steps.append(BFSStep(
                    visitedNodes: visited,
                    queue: queue,
                    exploringNode: current,
                    exploringEdge: childEdges,
                    stepDescription: "Explore edge to Node \(child)."
                ))
                
                if !visited.contains(child) && !queue.contains(child) {
                    queue.append(child)
                    steps.append(BFSStep(
                        visitedNodes: visited,
                        queue: queue,
                        exploringNode: current,
                        exploringEdge: childEdges,
                        stepDescription: "Node \(child) discovered. Enqueue \(child)."
                    ))
                }
            }
        }
        
        steps.append(BFSStep(
            visitedNodes: visited,
            queue: [],
            exploringNode: nil,
            exploringEdge: nil,
            stepDescription: "Queue is empty. BFS Traversal Complete."
        ))
        
        currentStepIndex = 0
    }
}

#Preview {
    NavigationStack {
        BFSVisualizerView()
            .preferredColorScheme(.dark)
    }
}
