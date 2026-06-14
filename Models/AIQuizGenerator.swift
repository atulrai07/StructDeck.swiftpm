//
//  AIQuizGenerator.swift
//  StructViz
//
//  Created by Atul on 12/06/26.
//

import SwiftUI
#if canImport(FoundationModels)
import FoundationModels
#endif

#if canImport(FoundationModels)
@available(iOS 26.0, *)
@Generable
struct AIGeneratedQuestion {
    let question: String
    
    @Guide(.count(4))
    let options: [String]
    
    @Guide(.range(0...3))
    let correctAnswerIndex: Int
    
    let explanation: String
}

@available(iOS 26.0, *)
@Generable
struct AIGeneratedQuiz {
    @Guide(.count(5))
    let questions: [AIGeneratedQuestion]
}
#endif

@MainActor
class AIQuizGenerator: ObservableObject {
    static let shared = AIQuizGenerator()
    
    @Published var isSupported: Bool = false
    @Published var isUsingMock: Bool = false
    
    private init() {
        checkSupport()
    }
    
    func checkSupport() {
        #if canImport(FoundationModels)
        if #available(iOS 26.0, *) {
            let availability = SystemLanguageModel.default.availability
            print("✨ [AIQuizGenerator] Apple Intelligence Availability Check: \(availability)")
            switch availability {
            case .available:
                self.isSupported = true
                self.isUsingMock = false
            case .unavailable(let reason):
                print("⚠️ [AIQuizGenerator] Apple Intelligence unavailable. Reason: \(reason). Enabling Mock/Demo fallback.")
                self.isSupported = true
                self.isUsingMock = true
            @unknown default:
                self.isSupported = true
                self.isUsingMock = true
            }
        } else {
            print("⚠️ [AIQuizGenerator] iOS version below 26.0. Enabling Mock/Demo fallback.")
            self.isSupported = true
            self.isUsingMock = true
        }
        #else
        print("⚠️ [AIQuizGenerator] FoundationModels framework not available. Enabling Mock/Demo fallback.")
        self.isSupported = true
        self.isUsingMock = true
        #endif
    }
    
    func checkAvailability() -> Bool {
        if isUsingMock {
            return true
        }
        #if canImport(FoundationModels)
        if #available(iOS 26.0, *) {
            let availability = SystemLanguageModel.default.availability
            switch availability {
            case .available:
                return true
            default:
                return false
            }
        }
        #endif
        return false
    }
    
    func generateQuiz(for topic: String, context: String) async throws -> [QuizQuestion] {
        if isUsingMock {
            // Simulate processing time for a realistic AI generation experience
            try? await Task.sleep(nanoseconds: 1_200_000_000)
            return generateMockQuiz(for: topic)
        }
        
        #if canImport(FoundationModels)
        if #available(iOS 26.0, *) {
            let instructions = """
            You are an expert Computer Science professor specializing in Data Structures and Algorithms.
            Generate a multiple-choice quiz with exactly 5 questions on the topic: "\(topic)".
            Context/Focus: \(context)
            
            Requirements:
            1. Every question must have exactly 4 options.
            2. The options must be challenging, educational, and free of typos or trivial answers.
            3. The correctAnswerIndex must be the correct 0-based index of the right option (0 to 3).
            4. The explanation should be concise but thoroughly explain why the correct option is right.
            """
            
            let session = LanguageModelSession(instructions: instructions)
            let prompt = "Please generate 5 unique multiple choice questions on \(topic) focusing on \(context)."
            let quiz = try await session.respond(to: prompt, generating: AIGeneratedQuiz.self)
            
            return quiz.content.questions.map { q in
                QuizQuestion(
                    question: q.question,
                    options: q.options,
                    correctAnswerIndex: q.correctAnswerIndex,
                    explanation: q.explanation
                )
            }
        } else {
            throw NSError(domain: "AIQuizGenerator", code: 2, userInfo: [NSLocalizedDescriptionKey: "iOS 26.0 or higher required"])
        }
        #else
        throw NSError(domain: "AIQuizGenerator", code: 1, userInfo: [NSLocalizedDescriptionKey: "FoundationModels framework not available"])
        #endif
    }
    
    private func generateMockQuiz(for topic: String) -> [QuizQuestion] {
        let normalizedTopic = topic.lowercased()
        
        if normalizedTopic.contains("linked list") {
            return [
                QuizQuestion(
                    question: "What is the time complexity of deleting a node from the middle of a Singly Linked List if only a pointer to that node is given?",
                    options: [
                        "O(1) by copying data from the next node",
                        "O(N) because we must traverse from head",
                        "O(log N) using binary search",
                        "Deletion is impossible without head"
                    ],
                    correctAnswerIndex: 0,
                    explanation: "Correct! If we copy the data from the next node into the current node and delete the next node, we can achieve O(1) deletion without traversing the list."
                ),
                QuizQuestion(
                    question: "How does a Doubly Linked List differ from a Singly Linked List regarding memory usage?",
                    options: [
                        "It uses less memory because it has fewer pointers",
                        "It uses the same memory",
                        "It uses more memory because each node stores two pointers (next and prev)",
                        "It stores only pointers and no actual data"
                    ],
                    correctAnswerIndex: 2,
                    explanation: "Spot on. A Doubly Linked List node has an extra 'prev' pointer, which increases the memory overhead per node by one reference size."
                ),
                QuizQuestion(
                    question: "Which of the following is a key advantage of Circular Linked Lists?",
                    options: [
                        "They have constant-time random access",
                        "Any node can be a starting point for traversal of the entire list",
                        "They do not use pointers",
                        "They are always sorted automatically"
                    ],
                    correctAnswerIndex: 1,
                    explanation: "Correct! In a circular linked list, because the last node points back to the head, you can traverse the entire list starting from any arbitrary node."
                ),
                QuizQuestion(
                    question: "What is the time complexity to reverse a Singly Linked List of size N iteratively?",
                    options: [
                        "O(1) time, O(1) space",
                        "O(N) time, O(N) space",
                        "O(N) time, O(1) space",
                        "O(N log N) time, O(1) space"
                    ],
                    correctAnswerIndex: 2,
                    explanation: "Yes! Reversing a list iteratively takes O(N) time to visit each node exactly once, and O(1) auxiliary space as we only redirect pointers in-place."
                ),
                QuizQuestion(
                    question: "When detecting a cycle in a Linked List, Floyd's Cycle-Finding Algorithm uses two pointers (slow and fast). If a cycle exists, at what speed do they run?",
                    options: [
                        "Slow moves 1 node, Fast moves 2 nodes at a time",
                        "Slow moves 2 nodes, Fast moves 3 nodes at a time",
                        "Both move at the same speed of 1 node",
                        "Fast moves backwards while Slow moves forwards"
                    ],
                    correctAnswerIndex: 0,
                    explanation: "Exactly. The slow pointer moves 1 step per iteration while the fast pointer moves 2 steps. If a cycle exists, they will eventually meet."
                )
            ]
        } else if normalizedTopic.contains("queue") {
            return [
                QuizQuestion(
                    question: "In a circular queue implemented using an array, how is the index updated when enqueuing a new element?",
                    options: [
                        "(rear + 1) / size",
                        "(rear + 1) % size",
                        "rear + 1",
                        "rear * 2"
                    ],
                    correctAnswerIndex: 1,
                    explanation: "Correct! The modulo operator (%) wraps the index back to 0 when it exceeds the array bounds, making it circular."
                ),
                QuizQuestion(
                    question: "Which queue variation allows insertion and deletion from both ends (front and rear)?",
                    options: [
                        "Circular Queue",
                        "Priority Queue",
                        "Double-Ended Queue (Deque)",
                        "Monotonic Queue"
                    ],
                    correctAnswerIndex: 2,
                    explanation: "Right! A Deque (Double-Ended Queue) supports efficient insert and delete operations at both the front and rear."
                ),
                QuizQuestion(
                    question: "What is the time complexity of the enqueue and dequeue operations in an optimized Queue?",
                    options: [
                        "O(1) for both",
                        "O(N) for both",
                        "O(1) enqueue, O(N) dequeue",
                        "O(log N) for both"
                    ],
                    correctAnswerIndex: 0,
                    explanation: "Correct! An optimized queue using pointers or front/rear indexes executes both operations in constant time O(1)."
                ),
                QuizQuestion(
                    question: "What happens when you attempt to enqueue an item into a Queue that has reached its maximum array capacity?",
                    options: [
                        "Queue Underflow",
                        "Queue Overflow",
                        "The queue automatically shrinks",
                        "The item is discarded silently"
                    ],
                    correctAnswerIndex: 1,
                    explanation: "Correct. Attempting to add elements to a full, bounded queue results in a Queue Overflow error."
                ),
                QuizQuestion(
                    question: "Which CPU scheduling algorithm commonly utilizes a standard FIFO Queue?",
                    options: [
                        "Shortest Job First (SJF)",
                        "Round Robin",
                        "First-Come, First-Served (FCFS)",
                        "Priority Scheduling"
                    ],
                    correctAnswerIndex: 2,
                    explanation: "Exactly. FCFS schedules processes in the order they arrive, which maps directly to a First-In-First-Out queue."
                )
            ]
        } else if normalizedTopic.contains("stack") {
            return [
                QuizQuestion(
                    question: "Which of the following application areas uses a Stack data structure?",
                    options: [
                        "Call stack for function calls & recursion",
                        "Printer queue management",
                        "Breadth-First Search (BFS)",
                        "Sorting large database records"
                    ],
                    correctAnswerIndex: 0,
                    explanation: "Correct! Function calls utilize a call stack to remember return addresses and local variables in a LIFO order."
                ),
                QuizQuestion(
                    question: "What is the time complexity of looking at the top element of a stack (peek operation)?",
                    options: [
                        "O(N)",
                        "O(log N)",
                        "O(1)",
                        "O(N log N)"
                    ],
                    correctAnswerIndex: 2,
                    explanation: "Correct! Checking the top element via peek only accesses the top pointer/index, taking constant time O(1)."
                ),
                QuizQuestion(
                    question: "How can you implement a Stack using two Queues?",
                    options: [
                        "By making push operation costly or pop operation costly",
                        "Stacks cannot be implemented with queues",
                        "By reversing the queue array",
                        "By sorting the queues"
                    ],
                    correctAnswerIndex: 0,
                    explanation: "Correct. By shifting elements between two queues during either push or pop, you can reverse the order of elements to mimic a stack."
                ),
                QuizQuestion(
                    question: "In arithmetic expression evaluation, which notation is also known as Prefix notation?",
                    options: [
                        "Infix",
                        "Polish Notation",
                        "Reverse Polish Notation",
                        "Postfix"
                    ],
                    correctAnswerIndex: 1,
                    explanation: "Correct! Prefix notation (operators before operands) is called Polish Notation. Postfix is Reverse Polish Notation."
                ),
                QuizQuestion(
                    question: "What is the result of evaluating the Postfix expression '3 4 + 2 *' using a stack?",
                    options: [
                        "14",
                        "11",
                        "9",
                        "24"
                    ],
                    correctAnswerIndex: 0,
                    explanation: "Correct! Push 3 and 4. Apply '+': 3 + 4 = 7. Push 7. Push 2. Apply '*': 7 * 2 = 14."
                )
            ]
        } else if normalizedTopic.contains("binary tree") || normalizedTopic.contains("tree") {
            return [
                QuizQuestion(
                    question: "What is the height of a balanced Binary Search Tree (BST) with N nodes in the worst case?",
                    options: [
                        "O(1)",
                        "O(N)",
                        "O(log N)",
                        "O(N log N)"
                    ],
                    correctAnswerIndex: 2,
                    explanation: "Correct! A balanced BST keeps its height restricted to O(log N), ensuring fast search, insertion, and deletion."
                ),
                QuizQuestion(
                    question: "Which traversal of a Binary Search Tree produces the elements in sorted ascending order?",
                    options: [
                        "Pre-order",
                        "In-order",
                        "Post-order",
                        "Level-order"
                    ],
                    correctAnswerIndex: 1,
                    explanation: "Correct! In-order traversal (Left -> Root -> Right) visits BST keys in non-decreasing sorted order."
                ),
                QuizQuestion(
                    question: "What is the maximum number of nodes in a binary tree of height 'h' (where root is height 0)?",
                    options: [
                        "2^h",
                        "2^(h+1) - 1",
                        "2^h - 1",
                        "h^2"
                    ],
                    correctAnswerIndex: 1,
                    explanation: "Correct! A fully complete binary tree of height h has 2^(h+1) - 1 total nodes."
                ),
                QuizQuestion(
                    question: "What is the relationship between the number of leaf nodes (L) and nodes with two children (D2) in any binary tree?",
                    options: [
                        "L = D2 + 1",
                        "L = D2",
                        "L = D2 - 1",
                        "L = 2 * D2"
                    ],
                    correctAnswerIndex: 0,
                    explanation: "Correct! In any binary tree, the number of leaf nodes is always one more than the number of nodes with exactly two children."
                ),
                QuizQuestion(
                    question: "Which property distinguishes an AVL Tree from a regular Binary Search Tree?",
                    options: [
                        "It is a red-black colored tree",
                        "The heights of the two child subtrees of any node differ by at most one",
                        "It only allows duplicate values on the right",
                        "It can have up to three children per node"
                    ],
                    correctAnswerIndex: 1,
                    explanation: "Correct! AVL trees are self-balancing BSTs where the balance factor (height difference of left and right subtrees) is kept between -1 and 1."
                )
            ]
        } else if normalizedTopic.contains("bfs") || normalizedTopic.contains("breadth") {
            return [
                QuizQuestion(
                    question: "Which of the following algorithms is equivalent to Breadth-First Search on a tree?",
                    options: [
                        "In-order Traversal",
                        "Level-order Traversal",
                        "Depth-First Search",
                        "Post-order Traversal"
                    ],
                    correctAnswerIndex: 1,
                    explanation: "Correct! Level-order traversal visits all nodes at the current depth level before going deeper, which is exactly how BFS operates."
                ),
                QuizQuestion(
                    question: "What is the time complexity of Breadth-First Search on a graph represented as an Adjacency List with V vertices and E edges?",
                    options: [
                        "O(V)",
                        "O(E)",
                        "O(V + E)",
                        "O(V * E)"
                    ],
                    correctAnswerIndex: 2,
                    explanation: "Correct! BFS visits each vertex once and checks all of its edges, leading to a time complexity of O(V + E)."
                ),
                QuizQuestion(
                    question: "Why is a Queue used in BFS instead of a Stack?",
                    options: [
                        "To explore the deepest paths first",
                        "To ensure nodes are visited in the order of their distance from the source",
                        "To save memory space",
                        "To sort the vertices by value"
                    ],
                    correctAnswerIndex: 1,
                    explanation: "Correct. A FIFO Queue ensures we explore all nodes at distance 'd' before moving to nodes at distance 'd + 1', guaranteeing shortest paths in unweighted graphs."
                ),
                QuizQuestion(
                    question: "In BFS, what is the standard coloring/state representation of a vertex that has been discovered but not yet fully explored?",
                    options: [
                        "White (Unvisited)",
                        "Gray (Discovered/In Queue)",
                        "Black (Fully Explored)",
                        "Red (Target Node)"
                    ],
                    correctAnswerIndex: 1,
                    explanation: "Correct! Gray represents discovered nodes that are currently waiting in the queue to have their neighbors analyzed."
                ),
                QuizQuestion(
                    question: "Which of the following problems can be solved using BFS?",
                    options: [
                        "Finding the shortest path in an unweighted graph",
                        "Cycle detection in undirected graphs",
                        "Bipartiteness check of a graph",
                        "All of the above"
                    ],
                    correctAnswerIndex: 3,
                    explanation: "Correct! BFS is versatile and can solve all these problems efficiently."
                )
            ]
        } else if normalizedTopic.contains("dfs") || normalizedTopic.contains("depth") {
            return [
                QuizQuestion(
                    question: "What is the maximum space complexity of Depth-First Search on a graph with V vertices, in the worst case (e.g., a line graph)?",
                    options: [
                        "O(1)",
                        "O(V) due to the call stack / recursion stack",
                        "O(V + E)",
                        "O(E)"
                    ],
                    correctAnswerIndex: 1,
                    explanation: "Correct! In the worst-case of a linear path graph, the recursion stack can grow to size V, resulting in O(V) space complexity."
                ),
                QuizQuestion(
                    question: "Which graph traversal technique is best suited for topological sorting of a Directed Acyclic Graph (DAG)?",
                    options: [
                        "Breadth-First Search",
                        "Dijkstra's Algorithm",
                        "Depth-First Search",
                        "Kruskal's Algorithm"
                    ],
                    correctAnswerIndex: 2,
                    explanation: "Correct! Topological sort is easily implemented by performing a DFS and pushing vertices onto a stack as they finish."
                ),
                QuizQuestion(
                    question: "During a DFS traversal on a directed graph, if we encounter an edge pointing to an ancestor in the recursion stack, what is this edge called?",
                    options: [
                        "Tree Edge",
                        "Forward Edge",
                        "Cross Edge",
                        "Back Edge"
                    ],
                    correctAnswerIndex: 3,
                    explanation: "Correct! A Back Edge points from a node to one of its ancestors in the DFS tree, indicating the presence of a cycle."
                ),
                QuizQuestion(
                    question: "Which traversal uses backtracking to visit all possible paths before reverting?",
                    options: [
                        "Breadth-First Search",
                        "Depth-First Search",
                        "Binary Search",
                        "Linear Search"
                    ],
                    correctAnswerIndex: 1,
                    explanation: "Yes! DFS dives deep into a path and backtracks to explore alternatives when it hits a dead end."
                ),
                QuizQuestion(
                    question: "What is the time complexity of DFS on a graph with V vertices and E edges represented using an Adjacency Matrix?",
                    options: [
                        "O(V + E)",
                        "O(V^2)",
                        "O(V * E)",
                        "O(E^2)"
                    ],
                    correctAnswerIndex: 1,
                    explanation: "Correct. With an adjacency matrix, we must scan an entire row of size V for each of the V vertices, taking O(V^2) time regardless of E."
                )
            ]
        } else if normalizedTopic.contains("dijkstra") {
            return [
                QuizQuestion(
                    question: "Why does Dijkstra's algorithm fail to guarantee correct results on graphs with negative edge weights?",
                    options: [
                        "It runs into an infinite loop",
                        "It uses greedy choice which cannot correct a path once a vertex is marked 'visited'",
                        "It only works on trees",
                        "It cannot compute negative sums"
                    ],
                    correctAnswerIndex: 1,
                    explanation: "Correct! Dijkstra's marks vertices as finalized (visited) and assumes their shortest path is locked. Negative weights can later decrease paths to already finalized vertices."
                ),
                QuizQuestion(
                    question: "What is the time complexity of Dijkstra's algorithm when implemented with a Binary Heap priority queue?",
                    options: [
                        "O(V^2)",
                        "O((V + E) log V)",
                        "O(V + E)",
                        "O(E log E)"
                    ],
                    correctAnswerIndex: 1,
                    explanation: "Correct! Each edge relaxation takes O(log V) time using a binary heap, resulting in a total time of O((V + E) log V)."
                ),
                QuizQuestion(
                    question: "What is the starting distance value assigned to the source vertex and all other vertices in Dijkstra's?",
                    options: [
                        "Source is 0, others are Infinity",
                        "Source is Infinity, others are 0",
                        "All vertices are 0",
                        "All vertices are Infinity"
                    ],
                    correctAnswerIndex: 0,
                    explanation: "Correct! The source vertex distance is set to 0 (its distance to itself), while all other distances are initialized to Infinity."
                ),
                QuizQuestion(
                    question: "Which of the following algorithms can find the shortest path from a single source in the presence of negative edge weights (unlike Dijkstra's)?",
                    options: [
                        "Kruskal's Algorithm",
                        "Prim's Algorithm",
                        "Bellman-Ford Algorithm",
                        "Floyd-Warshall Algorithm"
                    ],
                    correctAnswerIndex: 2,
                    explanation: "Correct! The Bellman-Ford algorithm can handle negative edge weights and detect negative weight cycles."
                ),
                QuizQuestion(
                    question: "Under what condition is Dijkstra's algorithm equivalent to Breadth-First Search (BFS)?",
                    options: [
                        "When the graph is a tree",
                        "When all edge weights are equal (or unit weight)",
                        "When the graph is directed acyclic (DAG)",
                        "When there are no cycles"
                    ],
                    correctAnswerIndex: 1,
                    explanation: "Correct! If all edge weights are identical (e.g., 1), the priority queue behaves exactly like a standard FIFO queue, matching BFS."
                )
            ]
        } else {
            return [
                QuizQuestion(
                    question: "What is the primary characteristic of a stable sorting algorithm?",
                    options: [
                        "It runs in O(N log N) in the worst case",
                        "It maintains the relative order of records with equal keys",
                        "It uses O(1) auxiliary space",
                        "It does not use recursion"
                    ],
                    correctAnswerIndex: 1,
                    explanation: "Correct! A sorting algorithm is stable if it preserves the relative order of duplicate elements after sorting."
                ),
                QuizQuestion(
                    question: "Which data structure operates on a First-In, First-Out (FIFO) basis?",
                    options: [
                        "Stack",
                        "Queue",
                        "Binary Tree",
                        "Heap"
                    ],
                    correctAnswerIndex: 1,
                    explanation: "Correct! A queue handles elements in the exact order they arrive (First-In, First-Out)."
                ),
                QuizQuestion(
                    question: "What is the average time complexity of searching for a value in a hash table?",
                    options: [
                        "O(1)",
                        "O(log N)",
                        "O(N)",
                        "O(N log N)"
                    ],
                    correctAnswerIndex: 0,
                    explanation: "Correct! A hash table offers near-instantaneous search with an average time complexity of O(1)."
                ),
                QuizQuestion(
                    question: "What does the 'Big O' notation describe?",
                    options: [
                        "The exact number of microseconds a program takes",
                        "The upper bound of the execution time or space requirement",
                        "The lower bound of the execution time",
                        "The average memory size of variables"
                    ],
                    correctAnswerIndex: 1,
                    explanation: "Correct! Big O represents the asymptotic upper bound, defining the worst-case growth rate of an algorithm."
                ),
                QuizQuestion(
                    question: "Which of the following data structures is non-linear?",
                    options: [
                        "Array",
                        "Linked List",
                        "Stack",
                        "Graph"
                    ],
                    correctAnswerIndex: 3,
                    explanation: "Correct! Graphs and trees are non-linear data structures, whereas arrays, lists, and stacks are linear."
                )
            ]
        }
    }
}
