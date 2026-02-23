//
//  QuizQuestion.swift
//  DSAK
//
//  Created by Atul on 30/12/25.
//
import SwiftUI

struct QuizQuestion: Identifiable {
    let id = UUID()
    let question: String
    let options: [String]
    let correctAnswerIndex: Int
    let explanation: String
}

struct QuizData {
    static let stackQuestions: [QuizQuestion] = [
        QuizQuestion(
            question: "Which operation removes the top element of a stack?",
            options: ["Push", "Pop", "Peek", "Insert"],
            correctAnswerIndex: 1, // Pop
            explanation: "Correct! Pop removes the item that was most recently added (LIFO)."
        ),
        QuizQuestion(
            question: "Which principle does Stack follow?",
            options: ["FIFO", "LIFO", "Random", "Priority"],
            correctAnswerIndex: 1, // LIFO
            explanation: "Spot on! Last In, First Out means the last item added is the first one handled."
        ),
        QuizQuestion(
            question: "What happens if you pop an empty stack?",
            options: ["Returns 0", "Underflow / Error", "Pushes a value", "Nothing"],
            correctAnswerIndex: 1, // Underflow
            explanation: "Exactly. You cannot remove items from an empty stack, causing a Stack Underflow."
        )
    ]
    
    static let queueQuestions: [QuizQuestion] = [
        QuizQuestion(
            question: "Which principle does a Queue follow?",
            options: ["LIFO", "FIFO", "Random", "Sorted"],
            correctAnswerIndex: 1, // FIFO
            explanation: "Correct! First In, First Out."
        ),
        QuizQuestion(
            question: "Which operation adds an item to the queue?",
            options: ["Pop", "Dequeue", "Enqueue", "Push"],
            correctAnswerIndex: 2, // Enqueue
            explanation: "Enqueue adds an element to the rear of the queue."
        ),
        QuizQuestion(
            question: "Real-world example of a Queue?",
            options: ["Stack of plates", "Ticket line", "Undo button", "Browser history"],
            correctAnswerIndex: 1, // Ticket line
            explanation: "A ticket line handles people in the order they arrive."
        )
    ]
    
    static let linkedListQuestions: [QuizQuestion] = [
        QuizQuestion(
            question: "What does a node contain?",
            options: ["Only Data", "Data & Pointer", "Index & Value", "Only Pointer"],
            correctAnswerIndex: 1, // Data & Pointer
            explanation: "Correct! A node holds the data and a reference (pointer) to the next node."
        ),
        QuizQuestion(
            question: "What does the last node point to?",
            options: ["Head", "Previous Node", "NULL", "Random Address"],
            correctAnswerIndex: 2, // NULL
            explanation: "The end of the list is marked by pointing to NULL (nothing)."
        ),
        QuizQuestion(
            question: "Benefit of Linked List over Array?",
            options: ["Faster access", "Less memory", "Dynamic size", "Cache friendly"],
            correctAnswerIndex: 2, // Dynamic size
            explanation: "Linked Lists can grow/shrink easily without reallocating a fixed block of memory."
        )
    ]

    static let binaryTreeQuestions: [QuizQuestion] = [
        // Question 1: Basics
        QuizQuestion(
            question: "Which node in a Binary Tree has no parent?",
            options: ["Leaf", "Root", "Child", "Sibling"],
            correctAnswerIndex: 1, // Root
            explanation: "Correct! The Root is the unique starting node at the top."
        ),
        // Question 2: Structure
        QuizQuestion(
            question: "What is the maximum number of children a node can have?",
            options: ["1", "2", "10", "Unlimited"],
            correctAnswerIndex: 1, // 2
            explanation: "Binary means 'two'. Nodes can have 0, 1, or 2 children."
        ),
        // Question 3: Terminology
        QuizQuestion(
            question: "What do we call a node with NO children?",
            options: ["Root", "Branch", "Leaf", "Stem"],
            correctAnswerIndex: 2, // Leaf
            explanation: "Leaf nodes are the endpoints of the tree structure."
        ),
        // Question 4: BST Logic
        QuizQuestion(
            question: "In a Binary Search Tree, where does a value SMALLER than the root go?",
            options: ["Left Child", "Right Child", "Becomes Root", "Nowhere"],
            correctAnswerIndex: 0, // Left Child
            explanation: "Smaller values go Left. Larger values go Right."
        ),
        // Question 5: Traversal
        QuizQuestion(
            question: "Which traversal visits the Root node FIRST?",
            options: ["In-Order", "Post-Order", "Pre-Order", "Level-Order"],
            correctAnswerIndex: 2, // Pre-Order
            explanation: "Pre-Order follows the path: Root → Left → Right."
        ),
        // Question 6: Analysis
        QuizQuestion(
            question: "If a tree looks like a straight line (skewed), is it efficient?",
            options: ["Yes, very fast", "No, it's slow like a list", "It creates a cycle", "Trees cannot be straight"],
            correctAnswerIndex: 1, // No
            explanation: "A skewed tree loses the benefit of binary division, degrading to O(n) speed."
        )
    ]
    
    static let dijkstraQuestions: [QuizQuestion] = [
        QuizQuestion(
            question: "What is Dijkstra's primarily used for?",
            options: ["Sorting", "Finding shortest path", "Searching trees", "Filtering arrays"],
            correctAnswerIndex: 1,
            explanation: "Dijkstra's is a pathfinding algorithm for finding the shortest path between nodes."
        ),
        QuizQuestion(
            question: "Does Dijkstra's algorithm work with negative edge weights?",
            options: ["Yes, always", "Only on acyclic graphs", "No, it fails", "Only on trees"],
            correctAnswerIndex: 2,
            explanation: "Dijkstra's greedy approach assumes weights are non-negative. Bellman-Ford is needed for negative weights."
        ),
        QuizQuestion(
            question: "Which data structure is often used to optimize Dijkstra's?",
            options: ["Stack", "Hash Map", "Priority Queue", "Linked List"],
            correctAnswerIndex: 2,
            explanation: "A min-priority queue helps efficiently fetch the next node with the smallest distance."
        )
    ]
    
    static let bfsQuestions: [QuizQuestion] = [
        QuizQuestion(
            question: "Which data structure does BFS use?",
            options: ["Stack", "Queue", "Priority Queue", "Tree"],
            correctAnswerIndex: 1,
            explanation: "BFS uses a Queue to explore neighbors level-by-level."
        ),
        QuizQuestion(
            question: "In what order does BFS explore a graph?",
            options: ["Deepest first", "Level by level", "Randomly", "Alphabetically"],
            correctAnswerIndex: 1,
            explanation: "BFS expands outward, visiting nodes level by level."
        )
    ]
    
    static let dfsQuestions: [QuizQuestion] = [
        QuizQuestion(
            question: "Which data structure does DFS use inherently?",
            options: ["Queue", "Hash Map", "Stack", "Array"],
            correctAnswerIndex: 2,
            explanation: "DFS uses a Stack (either explicitly or via the call stack with recursion)."
        ),
        QuizQuestion(
            question: "What is a common use case for DFS?",
            options: ["Shortest path in unweighted graph", "Finding connected components", "Level-order traversal", "Sorting"],
            correctAnswerIndex: 1,
            explanation: "DFS is excellent for exploring deeply to find connected components or cycles."
        )
    ]
}
