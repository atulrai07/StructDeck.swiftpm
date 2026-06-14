//
//  AIExplainService.swift
//    Visulo
//
//  Created by Atul on 12/06/26.
//

import SwiftUI
#if canImport(FoundationModels)
import FoundationModels
#endif

@MainActor
class AIExplainService: ObservableObject {
    static let shared = AIExplainService()
    
    private init() {}
    
    /// Stream explanation of a code snippet for a given data structure/context.
    /// Returns an AsyncThrowingStream that yields chunks of the Markdown response.
    func streamExplanation(for code: String, dataStructure: String) -> AsyncThrowingStream<String, any Error> {
        let useMock = AIQuizGenerator.shared.isUsingMock
        
        return AsyncThrowingStream(String.self) { continuation in
            let task = Task {
                if useMock {
                    await self.streamMockExplanation(for: code, dataStructure: dataStructure, continuation: continuation)
                    return
                }
                
                #if canImport(FoundationModels)
                if #available(iOS 26.0, *) {
                    do {
                        let instructions = """
                        You are Structy, a friendly, brilliant visual Computer Science tutor.
                        Explain the following Java code snippet for a "\(dataStructure)" implementation in clear, friendly, plain English.
                        
                        Guidelines:
                        1. Provide a step-by-step explanation of what the code is doing.
                        2. Keep it concise, engaging, and easy to read.
                        3. Use bullet points or small paragraphs.
                        4. Focus on DSA concepts (e.g. references, index bounds, time/space complexity).
                        5. Use clean markdown formatting (like bolding key words, backticks for variable names).
                        6. Keep the total length around 100-150 words. Do not reproduce the code block itself.
                        """
                        
                        let session = LanguageModelSession(instructions: instructions)
                        let prompt = "Explain the following Java implementation code for \(dataStructure):\n\n\(code)"
                        
                        let stream = try await session.streamResponse(to: prompt)
                        for try await chunk in stream {
                            continuation.yield(chunk.content)
                        }
                        continuation.finish()
                    } catch {
                        continuation.finish(throwing: error)
                    }
                } else {
                    continuation.finish(throwing: NSError(
                        domain: "AIExplainService",
                        code: 2,
                        userInfo: [NSLocalizedDescriptionKey: "iOS 26.0 or higher required"]
                    ))
                }
                #else
                continuation.finish(throwing: NSError(
                    domain: "AIExplainService",
                    code: 1,
                    userInfo: [NSLocalizedDescriptionKey: "FoundationModels framework not available"]
                ))
                #endif
            }
            
            continuation.onTermination = { termination in
                if case .cancelled = termination {
                    task.cancel()
                }
            }
        }
    }
    
    private func streamMockExplanation(
        for code: String,
        dataStructure: String,
        continuation: AsyncThrowingStream<String, any Error>.Continuation
    ) async {
        let explanationText = generateMockExplanationText(for: code, dataStructure: dataStructure)
        let words = explanationText.components(separatedBy: " ")
        var currentText = ""
        
        // Initial delay to simulate AI starting up
        try? await Task.sleep(nanoseconds: 600_000_000)
        
        for (index, word) in words.enumerated() {
            guard !Task.isCancelled else { break }
            currentText += word + (index == words.count - 1 ? "" : " ")
            continuation.yield(currentText)
            try? await Task.sleep(nanoseconds: 40_000_000) // 40ms per word for natural reading pace
        }
        continuation.finish()
    }
    
    private func generateHistorySummary(for code: String) -> String {
        let lines = code.components(separatedBy: "\n")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty && !$0.hasPrefix("//") && !$0.contains("new ") }
        
        guard !lines.isEmpty else { return "" }
        
        var summary = "\n\n### 📝 Operation History\n"
        summary += "Here is the sequence of operations you executed in this session:\n"
        for (index, line) in lines.enumerated() {
            let formattedLine = line.replacingOccurrences(of: ";", with: "")
            summary += "\(index + 1). `\(formattedLine)`\n"
        }
        return summary
    }
    
    private func generateMockExplanationText(for code: String, dataStructure: String) -> String {
        let normalizedDS = dataStructure.lowercased()
        let historySummary = generateHistorySummary(for: code)
        
        let baseExplanation: String
        if normalizedDS.contains("linked list") {
            baseExplanation = """
            Here is a step-by-step breakdown of how this **Linked List** operation works:

            1. **Node References**: The code manipulates node connections. Each node holds its data payload and a reference (`next`) pointing to the succeeding node.
            2. **Traversal Pattern**: It initializes a traversal pointer (often named `current` or `temp`) pointing to the `head` of the list. It iterates through the list using a `while(current != null)` loop, shifting the pointer with `current = current.next`.
            3. **In-place Mutation**: Notice how pointer redirection is done. When inserting or deleting, we update the reference of the surrounding nodes carefully to bypass or insert nodes without losing reference to the rest of the list.
            4. **Complexity Analysis**:
               * **Time Complexity**: **O(N)** for searching or accessing a node, as we might traverse all nodes. For insertion/deletion at the head, it is **O(1)**.
               * **Space Complexity**: **O(1)** auxiliary space since the structure is modified in-place.
            """
        } else if normalizedDS.contains("queue") {
            baseExplanation = """
            Here is a step-by-step explanation of the **Queue** operation in the snippet:

            1. **First-In-First-Out (FIFO)**: The code implements queue mechanics where elements are added at the `rear` (enqueue) and removed from the `front` (dequeue).
            2. **Index Wraparound**: If it is a circular queue, the modulo operator (`%`) is used to wrap indices back to the beginning of the array, preventing memory waste.
            3. **State Verification**: The code checks edge cases such as **Queue Underflow** (attempting to dequeue when empty) and **Queue Overflow** (attempting to enqueue when the capacity is reached).
            4. **Complexity Analysis**:
               * **Time Complexity**: **O(1)** for both enqueue and dequeue operations, as they directly access front and rear indices.
               * **Space Complexity**: **O(1)** auxiliary space.
            """
        } else if normalizedDS.contains("stack") {
            baseExplanation = """
            Here is the step-by-step analysis of this **Stack** operation:

            1. **Last-In-First-Out (LIFO)**: The code enforces the stack discipline where elements are pushed onto the top and popped off from the top.
            2. **Top Pointer Tracking**: A pointer or array index (typically called `top`) tracks the current top of the stack. A `push` increments `top` and stores the element, while a `pop` retrieves the element and decrements `top`.
            3. **Edge Case Checking**: The implementation verifies if the stack is empty (avoiding **Underflow**) or full (avoiding **Overflow**) before performing operations.
            4. **Complexity Analysis**:
               * **Time Complexity**: **O(1)** for push, pop, and peek, since we only interact with the top element.
               * **Space Complexity**: **O(1)** auxiliary space.
            """
        } else if normalizedDS.contains("binary tree") || normalizedDS.contains("tree") {
            baseExplanation = """
            Here is the step-by-step explanation of this **Binary Tree** operation:

            1. **Hierarchical Structure**: The code defines or traverses nodes starting from the `root`. Each node references a `left` and `right` child.
            2. **Recursive Traversal**: The implementation likely uses recursion to visit nodes. For instance, in-order traversal recursively visits the left subtree, processes the current node, and then recursively visits the right subtree.
            3. **Binary Search Tree (BST) Logic**: If BST rules apply, the code inserts or searches by comparing the target key: smaller keys branch to the `left`, while larger keys branch to the `right`.
            4. **Complexity Analysis**:
               * **Time Complexity**: **O(log N)** on average for search/insertion in a balanced tree. In the worst-case (skewed tree), it degrades to **O(N)**.
               * **Space Complexity**: **O(H)** where `H` is the height of the tree, due to the call stack footprint of recursion.
            """
        } else if normalizedDS.contains("dijkstra") {
            baseExplanation = """
            Here is a step-by-step explanation of this **Dijkstra's Algorithm** implementation:

            1. **Distance Array Initialization**: The algorithm starts by setting the distance to the source node to `0`, and the distance to all other nodes to `Infinity`.
            2. **Priority Selection**: A Min-Priority Queue (or heap) is used to repeatedly extract the unvisited node with the smallest tentative distance.
            3. **Edge Relaxation**: For the selected node, the code inspects all its neighbors. If the path to a neighbor through the current node is shorter than its previously recorded distance, the distance is updated (relaxed).
            4. **Complexity Analysis**:
               * **Time Complexity**: **O((V + E) log V)** using a binary heap priority queue, where `V` is the number of vertices and `E` is the number of edges.
               * **Space Complexity**: **O(V)** to store distances and visited states.
            """
        } else if normalizedDS.contains("bfs") || normalizedDS.contains("breadth") {
            baseExplanation = """
            Here is a step-by-step walkthrough of this **Breadth-First Search (BFS)** implementation:

            1. **Queue-Based Exploration**: The code uses a FIFO `Queue` to keep track of discovered but unvisited nodes. Exploration proceeds level-by-level, expanding outwards.
            2. **Visited Tracking**: A boolean array or set (e.g. `visited`) is checked and updated to ensure that no vertex is processed more than once, preventing infinite loops in cyclic graphs.
            3. **Queue Enqueue/Dequeue Cycle**: The algorithm dequeues the next node, processes it, and then enqueues all of its unvisited neighbors, marking them as visited.
            4. **Complexity Analysis**:
               * **Time Complexity**: **O(V + E)** when using an adjacency list, since every vertex is dequeued once and every edge is checked.
               * **Space Complexity**: **O(V)** due to the queue and visited set storage.
            """
        } else if normalizedDS.contains("dfs") || normalizedDS.contains("depth") {
            baseExplanation = """
            Here is a step-by-step explanation of this **Depth-First Search (DFS)** implementation:

            1. **Stack-Based Exploration**: The code uses recursion (utilizing the system call stack) or an explicit `Stack` to search as deeply as possible along each branch before backtracking.
            2. **Visited Set**: Just like BFS, a `visited` structure is checked to prevent processing the same node multiple times and avoid infinite loops.
            3. **Backtracking Mechanism**: When a node has no unvisited neighbors, the function finishes and returns (backtracks) to the caller, allowing exploration of other branches.
            4. **Complexity Analysis**:
               * **Time Complexity**: **O(V + E)** with an adjacency list representation, visiting all reachable nodes and exploring their edges.
               * **Space Complexity**: **O(V)** in the worst case to store the recursion stack when the graph is a linear chain.
            """
        } else {
            baseExplanation = """
            Here is a step-by-step explanation of this computer science operation:

            1. **Core Concept**: The code implements a fundamental algorithm or data structure operation.
            2. **Logical Flow**: It performs validation checks, sets up initial variables, and executes a loop or recursion to process the elements.
            3. **Edge Cases**: The code handles special bounds such as empty arrays, null pointer references, or overflow situations.
            4. **Complexity Analysis**:
               * **Time Complexity**: Designed to be efficient for the given data structure constraints.
               * **Space Complexity**: Minimizes auxiliary storage requirements to run in-place where possible.
            """
        }
        
        return baseExplanation + historySummary
    }
}
