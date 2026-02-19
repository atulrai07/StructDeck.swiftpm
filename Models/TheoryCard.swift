//
//  TheoryCard.swift
//  DSAK
//
//  Created by Atul on 30/12/25.
//
import SwiftUI

// 1. The Data Structure
struct TheoryCard: Identifiable {
    let id = UUID()
    let title: String
    let bodyText: String
    let iconName: String
    let isBridge: Bool // Marks the final "Transition" card to the visualizer
}

// 2. The Static Content (Data Source)
struct TheoryData {

    static let stackCards: [TheoryCard] = [

        // Card 1
        TheoryCard(
            title: "What is a Stack?",
            bodyText: "A Stack is a linear data structure where elements are added and removed from the same end, called the top.",
            iconName: "square.stack.3d.up.fill",
            isBridge: false
        ),

        // Card 2
        TheoryCard(
            title: "LIFO Rule",
            bodyText: "Stack follows LIFO — Last In, First Out.\n\nThe element added last is removed first.",
            iconName: "arrow.up.arrow.down",
            isBridge: false
        ),

        // Card 3
        TheoryCard(
            title: "LIFO Mental Model",
            bodyText: "Think of a stack of plates.\n\nYou can only remove the plate on the top.",
            iconName: "tray.full",
            isBridge: false
        ),

        // Card 4
        TheoryCard(
            title: "Stack Structure",
            bodyText: "A Stack has only one accessible end — the top.\n\nElements in the middle cannot be accessed directly.",
            iconName: "rectangle.stack.fill",
            isBridge: false
        ),

        // Card 5
        TheoryCard(
            title: "Push Operation",
            bodyText: "Push adds a new element to the top of the stack.\n\nAfter pushing, the new element becomes the top.",
            iconName: "arrow.up.circle.fill",
            isBridge: false
        ),

        // Card 6
        TheoryCard(
            title: "Pop Operation",
            bodyText: "Pop removes the element from the top of the stack.\n\nThe element below becomes the new top.",
            iconName: "arrow.down.circle.fill",
            isBridge: false
        ),

        // Card 7
        TheoryCard(
            title: "Peek Operation",
            bodyText: "Peek lets you view the top element without removing it.\n\nThe stack remains unchanged.",
            iconName: "eye.fill",
            isBridge: false
        ),

        // Card 8
        TheoryCard(
            title: "Stack Constraints",
            bodyText: "You cannot pop from an empty stack.\n\nThis condition is called Stack Underflow.",
            iconName: "exclamationmark.triangle.fill",
            isBridge: false
        ),

        // Card 9
        TheoryCard(
            title: "Why Stacks Matter",
            bodyText: "Stacks are widely used in function calls, recursion, undo/redo features, and expression evaluation.",
            iconName: "function",
            isBridge: false
        ),

        // Card 10
        TheoryCard(
            title: "Stacks in Programming",
            bodyText: "Stacks help manage the order of execution and store temporary data during program execution.",
            iconName: "chevron.left.forwardslash.chevron.right",
            isBridge: false
        ),

        // Card 11
        TheoryCard(
            title: "Time Complexity",
            bodyText: "Push, Pop, and Peek operations usually take constant time — O(1).",
            iconName: "clock.fill",
            isBridge: false
        ),

        // Card 12 (Bridge to Quiz)
        TheoryCard(
            title: "Time for a Quiz!",
            bodyText: "You now understand how a Stack works.\n\nLet’s check your understanding with a quick quiz.",
            iconName: "pencil.and.list.clipboard",
            isBridge: true
        )
    ]
    
