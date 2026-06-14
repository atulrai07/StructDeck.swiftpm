//
//  LinkedListVisualizerView.swift
//  DSAK
//
//  Created by Atul on 13/02/26.
//
import SwiftUI

enum LinkedListMode: String, CaseIterable {
    case singlyLinked = "Singly Linked"
    case doublyLinked = "Doubly Linked"
    case traversal = "Traversal"
    
    var icon: String {
        switch self {
        case .singlyLinked: return "arrow.right"
        case .doublyLinked: return "arrow.left.arrow.right"
        case .traversal: return "magnifyingglass"
        }
    }
}

struct LinkedListVisualizerView: View {
    @Environment(\.dismiss) var dismiss
    @State private var listItems: [Int] = []
    @State private var codeHistory: [String] = ["LinkedList<Integer> list = new LinkedList<>();"]
    
    // Mode & Animation
    @State private var currentMode: LinkedListMode = .singlyLinked
    @State private var highlightedIndex: Int? = nil
    @State private var isAnimating: Bool = false
    @State private var isPaused: Bool = false
    @State private var traversalComplete: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                canvasView
                    .frame(minHeight: 180)
                
                controlButtons
                
                ExpandableCodeInsightView(codeHistory: codeHistory, dataStructure: "Linked List")
            }
            .padding(.vertical)
        }
        .background(Color.VisualizerBackgroundColor)
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                modeMenu
            }
        }
        .onAppear {
            UserProgressManager.shared.markVisualizerVisited(moduleId: "linkedList", moduleName: "Linked List", category: "dataStructure")
        }
    }
    
    // Navigation Title
    private var navigationTitle: String {
        switch currentMode {
        case .singlyLinked: return "Linked List Visualizer"
        case .doublyLinked: return "Doubly Linked List"
        case .traversal: return "List Traversal"
        }
    }
    
    // Dropdown Menu
    @ViewBuilder
    private var modeMenu: some View {
        Menu {
            ForEach(LinkedListMode.allCases, id: \.self) { mode in
                Button {
                    switchMode(to: mode)
                } label: {
                    Label(mode.rawValue, systemImage: mode.icon)
                }
            }
        } label: {
            Image(systemName: "line.3.horizontal.decrease.circle")
                .font(.title3)
                .foregroundStyle(.white)
        }
        .disabled(isAnimating)
    }
    
    // Canvas
    @ViewBuilder
    private var canvasView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                // HEAD pointer
                if !listItems.isEmpty {
                    VStack {
                        Text("HEAD")
                            .font(.caption2)
                            .bold()
                            .foregroundStyle(.orange)
                        Image(systemName: "arrow.down")
                            .font(.caption)
                            .foregroundStyle(.orange)
                    }
                    .padding(.trailing, 5)
                    .transition(.opacity)
                }
                
                // Nodes
                ForEach(Array(listItems.enumerated()), id: \.offset) { index, item in
                    HStack(spacing: 0) {
                        LinkedListNodeView(
                            value: item,
                            isHighlighted: highlightedIndex == index,
                            isDoubly: currentMode == .doublyLinked
                        )
                        .transition(.scale.combined(with: .opacity))
                        .overlay(alignment: .top) {
                            // Current pointer indicator
                            if highlightedIndex == index {
                                VStack(spacing: 2) {
                                    Text("curr")
                                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                                        .foregroundStyle(.yellow)
                                    Image(systemName: "arrowtriangle.down.fill")
                                        .font(.system(size: 8))
                                        .foregroundStyle(.yellow)
                                }
                                .offset(y: -28)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        }
                        
                        // Arrow / pointer
                        if currentMode == .doublyLinked {
                            // Double arrows
                            VStack(spacing: 2) {
                                Image(systemName: "arrow.right")
                                    .font(.caption2)
                                    .foregroundStyle(arrowColor(at: index))
                                Image(systemName: "arrow.left")
                                    .font(.caption2)
                                    .foregroundStyle(arrowColor(at: index))
                            }
                            .padding(.horizontal, 4)
                            .transition(.opacity)
                        } else {
                            Image(systemName: "arrow.right")
                                .font(.title3)
                                .foregroundStyle(arrowColor(at: index))
                                .padding(.horizontal, 5)
                                .transition(.opacity)
                        }
                    }
                }
                
                // NULL Terminator
                Text("NULL")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.red)
                    .padding(8)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(4)
            }
            .padding()
            .frame(minHeight: 150)
            .animation(.spring(response: 0.5, dampingFraction: 0.7), value: listItems)
            .animation(.easeInOut(duration: 0.3), value: highlightedIndex)
        }
        .background(.gray.opacity(0.1))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.gray.opacity(0.3), lineWidth: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 10)
    }
    
    // Controls add delete
    @ViewBuilder
    private var controlButtons: some View {
        HStack(spacing: 30) {
            if currentMode == .traversal {
                resetTraversalButton
                pauseButton
                traverseButton
            } else {
                removeHeadButton
                addHeadButton
            }
        }
    }
    
    private var removeHeadButton: some View {
        Button(action: removeHead) {
            VStack {
                Image(systemName: "minus.circle")
                    .font(.system(size: 44))
                Text("Remove Head")
                    .font(.caption)
                    .bold()
            }
            .foregroundStyle(listItems.isEmpty ? .gray : .red)
        }
        .disabled(listItems.isEmpty || isAnimating)
    }
    
    private var addHeadButton: some View {
        Button(action: addHead) {
            VStack {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 44))
                Text("Add Head")
                    .font(.caption)
                    .bold()
            }
            .foregroundStyle(listItems.count >= 5 ? .gray : .green)
        }
        .disabled(listItems.count >= 5 || isAnimating)
    }
    
    private var resetTraversalButton: some View {
        Button {
            clearAnimationState()
            withAnimation {
                codeHistory = ["// Ready to traverse", "LinkedList<Integer> list = new LinkedList<>();"]
            }
        } label: {
            VStack {
                Image(systemName: "arrow.counterclockwise.circle")
                    .font(.system(size: 40))
                Text("Reset")
                    .font(.caption2)
                    .bold()
            }
            .foregroundStyle(.red)
        }
    }
    
    private var pauseButton: some View {
        Button {
            isPaused.toggle()
        } label: {
            VStack {
                Image(systemName: isPaused ? "play.circle.fill" : "pause.circle.fill")
                    .font(.system(size: 44))
                Text(isPaused ? "Resume" : "Pause")
                    .font(.caption)
                    .bold()
            }
            .foregroundStyle(!isAnimating ? .gray : .orange)
        }
        .disabled(!isAnimating)
    }
    
    private var traverseButton: some View {
        Button(action: runTraversal) {
            VStack {
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 44))
                Text("Traverse")
                    .font(.caption)
                    .bold()
            }
            .foregroundStyle(listItems.isEmpty || isAnimating ? .gray : .cyan)
        }
        .disabled(listItems.isEmpty || isAnimating)
    }
    
    // Arrow Color
    private func arrowColor(at index: Int) -> Color {
        guard let highlighted = highlightedIndex else { return .gray }
        if index < highlighted {
            return .green.opacity(0.7)
        }
        if index == highlighted {
            return .yellow
        }
        return .gray
    }
    
    // MARK: - Mode Switch
    func switchMode(to mode: LinkedListMode) {
        guard !isAnimating else { return }
        withAnimation(.easeInOut(duration: 0.3)) {
            currentMode = mode
            clearAnimationState()
            
            switch mode {
            case .singlyLinked:
                codeHistory = ["LinkedList<Integer> list = new LinkedList<>();"]
            case .doublyLinked:
                codeHistory = ["// Doubly linked: prev ↔ next pointers", "LinkedList<Integer> list = new LinkedList<>();"]
            case .traversal:
                codeHistory = ["// Tap Traverse to walk the list", "LinkedList<Integer> list = new LinkedList<>();"]
            }
        }
    }
    
    // Logic
    
    func addHead() {
        guard listItems.count < 5 else { return }
        let newValue = Int.random(in: 10...99)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            listItems.insert(newValue, at: 0)
        }
        
        withAnimation {
            if currentMode == .doublyLinked {
                codeHistory.append("list.addFirst(\(newValue)); // rewire prev")
            } else {
                codeHistory.append("list.addFirst(\(newValue));")
            }
        }
    }
    
    func removeHead() {
        guard !listItems.isEmpty else { return }
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
        
        let removedValue = listItems.first ?? 0
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            _ = listItems.removeFirst()
        }
        
        withAnimation {
            if currentMode == .doublyLinked {
                codeHistory.append("list.removeFirst(); // update prev; removed \(removedValue)")
            } else {
                codeHistory.append("list.removeFirst(); // removed \(removedValue)")
            }
        }
    }
    
    // Traversal
    func runTraversal() {
        guard !listItems.isEmpty, !isAnimating else { return }
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        isAnimating = true
        traversalComplete = false
        highlightedIndex = nil
        
        Task { @MainActor in
            withAnimation {
                codeHistory.append("Node curr = head;")
            }
            try? await Task.sleep(nanoseconds: 400_000_000)
            
            for i in 0..<listItems.count {
                // Wait while paused
                while isPaused {
                    try? await Task.sleep(nanoseconds: 100_000_000)
                }
                
                withAnimation(.easeInOut(duration: 0.3)) {
                    highlightedIndex = i
                    codeHistory.append("// visiting node[\(i)] = \(listItems[i])")
                }
                
                let haptic = UIImpactFeedbackGenerator(style: .light)
                haptic.impactOccurred()
                
                try? await Task.sleep(nanoseconds: 700_000_000)
            }
            
            // Reach NULL
            withAnimation(.easeOut(duration: 0.3)) {
                highlightedIndex = nil
                isAnimating = false
                traversalComplete = true
                codeHistory.append("// curr == null → traversal complete!")
            }
        }
    }
    
    func clearAnimationState() {
        highlightedIndex = nil
        isAnimating = false
        isPaused = false
        traversalComplete = false
    }
}

