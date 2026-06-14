//
//  TheoryCard.swift
//  DSAK
//
//  Created by Atul on 30/12/25.
//
import SwiftUI

// The Data Structure
struct TheoryCard: Identifiable {
    let id = UUID()
    let title: String
    let bodyText: String
    let iconName: String
    let isBridge: Bool
}

// The Static Content (Data Source)
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
            bodyText: "Stack follows LIFO   Last In, First Out.\n\nThe element added last is removed first.",
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
            bodyText: "A Stack has only one accessible end   the top.\n\nElements in the middle cannot be accessed directly.",
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
            bodyText: "Push, Pop, and Peek operations usually take constant time   O(1).",
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
                iconName: "square.grid.3x3.fill",
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
    
    static let dijkstraCards: [TheoryCard] = [
            TheoryCard(
                title: "What is Dijkstra's Algorithm?",
                bodyText: "It's an algorithm used to find the shortest path from a starting node to all other nodes in a weighted graph.\n\nUnlike simple searches that just count the number of steps, Dijkstra accounts for the 'cost' or 'weight' of moving from one node to another. Think of it like a GPS finding the fastest route by avoiding heavy traffic.",
                iconName: "point.topleft.down.curvedto.point.bottomright.up",
                isBridge: false
            ),
            TheoryCard(
                title: "Graphs & Weights",
                bodyText: "A graph is made of 'nodes' (intersections) and 'edges' (roads connecting them).\n\nIn Dijkstra, these edges have 'weights' or costs like distance, time, or toll fees. The goal is to find the path with the absolute lowest total weight.",
                iconName: "point.3.connected.trianglepath.dotted",
                isBridge: false
            ),
            TheoryCard(
                title: "Tracking Distances",
                bodyText: "Before starting, the algorithm creates a scorecard. The distance to the starting node is set to 0, because you're already there.\n\nThe distance to every other node is initially set to infinity (∞). It assumes they are unreachable until a path to them is actually discovered.",
                iconName: "tablecells",
                isBridge: false
            ),
            TheoryCard(
                title: "The Greedy Choice",
                bodyText: "Dijkstra uses a 'greedy' approach. At every step, it blindly picks the closest unvisited node to explore next.\n\nBecause all edge weights must be positive (you can't travel negative miles), once it locks in the shortest path to a node, it knows it will never find a shorter detour later.",
                iconName: "hands.sparkles.fill",
                isBridge: false
            ),
            TheoryCard(
                title: "Edge Relaxation",
                bodyText: "The core mechanic of Dijkstra is 'Relaxation'. When it visits a node, it checks all of its neighbors.\n\nIf the current node's distance plus the edge weight is LESS than the neighbor's currently known distance, it 'relaxes' (updates) the neighbor's distance to this new, lower value.",
                iconName: "arrow.down.right.and.arrow.up.left",
                isBridge: false
            ),
            TheoryCard(
                title: "The Visited Set",
                bodyText: "Once the algorithm has explored all outgoing edges from a node, it marks that node as 'Visited'.\n\nThis is a crucial step. It locks in the shortest distance to that node and ensures the algorithm doesn't get trapped going in circles or re-calculating finalized paths.",
                iconName: "checkmark.seal.fill",
                isBridge: false
            ),
            TheoryCard(
                title: "The Priority Queue",
                bodyText: "To efficiently find the 'closest unvisited node', Dijkstra typically relies on a Priority Queue (or Min-Heap) data structure.\n\nInstead of checking every single unvisited node one by one, the Priority Queue automatically keeps the node with the lowest distance right at the front, speeding up the process massively.",
                iconName: "list.number",
                isBridge: false
            ),
            TheoryCard(
                title: "Reconstructing the Path",
                bodyText: "Finding the lowest distance is great, but what if you need the actual turn-by-turn directions?\n\nDijkstra keeps a 'Previous Node' tracker. Whenever it successfully relaxes an edge, it notes which node it came from. Once at the destination, it simply backtracks these steps to build the route.",
                iconName: "arrow.uturn.backward",
                isBridge: false
            ),
            TheoryCard(
                title: "The Achilles Heel",
                bodyText: "Dijkstra is brilliant, but it has a fatal flaw: it cannot handle negative edge weights.\n\nBecause its greedy logic aggressively locks in nodes assuming costs will only ever increase, negative weights break its math. For graphs with negative costs, the Bellman-Ford algorithm is used instead.",
                iconName: "exclamationmark.triangle.fill",
                isBridge: false
            ),
            TheoryCard(
                title: "Time to Build",
                bodyText: "Let's interact with the graph visualizer to see Dijkstra's Algorithm dynamically finding the shortest path.",
                iconName: "swift",
                isBridge: true
            )
        ]
        
    static let bfsCards: [TheoryCard] = [
        TheoryCard(
            title: "What is BFS?",
            bodyText: "Breadth-First Search (BFS) is an algorithm that explores a graph or tree level by level. It visits all immediate neighbors of a node before moving deeper.\n\nImagine dropping a stone in a pond: the ripples expand outward evenly in all directions. That's exactly how BFS searches.",
            iconName: "arrow.up.and.down.and.arrow.left.and.right",
            isBridge: false
        ),
        TheoryCard(
            title: "Trees vs. Graphs",
            bodyText: "In a hierarchical tree structure, BFS simply reads top-to-bottom, left-to-right (often called 'Level Order Traversal').\n\nIn a complex graph, however, lines can cross and loop back. BFS must adapt to handle these interconnected webs without getting lost.",
            iconName: "point.3.connected.trianglepath.dotted",
            isBridge: false
        ),
        TheoryCard(
            title: "The Queue (FIFO)",
            bodyText: "To maintain its strict 'level-by-level' order, BFS relies on a Queue data structure. [Image of a FIFO queue data structure]\n\nA Queue follows the First-In-First-Out (FIFO) principle just like waiting in line at a grocery store. The first node added to the line is the first one to be explored.",
            iconName: "tray.2.fill",
            isBridge: false
        ),
        TheoryCard(
            title: "The Enqueue Step",
            bodyText: "When BFS visits a node, it looks at all of its immediate neighbors. It 'enqueues' (adds) these neighbors to the back of the queue.\n\nOnce all neighbors are added, the current node is done. BFS then 'dequeues' the next node from the very front of the line and repeats the process.",
            iconName: "person.line.dotted.person.fill",
            isBridge: false
        ),
        TheoryCard(
            title: "The Visited Set",
            bodyText: "Just like Dijkstra, BFS in a graph must use a 'Visited' set to keep track of where it has already been.\n\nWithout this, a simple cycle (A points to B, B points to A) would cause BFS to bounce back and forth forever, adding nodes to the queue infinitely.",
            iconName: "checkmark.seal.fill",
            isBridge: false
        ),
        TheoryCard(
            title: "Tracking Levels",
            bodyText: "BFS is excellent at counting 'hops'. By keeping a dictionary of distances, every time it discovers a new neighbor, it sets that neighbor's distance to `current_node_distance + 1`.\n\nThis maps out exactly how many steps away every node is from the starting point.",
            iconName: "list.number",
            isBridge: false
        ),
        TheoryCard(
            title: "The Shortest Path Guarantee",
            bodyText: "Because it expands uniformly, BFS is mathematically guaranteed to find the absolute shortest path between two points but ONLY on an unweighted graph.\n\nIf all edges have the same cost, the very first time BFS stumbles upon your destination, you know for a fact there is no shorter route.",
            iconName: "ruler.fill",
            isBridge: false
        ),
        TheoryCard(
            title: "The Space Problem",
            bodyText: "BFS has a major weakness: Memory space. [Image of Breadth First Search level by level traversal]\n\nBecause it must store an entire 'level' of the graph in its queue before moving on, a massive, highly-connected graph (like Facebook's user network) will cause the queue to grow exponentially large, consuming huge amounts of RAM.",
            iconName: "memorychip",
            isBridge: false
        ),
        TheoryCard(
            title: "Time Complexity & Use Cases",
            bodyText: "The Time Complexity is O(V + E) because it visits every vertex and explores every edge once in the worst case.\n\nReal-world applications include finding the 'degrees of separation' on social networks, peer-to-peer network broadcasting, and GPS navigation on unweighted grids.",
            iconName: "network",
            isBridge: false
        ),
        TheoryCard(
            title: "Time to Build",
            bodyText: "Let's interact with the tree visualizer to see Breadth-First Search in action.",
            iconName: "swift",
            isBridge: true
        )
    ]
    
    static let dfsCards: [TheoryCard] = [
        TheoryCard(
            title: "What is DFS?",
            bodyText: "Depth-First Search (DFS) is a bold explorer. It dives as deep as possible down a single branch before it stops and turns around.\n\nThink of it like navigating a physical maze: you keep walking down a hallway until you hit a dead end, then you backtrack to the last intersection and try a different route.",
            iconName: "arrow.down.to.line",
            isBridge: false
        ),
        TheoryCard(
            title: "Plunging into the Depths",
            bodyText: "Unlike BFS, which carefully surveys its immediate surroundings, DFS picks one neighbor and immediately jumps to it.\n\nIt ignores the rest of the starting node's neighbors until it has completely explored the entire lineage of that first chosen path.",
            iconName: "arrow.uturn.down",
            isBridge: false
        ),
        TheoryCard(
            title: "The Stack (LIFO)",
            bodyText: "DFS relies on a Stack data structure, which follows the Last-In-First-Out (LIFO) principle. [Image of a LIFO stack data structure]\n\nThink of a stack of plates: you add plates to the top, and you pull the next plate to use from the top. The most recently discovered node is always the next one explored.",
            iconName: "square.stack.3d.up.fill",
            isBridge: false
        ),
        TheoryCard(
            title: "Recursion Elegance",
            bodyText: "While you can build a Stack manually, DFS is most commonly written using Recursion.\n\nA recursive function calls itself. The computer's built-in 'call stack' automatically remembers where it left off, making the code incredibly short and elegant.",
            iconName: "arrow.triangle.2.circlepath.camera",
            isBridge: false
        ),
        TheoryCard(
            title: "The Art of Backtracking",
            bodyText: "When DFS hits a 'leaf' node (a node with no unvisited neighbors), it has reached a dead end.\n\nIt then 'pops' that node off the stack, returning to the previous node to see if it has any other unexplored branches. This process of reversing steps is called Backtracking.",
            iconName: "arrow.uturn.backward",
            isBridge: false
        ),
        TheoryCard(
            title: "Cycle Prevention",
            bodyText: "Just like BFS, DFS needs a 'Visited' set when dealing with graphs. [Image of Depth First Search going down a single branch]\n\nBecause it dives recklessly deep, an infinite loop in DFS is disastrous. It will circle endlessly until the program crashes from a 'Stack Overflow' (running out of memory to store the backtracking steps).",
            iconName: "exclamationmark.triangle.fill",
            isBridge: false
        ),
        TheoryCard(
            title: "Memory Efficiency",
            bodyText: "The massive advantage of DFS over BFS is Space Complexity.\n\nDFS only needs to remember the single path it is currently walking down (up to the maximum depth, or 'height' of the tree). It uses far less RAM than BFS, which has to memorize entire wide levels of nodes.",
            iconName: "cpu",
            isBridge: false
        ),
        TheoryCard(
            title: "Finding Paths (But Not Shortest)",
            bodyText: "DFS can easily answer the question: 'Is there a path from A to B?'\n\nHowever, because it blindly sprints down the first path it sees, the route it finds is rarely the shortest. It might take a massive, winding detour just because that was the first branch it checked.",
            iconName: "point.topleft.down.curvedto.point.bottomright.up",
            isBridge: false
        ),
        TheoryCard(
            title: "Time Complexity & Use Cases",
            bodyText: "Like BFS, the Time Complexity for DFS is O(V + E) since it visits every vertex and edge.\n\nDFS shines at Topological Sorting (ordering tasks with dependencies), solving puzzles like Sudoku/mazes, and detecting cycles in a network.",
            iconName: "puzzlepiece.extension.fill",
            isBridge: false
        ),
        TheoryCard(
            title: "Time to Build",
            bodyText: "Let's interact with the tree visualizer to see Depth-First Search in action.",
            iconName: "swift",
            isBridge: true
        )
    ]
}
