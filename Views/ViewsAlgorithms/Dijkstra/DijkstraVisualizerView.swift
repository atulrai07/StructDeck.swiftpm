//
//  DijkstraVisualizerView.swift
//  DSAK
//

import SwiftUI

struct GraphNode: Identifiable, Equatable {
    let id: Int
    var position: CGPoint
}

struct GraphEdge: Equatable, Hashable {
    let source: Int
    let destination: Int
    let weight: Int
}

struct DijkstraStep {
    var visitedNodes: Set<Int>
    var currentDistances: [Int: Int]
    var exploringEdge: GraphEdge?
    var shortestPathTree: Set<GraphEdge>
    var stepDescription: String
}

struct DijkstraVisualizerView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var nodes: [GraphNode] = []
    @State private var edges: [GraphEdge] = []
    
    @State private var steps: [DijkstraStep] = []
    @State private var currentStepIndex: Int = 0
    
    let timeComplexity = "O(V + E log V)"
    
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
                            
                            // Edge Weight
                            Text("\(edge.weight)")
                                .font(.caption)
                                .bold()
                                .foregroundStyle(.white)
                                .padding(4)
                                .background(Color.blue.opacity(0.8))
                                .clipShape(Circle())
                                .position(
                                    x: (srcNode.position.x + dstNode.position.x) / 2,
                                    y: (srcNode.position.y + dstNode.position.y) / 2
                                )
                        }
                    }
                    
                    // Draw Nodes
                    ForEach(nodes) { node in
                        ZStack {
                            Circle()
                                .fill(getNodeColor(node.id))
                                .frame(width: 40, height: 40)
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            
                            Text("\(node.id)")
                                .font(.headline)
                                .foregroundStyle(.white)
                            
                            // Distance Label
                            if let step = currentStep, let dist = step.currentDistances[node.id] {
                                Text(dist == Int.max ? "∞" : "\(dist)")
                                    .font(.caption2)
                                    .bold()
                                    .foregroundStyle(.white)
                                    .padding(4)
                                    .background(Color.red.opacity(0.8))
                                    .clipShape(Capsule())
                                    .offset(y: -30)
                            }
                        }
                        .position(node.position)
                    }
                }
                .onAppear {
                    if nodes.isEmpty {
                        generateRandomGraph()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Controls & Stats Area
            VStack(spacing: 16) {
                // Info Text
                Text(currentStep?.stepDescription ?? "Generate a graph to start.")
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
                            .foregroundStyle(.orange)
                    }
                }
                
                // Navigation Buttons (Forward/Backward)
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
        .navigationTitle("Dijkstra's Algorithm")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement:.topBarTrailing){
                Button(action: generateRandomGraph) {
                    Image(systemName: "arrow.clockwise")
                }
                .accessibilityLabel("Generate Random Graph")
            }
        }
        .background(Color.VisualizerBackgroundColor)
    }
    
    // MARK: - Helper Getters
    
    var currentStep: DijkstraStep? {
        if steps.isEmpty { return nil }
        return steps[currentStepIndex]
    }
    
    func getNodeColor(_ id: Int) -> Color {
        guard let step = currentStep else { return .gray }
        if id == 0 { return .orange } // Start node
        if id == nodes.count - 1 { return .purple } // Destination node
        if step.visitedNodes.contains(id) { return .green }
        if step.currentDistances[id] != nil && step.currentDistances[id]! < Int.max { return .teal } // Discovered
        return .gray
    }
    
    func getEdgeColor(_ edge: GraphEdge) -> Color {
        guard let step = currentStep else { return .gray.opacity(0.3) }
        if step.exploringEdge == edge { return .yellow }
        if step.shortestPathTree.contains(edge) { return .green }
        return .gray.opacity(0.3)
    }
    
    func getEdgeWidth(_ edge: GraphEdge) -> CGFloat {
        guard let step = currentStep else { return 2 }
        if step.exploringEdge == edge { return 6 }
        if step.shortestPathTree.contains(edge) { return 4 }
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
    
    func generateRandomGraph() {
        // Find current window size approx
        let size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.6)
        generateGraphData(in: size)
    }
    
    func generateGraphData(in size: CGSize) {
        nodes.removeAll()
        edges.removeAll()
        steps.removeAll()
        currentStepIndex = 0
        
        let nodeCount = Int.random(in: 6...9)
        let padding: CGFloat = 50
        
        // Generate random nodes ensuring they are somewhat spaced
        for i in 0..<nodeCount {
            var position: CGPoint
            var tooClose = true
            var attempts = 0
            
            let safeWidth = max(size.width, padding * 2 + 10.0)
            let safeHeight = max(size.height, padding * 2 + 10.0)
            
            repeat {
                position = CGPoint(
                    x: CGFloat.random(in: padding...(safeWidth - padding)),
                    y: CGFloat.random(in: padding...(safeHeight - padding))
                )
                tooClose = false
                for other in nodes {
                    let dx = position.x - other.position.x
                    let dy = position.y - other.position.y
                    if sqrt(dx*dx + dy*dy) < 80 {
                        tooClose = true
                        break
                    }
                }
                attempts += 1
            } while tooClose && attempts < 50
            nodes.append(GraphNode(id: i, position: position))
        }
        
        // Ensure destination (last node) is roughly on the opposite side to start (0) optionally
        
        // Connect nodes to form a connected graph
        for i in 1..<nodeCount {
            // connect to a random existing node
            let target = Int.random(in: 0..<i)
            let weight = Int.random(in: 1...9)
            edges.append(GraphEdge(source: target, destination: i, weight: weight))
        }
        
        // Add some random extra edges
        let extraEdges = Int.random(in: 2...5)
        for _ in 0..<extraEdges {
            let u = Int.random(in: 0..<nodeCount)
            let v = Int.random(in: 0..<nodeCount)
            if u != v && !edges.contains(where: { ($0.source == u && $0.destination == v) || ($0.source == v && $0.destination == u) }) {
                edges.append(GraphEdge(source: min(u,v), destination: max(u,v), weight: Int.random(in: 1...9)))
            }
        }
        
        // Compute Dijkstra steps
        computeDijkstra()
    }
    
    func computeDijkstra() {
        var distances = [Int: Int]()
        var previousEdge = [Int: GraphEdge]()
        for node in nodes { distances[node.id] = Int.max }
        distances[0] = 0
        
        var visited = Set<Int>()
        var sptSet = Set<GraphEdge>()
        var unvisited = Set(nodes.map { $0.id })
        
        steps.append(DijkstraStep(
            visitedNodes: visited,
            currentDistances: distances,
            exploringEdge: nil,
            shortestPathTree: sptSet,
            stepDescription: "Starting at Node 0. Initializing distances to infinity."
        ))
        
        while !unvisited.isEmpty {
            // Find unvisited node with min distance
            var minNode = -1
            var minDist = Int.max
            for u in unvisited {
                if distances[u]! < minDist {
                    minDist = distances[u]!
                    minNode = u
                }
            }
            
            if minNode == -1 { break } // Remaining nodes are inaccessible
            
            unvisited.remove(minNode)
            visited.insert(minNode)
            
            if let edgeToHere = previousEdge[minNode] {
                sptSet.insert(edgeToHere)
            }
            
            steps.append(DijkstraStep(
                visitedNodes: visited,
                currentDistances: distances,
                exploringEdge: nil,
                shortestPathTree: sptSet,
                stepDescription: "Moved to Node \(minNode) with shortest known distance \(minDist)."
            ))
            
            if minNode == nodes.count - 1 {
                steps.append(DijkstraStep(
                    visitedNodes: visited,
                    currentDistances: distances,
                    exploringEdge: nil,
                    shortestPathTree: sptSet,
                    stepDescription: "Reached destination (Node \(minNode)). Shortest path found!"
                ))
                break
            }
            
            // Explore neighbors
            let adjEdges = edges.filter { $0.source == minNode || $0.destination == minNode }
            for edge in adjEdges {
                let neighbor = edge.source == minNode ? edge.destination : edge.source
                if !visited.contains(neighbor) {
                    // Show exploring
                    steps.append(DijkstraStep(
                        visitedNodes: visited,
                        currentDistances: distances,
                        exploringEdge: edge,
                        shortestPathTree: sptSet,
                        stepDescription: "Exploring edge to Node \(neighbor) with weight \(edge.weight)."
                    ))
                    
                    let newDist = minDist + edge.weight
                    if newDist < distances[neighbor]! {
                        distances[neighbor] = newDist
                        previousEdge[neighbor] = edge
                        steps.append(DijkstraStep(
                            visitedNodes: visited,
                            currentDistances: distances,
                            exploringEdge: edge,
                            shortestPathTree: sptSet,
                            stepDescription: "Found shorter path to Node \(neighbor). Distance updated to \(newDist)."
                        ))
                    } else {
                        steps.append(DijkstraStep(
                            visitedNodes: visited,
                            currentDistances: distances,
                            exploringEdge: edge,
                            shortestPathTree: sptSet,
                            stepDescription: "Path to Node \(neighbor) via Node \(minNode) is not shorter."
                        ))
                    }
                }
            }
        }
        currentStepIndex = 0
    }
}

#Preview {
    NavigationStack {
        DijkstraVisualizerView()
            .preferredColorScheme(.dark)
    }
}