// Node View
struct LinkedListNodeView: View {
    let value: Int
    var isHighlighted: Bool = false
    var isDoubly: Bool = false
    
    var body: some View {
        HStack(spacing: 0) {
            // Prev pointer (doubly linked only)
            if isDoubly {
                ZStack {
                    Color.purple.opacity(0.6)
                    Circle()
                        .fill(Color.white)
                        .frame(width: 6, height: 6)
                }
                .frame(width: 16, height: 40)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 1, height: 40)
            }
            
            // Data Part
            Text("\(value)")
                .font(.headline)
                .bold()
                .foregroundStyle(isHighlighted ? .black : .black)
                .frame(width: 40, height: 40)
                .background(isHighlighted ? Color.yellow : Color.white)
            
            // Divider
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 1, height: 40)
            
            // Next pointer
            ZStack {
                (isHighlighted ? Color.yellow.opacity(0.8) : Color.blue.opacity(0.8))
                Circle()
                    .fill(Color.white)
                    .frame(width: 8, height: 8)
            }
            .frame(width: 20, height: 40)
        }
        .cornerRadius(6)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(isHighlighted ? Color.yellow : Color.blue, lineWidth: 2)
        )
        .shadow(color: isHighlighted ? .yellow.opacity(0.5) : .clear, radius: 6)
        .scaleEffect(isHighlighted ? 1.08 : 1.0)
        .animation(.easeInOut(duration: 0.25), value: isHighlighted)
    }
}

#Preview {
    NavigationStack {
        LinkedListVisualizerView()
            .preferredColorScheme(.dark)
    }
}
