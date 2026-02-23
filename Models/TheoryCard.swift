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
            bodyText: "A Queue is a linear data structure that operates sequentially.\n\nUnlike arrays where you can access any element at any time, a queue strictly enforces exactly where data enters and where it exits.",
            iconName: "tray.2.fill",
            isBridge: false
        ),
        // Card 2
        TheoryCard(
            title: "FIFO Rule",
            bodyText: "Queues strictly follow the FIFO principle:\n\n• First In\n• First Out\n\nThe absolute oldest element in the structure is always the very next one to be removed.",
            iconName: "arrow.right.to.line",
            isBridge: false
        ),
        // Card 3
        TheoryCard(
            title: "FIFO Mental Model",
            bodyText: "Think of a physical line at a coffee shop or a movie theater.\n\n• The person who arrives first gets served first.\n• Anyone new who arrives must join at the very back of the line.",
            iconName: "person.3.sequence.fill",
            isBridge: false
        ),
        // Card 4
        TheoryCard(
            title: "Queue Structure",
            bodyText: "A Queue operates using two distinct open ends:\n\n• Front (Head): The exit point where elements are removed.\n• Rear (Tail): The entry point where new elements join the queue.",
            iconName: "arrow.left.and.right",
            isBridge: false
        ),
        // Card 5
        TheoryCard(
            title: "Enqueue Operation",
            bodyText: "The act of adding data is called 'Enqueue'.\n\nWhen you Enqueue an item, it is strictly placed at the Rear of the queue. It must patiently wait for all elements ahead of it to be processed.",
            iconName: "plus.circle.fill",
            isBridge: false
        ),
        // Card 6
        TheoryCard(
            title: "Dequeue Operation",
            bodyText: "The act of removing data is called 'Dequeue'.\n\nWhen you Dequeue, you strictly remove the item currently at the Front. The item immediately behind it then shifts up to become the new Front.",
            iconName: "minus.circle.fill",
            isBridge: false
        ),
        // Card 7
        TheoryCard(
            title: "Peek Operation",
            bodyText: "Need to know who is next in line without actually serving them?\n\nThe 'Peek' (or Front) operation looks at the element currently at the Front of the queue without removing it or altering the structure.",
            iconName: "eye.fill",
            isBridge: false
        ),
        // Card 8
        TheoryCard(
            title: "Queue Constraints",
            bodyText: "Queues have limits based on their environment.\n\n• Underflow: Trying to Dequeue from a completely empty queue.\n• Overflow: Trying to Enqueue into a queue that has reached its maximum memory capacity.",
            iconName: "exclamationmark.triangle.fill",
            isBridge: false
        ),
        // Card 9
        TheoryCard(
            title: "Advanced Queues",
            bodyText: "Standard queues are just the beginning. Advanced variations include:\n\n• Priority Queues: VIP elements bypass the line based on importance.\n• Circular Queues: The rear connects back to the front to save memory.\n• Deques: Double-ended queues allow adding/removing from both sides.",
            iconName: "arrow.triangle.2.circlepath",
            isBridge: false
        ),
        // Card 10
        TheoryCard(
            title: "Why Queues Matter",
            bodyText: "Queues power asynchronous background tasks in modern computing:\n\n• Printer spooling (printing documents in exact order).\n• CPU task scheduling.\n• Handling traffic surges on Web Servers without dropping requests.",
            iconName: "printer.fill",
            isBridge: false
        ),
        // Card 11
        TheoryCard(
            title: "Time Complexity",
            bodyText: "Because we always know exactly where the Front and Rear pointers are, queue operations are incredibly fast.\n\n• Enqueue: O(1) constant time\n• Dequeue: O(1) constant time\n• Peek: O(1) constant time",
            iconName: "clock.fill",
            isBridge: false
        ),
        // Card 12 (Bridge to Visualizer)
        TheoryCard(
            title: "Time to Build",
            bodyText: "You understand the theory, now it's time for practice.\n\nStep into the interactive visualizer to Enqueue and Dequeue elements in real-time, and watch how the underlying Java code adapts.",
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
            bodyText: "Unlike Arrays and Linked Lists which store data sequentially.\n\nBinary Trees organize data hierarchically, exactly like a family tree or a corporate organization chart.",
            iconName: "network",
            isBridge: false
        ),
        // Card 2
        TheoryCard(
            title: "What is a Binary Tree?",
            bodyText: "A non-linear data structure made of interconnected nodes.\n\n'Binary' means every node is strictly limited to at most two children:\n• Left Child\n• Right Child",
            iconName: "arrow.triangle.branch",
            isBridge: false
        ),
        
        // Card 3
        TheoryCard(
            title: "The Root",
            bodyText: "The topmost node is called the Root.\n\n• It serves as the single entry point.\n• It is the only node without a parent.\n• Every traversal starts here.",
            iconName: "crown.fill", // King/Top
            isBridge: false
        ),
        // Card 4
        TheoryCard(
            title: "Parent & Child",
            bodyText: "Nodes share a family-like relationship.\n\nIf Node A connects down to Node B:\n• Node A is the Parent\n• Node B is the Child\n\nA child only ever has one parent.",
            iconName: "figure.2.and.child.holdinghands",
            isBridge: false
        ),
        // Card 5
        TheoryCard(
            title: "Leaf Nodes",
            bodyText: "Nodes positioned at the very bottom edges are called Leaves.\n\nA node is a Leaf if it has absolutely no children (both left and right pointers are NULL).",
            iconName: "leaf.fill",
            isBridge: false
        ),
        // Card 6
        TheoryCard(
            title: "Subtrees",
            bodyText: "Trees are inherently recursive.\n\nEvery child node acts as the 'Root' of its own independent smaller tree.\n\nThese nested structures are called Left and Right Subtrees.",
            iconName: "square.grid.3x1.below.line.grid.1x2",
            isBridge: false
        ),
        
        // Card 7
        TheoryCard(
            title: "Depth & Height",
            bodyText: "These measure the tree's scale:\n\n• Depth: Number of edges from Root down to a node.\n• Height: Longest path from Root to the deepest Leaf.",
            iconName: "ruler.fill",
            isBridge: false
        ),
        
        // Card 8
        TheoryCard(
            title: "Binary Search Tree",
            bodyText: "A Binary Search Tree (BST) is a powerful variant where data is strictly ordered.\n\nThis built-in sorting logic dramatically reduces search times, making it incredibly fast to find specific values.",
            iconName: "magnifyingglass.circle.fill",
            isBridge: false
        ),
        // Card 9
        TheoryCard(
            title: "The Golden Rule: Left",
            bodyText: "The first rule of a BST:\n\nEvery value in the Left Subtree must be strictly LESS than the parent node.\n\nThis allows algorithms to instantly ignore half the tree when searching for smaller numbers.",
            iconName: "arrow.down.left",
            isBridge: false
        ),
        // Card 10
        TheoryCard(
            title: "The Golden Rule: Right",
            bodyText: "The second rule of a BST:\n\nEvery value in the Right Subtree must be strictly GREATER than the parent node.\n\nThis binary decision makes finding large numbers highly efficient.",
            iconName: "arrow.down.right",
            isBridge: false
        ),
        
        // Card 11
        TheoryCard(
            title: "Traversing the Tree",
            bodyText: "Since a tree isn't a straight line, you cannot simply loop from start to finish.\n\nWe use specific rules called 'Traversals' to guarantee that we visit every node exactly once.",
            iconName: "figure.walk",
            isBridge: false
        ),
        // Card 12
        TheoryCard(
            title: "In-Order Traversal",
            bodyText: "Order: Left → Root → Right\n\nResult:\nWhen used on a BST, this outputs data in perfect, ascending sorted order (e.g., 1, 2, 3).",
            iconName: "text.line.first.and.arrowtriangle.forward",
            isBridge: false
        ),
        // Card 13
        TheoryCard(
            title: "Pre-Order Traversal",
            bodyText: "Order: Root → Left → Right\n\nResult:\nIdeal for cloning or creating an exact structural copy of a binary tree.",
            iconName: "arrow.up.and.down.and.arrow.left.and.right",
            isBridge: false
        ),
        // Card 14
        TheoryCard(
            title: "Post-Order Traversal",
            bodyText: "Order: Left → Right → Root\n\nResult:\nSafest way to delete a tree (it deletes children first, then the parent).",
            iconName: "trash.fill",
            isBridge: false
        ),
        
        // Card 15
        TheoryCard(
            title: "Balanced vs Skewed",
            bodyText: "Balanced Tree:\nSplits data evenly. Lightning-fast O(log n).\n\nSkewed Tree:\nNodes pile on one side. Sluggish O(n) (like a linked list).",
            iconName: "scalemass.fill",
            isBridge: false
        ),
        // Card 16
        TheoryCard(
            title: "Real World Uses",
            bodyText: "Trees power modern computing:\n\n• Database Indexing (B-Trees)\n• File Systems (Folders/Files)\n• Auto-complete (Tries)",
            iconName: "server.rack",
            isBridge: false
        ),
        // Card 17 (Bridge)
        TheoryCard(
                title: "Time to Build",
                bodyText: "Enough theory, let's practice.\n\nGet ready to plant root nodes, define branches, and visualize how a Binary Tree grows in real-time.",
                iconName: "swift",
                isBridge: true
            )
        ]
}