    static let queueCards: [TheoryCard] = [
            // Card 1
            TheoryCard(
                title: "What is a Queue?",
                bodyText: "A Queue is a linear data structure where elements are added at one end and removed from the other.",
                iconName: "tray.2.fill",
                isBridge: false
            ),
            // Card 2
            TheoryCard(
                title: "FIFO Rule",
                bodyText: "Queue follows FIFO – First In, First Out.\n\nThe element added first is the one removed first.",
                iconName: "arrow.right.to.line",
                isBridge: false
            ),
            // Card 3
            TheoryCard(
                title: "FIFO Mental Model",
                bodyText: "Think of a line at a ticket counter.\n\nThe person who arrives first is served first. New people join at the back.",
                iconName: "person.3.sequence.fill",
                isBridge: false
            ),
            // Card 4
            TheoryCard(
                title: "Queue Structure",
                bodyText: "A Queue has two open ends:\n\nFront: Where elements are removed.\nRear: Where new elements are added.",
                iconName: "arrow.left.and.right",
                isBridge: false
            ),
            // Card 5
            TheoryCard(
                title: "Enqueue Operation",
                bodyText: "Enqueue adds a new element to the Rear of the queue.\n\nThe queue grows from the back.",
                iconName: "plus.circle.fill",
                isBridge: false
            ),
            // Card 6
            TheoryCard(
                title: "Dequeue Operation",
                bodyText: "Dequeue removes an element from the Front of the queue.\n\nThe next element in line moves up.",
                iconName: "minus.circle.fill",
                isBridge: false
            ),
            // Card 7
            TheoryCard(
                title: "Peek Operation",
                bodyText: "Peek lets you view the Front element without removing it.\n\nThe queue remains unchanged.",
                iconName: "eye.fill",
                isBridge: false
            ),
            // Card 8
            TheoryCard(
                title: "Queue Constraints",
                bodyText: "You cannot dequeue from an empty queue.\n\nJust like stacks, this error is called Queue Underflow.",
                iconName: "exclamationmark.triangle.fill",
                isBridge: false
            ),
            // Card 9
            TheoryCard(
                title: "Advanced Queues",
                bodyText: "Beyond simple queues, there are Circular Queues, Priority Queues, and Deques (Double-Ended Queues).",
                iconName: "arrow.triangle.2.circlepath",
                isBridge: false
            ),
            // Card 10
            TheoryCard(
                title: "Why Queues Matter",
                bodyText: "Queues are essential for printer tasks, CPU task scheduling, and handling requests in web servers.",
                iconName: "printer.fill",
                isBridge: false
            ),
            // Card 11
            TheoryCard(
                title: "Time Complexity",
                bodyText: "Enqueue, Dequeue, and Peek operations are highly efficient.\n\nThey usually take constant time - O(1).",
                iconName: "clock.fill",
                isBridge: false
            ),
            // Card 12 (Bridge to Visualizer)
            TheoryCard(
                title: "Time to Build",
                bodyText: "You understand the logic.\n\nNow let’s see how a Queue behaves step by step and how it’s written in Java code.",
                iconName: "swift",
                isBridge: true
            )
        ]
    
    static let linkedListCards: [TheoryCard] = [
            // Card 1
            TheoryCard(
                title: "What is a Linked List?",
                bodyText: "A Linked List is a chain of 'nodes'. Unlike arrays, elements are not stored next to each other in memory.",
                iconName: "link",
                isBridge: false
            ),
            // Card 2
            TheoryCard(
                title: "Memory Layout",
                bodyText: "Arrays need a solid block of memory. Linked Lists are scattered; each node points to the next one.",
                iconName: "square.grid.3x3.fill", // scattered vs block
                isBridge: false
            ),
            // Card 3
            TheoryCard(
                title: "The Node Anatomy",
                bodyText: "Each node has two parts:\n1. Data (The Value)\n2. Next (Pointer to the next address)",
                iconName: "externaldrive.fill.badge.plus",
                isBridge: false
            ),
            // Card 4
            TheoryCard(
                title: "Head & Tail",
                bodyText: "Head: The start of the list.\nTail: The end, which points to NULL (nothing).",
                iconName: "dumbbell.fill",
                isBridge: false
            ),
            // Card 5
            TheoryCard(
                title: "Dynamic Sizing",
                bodyText: "Arrays have a fixed size. Linked Lists can grow or shrink instantly by changing pointers.",
                iconName: "arrow.up.left.and.down.right.and.arrow.up.right.and.down.left",
                isBridge: false
            ),
            // Card 6
            TheoryCard(
                title: "Traversal",
                bodyText: "To find an item, you must start at the Head and follow the pointers one by one. No random access!",
                iconName: "figure.walk",
                isBridge: false
            ),
            // Card 7
            TheoryCard(
                title: "Insertion",
                bodyText: "Adding a node is fast. You just change the 'Next' pointer of the previous node to the new one.",
                iconName: "plus.circle.fill",
                isBridge: false
            ),
            // Card 8
            TheoryCard(
                title: "Deletion",
                bodyText: "Removing a node is simple: Just reroute the pointer of the previous node to skip the deleted one.",
                iconName: "minus.circle.fill",
                isBridge: false
            ),
            // Card 9
            TheoryCard(
                title: "Types of Lists",
                bodyText: "Singly: One-way pointers.\nDoubly: Two-way pointers (Next & Previous).\nCircular: Tail points back to Head.",
                iconName: "arrow.triangle.2.circlepath",
                isBridge: false
            ),
            // Card 10
            TheoryCard(
                title: "The Trade-off",
                bodyText: "Pros: Dynamic size, easy insertion.\nCons: Slow lookup (O(n)), extra memory for pointers.",
                iconName: "scalemass.fill",
                isBridge: false
            ),
            // Card 11
            TheoryCard(
                title: "Time Complexity",
                bodyText: "Access: O(n) (Slow)\nInsert/Delete at Head: O(1) (Super Fast)",
                iconName: "clock.fill",
                isBridge: false
            ),
            // Card 12 (Bridge)
            TheoryCard(
                title: "Time to Build",
                bodyText: "Let's connect some nodes visually and see how the pointers actually update in code.",
                iconName: "swift",
                isBridge: true
            )
        ]
    
