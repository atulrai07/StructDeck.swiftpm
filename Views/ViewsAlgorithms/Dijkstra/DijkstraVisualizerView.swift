//
//  DijkstraVisualizerView.swift
//  DSAK
//
//  Created by Atul on 11/02/26.

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
    var activeNode: Int? // Added to track the currently focused node
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
                            
                            // Edge Weight (Shrunk font and padding)
                            Text("\(edge.weight)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(3)
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
                                .frame(width: 30, height: 30) // Reduced from 40
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            
                            Text("\(node.id)")
                                .font(.subheadline) // Adjusted to fit smaller node
                                .foregroundStyle(.white)
                            
                            // Distance Label (Only shown for active node)
                            if let step = currentStep, let dist = step.currentDistances[node.id], step.activeNode == node.id {
                                Text(dist == Int.max ? "∞" : "\(dist)")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundStyle(.white)
                                    .padding(4)
                                    .background(Color.red.opacity(0.8))
                                    .clipShape(Capsule())
                                    .offset(y: -24) // Adjusted for smaller node
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
                            .foregroundStyle(.white)
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
        if id == nodes.count - 1 { return .blue } // Destination node
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
        
        // --- NEW CIRCULAR/ELLIPTICAL PLACEMENT LOGIC ---
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        // Ensure radius doesn't go negative on exceptionally small screens
        let radiusX = max(10, (size.width / 2) - padding)
        let radiusY = max(10, (size.height / 2) - padding)
        
        // Generate nodes distributed evenly along an ellipse
        for i in 0..<nodeCount {
            // Calculate angle: distribute around 2 * pi radians.
            // Subtract pi/2 to start Node 0 near the top center (12 o'clock).
            let angle = (CGFloat(2 * Double.pi) / CGFloat(nodeCount)) * CGFloat(i) - CGFloat(Double.pi / 2)
            
            let position = CGPoint(
                x: center.x + radiusX * cos(angle),
                y: center.y + radiusY * sin(angle)
            )
            nodes.append(GraphNode(id: i, position: position))
        }
        // ----------------------------------------------
        
        // Connect nodes to form a connected graph
        for i in 1..<nodeCount {
            // connect to a random existing node
            let target = Int.random(in: 0..<i)
            let weight = Int.random(in: 1...9)
            edges.append(GraphEdge(source: target, destination: i, weight: weight))
        }
        
        // Add some random extra edges (CAPPED at 1 or 2 to reduce clutter)
        let extraEdges = Int.random(in: 1...2)
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
                activeNode: 0, // Node 0 is initially active
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
                    activeNode: minNode,
                    stepDescription: "Moved to Node \(minNode) with shortest known distance \(minDist)."
                ))
                
                if minNode == nodes.count - 1 {
                    // --- THE FIX: BACKTRACK TO FIND THE EXACT PATH ---
                    var exactPath = Set<GraphEdge>()
                    var curr = minNode
                    
                    // Trace backwards from destination to start
                    while let edge = previousEdge[curr] {
                        exactPath.insert(edge)
                        // Move to the node on the other side of this edge
                        curr = (edge.source == curr) ? edge.destination : edge.source
                    }
                    
                    steps.append(DijkstraStep(
                        visitedNodes: visited,
                        currentDistances: distances,
                        exploringEdge: nil,
                        shortestPathTree: exactPath, // Inject only the final path here
                        activeNode: minNode,
                        stepDescription: "Reached destination (Node \(minNode)). Shortest path found!"
                    ))
                    break
                    // -------------------------------------------------
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
                            activeNode: minNode, // Still operating from minNode
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
                                activeNode: minNode, // Keep active node to show distance context
                                stepDescription: "Found shorter path to Node \(neighbor). Distance updated to \(newDist)."
                            ))
                        } else {
                            steps.append(DijkstraStep(
                                visitedNodes: visited,
                                currentDistances: distances,
                                exploringEdge: edge,
                                shortestPathTree: sptSet,
                                activeNode: minNode,
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