    static let binaryTreeCards: [TheoryCard] = [
        // Card 1
        TheoryCard(
            title: "Beyond the Line",
            bodyText: "Arrays and Linked Lists are linear (one after another). Binary Trees are hierarchical (like a family tree).",
            iconName: "network",
            isBridge: false
        ),
        // Card 2
        TheoryCard(
            title: "What is a Binary Tree?",
            bodyText: "It is a data structure made of nodes. 'Binary' means each node has at most two children: Left and Right.",
            iconName: "arrow.triangle.branch",
            isBridge: false
        ),
        
        // Card 3
        TheoryCard(
            title: "The Root",
            bodyText: "The topmost node is the Root. It is the only node without a parent. Everything starts here.",
            iconName: "crown.fill", // King/Top
            isBridge: false
        ),
        // Card 4
        TheoryCard(
            title: "Parent & Child",
            bodyText: "If Node A points to Node B:\n• A is the Parent\n• B is the Child\nNodes share a family-like relationship.",
            iconName: "figure.2.and.child.holdinghands",
            isBridge: false
        ),
        // Card 5
        TheoryCard(
            title: "Leaf Nodes",
            bodyText: "Nodes at the very bottom with NO children are called Leaves. They connect to nothing (NULL).",
            iconName: "leaf.fill",
            isBridge: false
        ),
        // Card 6
        TheoryCard(
            title: "Subtrees",
            bodyText: "Every child node is effectively the 'Root' of its own smaller tree, called a Subtree.",
            iconName: "square.grid.3x1.below.line.grid.1x2",
            isBridge: false
        ),
        
        // Card 7
        TheoryCard(
            title: "Depth & Height",
            bodyText: "Depth: How far a node is from the Root.\nHeight: How far the Root is from the deepest Leaf.",
            iconName: "ruler.fill",
            isBridge: false
        ),
        
        // Card 8
        TheoryCard(
            title: "Binary Search Tree (BST)",
            bodyText: "A special type of Binary Tree where data is sorted organized to make searching fast.",
            iconName: "magnifyingglass.circle.fill",
            isBridge: false
        ),
        // Card 9
        TheoryCard(
            title: "The Golden Rule: Left",
            bodyText: "In a BST, any value SMALLER than the parent goes to the LEFT child.",
            iconName: "arrow.down.left",
            isBridge: false
        ),
        // Card 10
        TheoryCard(
            title: "The Golden Rule: Right",
            bodyText: "In a BST, any value LARGER than the parent goes to the RIGHT child.",
            iconName: "arrow.down.right",
            isBridge: false
        ),
        
        // Card 11
        TheoryCard(
            title: "Traversing the Tree",
            bodyText: "Since it's not a straight line, we need rules to visit every node. These rules are called Traversals.",
            iconName: "figure.walk",
            isBridge: false
        ),
        // Card 12
        TheoryCard(
            title: "In-Order Traversal",
            bodyText: "Left → Root → Right.\n\nResult: Use this to get sorted data from a BST (e.g., 1, 2, 3).",
            iconName: "text.line.first.and.arrowtriangle.forward",
            isBridge: false
        ),
        // Card 13
        TheoryCard(
            title: "Pre-Order Traversal",
            bodyText: "Root → Left → Right.\n\nResult: Good for copying a tree structure exactly.",
            iconName: "arrow.up.and.down.and.arrow.left.and.right",
            isBridge: false
        ),
        // Card 14
        TheoryCard(
            title: "Post-Order Traversal",
            bodyText: "Left → Right → Root.\n\nResult: Good for deleting a tree (delete children first, then parent).",
            iconName: "trash.fill",
            isBridge: false
        ),
        
        // Card 15
        TheoryCard(
            title: "Balanced vs Skewed",
            bodyText: "A balanced tree is efficient O(log n). A 'skewed' tree looks like a line and is slow O(n).",
            iconName: "scalemass.fill",
            isBridge: false
        ),
        // Card 16
        TheoryCard(
            title: "Real World Uses",
            bodyText: "Used in Database indexing, File Systems, and Auto-complete suggestions.",
            iconName: "server.rack",
            isBridge: false
        ),
        // Card 17 (Bridge)
        TheoryCard(
                title: "Time to Build",
                bodyText: "Enough theory. Let's plant some nodes and watch the tree grow dynamically.",
                iconName: "swift",
                isBridge: true
            )
        ]
}
