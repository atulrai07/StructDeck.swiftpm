//
//  QueueVisualizerView.swift
//  DSAK
//
//  Created by Atul on 11/02/26.
//
import SwiftUI

enum QueueMode: String, CaseIterable {
    case standard = "Standard Queue"
    case circular = "Circular Queue"
    case deque = "Deque"
    
    var icon: String {
        switch self {
        case .standard: return "arrow.right.square"
        case .circular: return "arrow.trianglehead.2.clockwise"
        case .deque: return "arrow.left.arrow.right.square"
        }
    }
}

struct QueueSlot: Identifiable {
    let id = UUID()
    var value: Int? = nil
}

struct QueueVisualizerView: View {
    @Environment(\.dismiss) var dismiss
    
    let capacity = 6
    
    @State private var currentMode: QueueMode = .standard
    @State private var slots: [QueueSlot] = []
    @State private var frontIndex: Int = 0
    @State private var rearIndex: Int = -1
    @State private var itemCount: Int = 0
    @State private var codeHistory: [String] = ["Queue<Integer> q = new LinkedList<>();"]
    @State private var isAnimating: Bool = false
    @State private var highlightedSlotIndex: Int? = nil
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                canvasView
                    .frame(minHeight: currentMode == .circular ? 280 : 180)
                
                controlButtons
                
                ExpandableCodeInsightView(codeHistory: codeHistory, dataStructure: "Queue")
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
            initializeSlots()
            UserProgressManager.shared.markVisualizerVisited(moduleId: "queue", moduleName: "Queue", category: "dataStructure")
        }
    }
    
    private var navigationTitle: String {
        switch currentMode {
        case .standard: return "Queue Visualizer"
        case .circular: return "Circular Queue"
        case .deque: return "Deque Visualizer"
        }
    }
    
    // Dropdown Menu
    @ViewBuilder
    private var modeMenu: some View {
        Menu {
            ForEach(QueueMode.allCases, id: \.self) { mode in
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
        if currentMode == .circular {
            circularCanvas
        } else {
            linearCanvas
        }
    }
    
    // Linear Canvas
    @ViewBuilder
    private var linearCanvas: some View {
        VStack(spacing: 4) {
            // FRONT / REAR labels on top
            HStack(spacing: 0) {
                ForEach(0..<capacity, id: \.self) { i in
                    slotPointerLabel(at: i)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 20)
            
            // Slot boxes
            HStack(spacing: 4) {
                ForEach(0..<capacity, id: \.self) { i in
                    linearSlotView(at: i)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            
            // Index labels
            HStack(spacing: 0) {
                ForEach(0..<capacity, id: \.self) { i in
                    Text("\(i)")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundStyle(.gray.opacity(0.6))
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 16)
        .background(.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.gray.opacity(0.3), lineWidth: 2)
        )
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func slotPointerLabel(at index: Int) -> some View {
        VStack(spacing: 1) {
            if itemCount > 0 && index == frontIndex {
                Text("F")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundStyle(.orange)
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.system(size: 6))
                    .foregroundStyle(.orange)
            } else if itemCount > 0 && index == rearIndex {
                Text("R")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundStyle(.cyan)
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.system(size: 6))
                    .foregroundStyle(.cyan)
            } else {
                Color.clear.frame(height: 18)
            }
        }
        .frame(height: 18)
        .animation(.easeInOut(duration: 0.3), value: frontIndex)
        .animation(.easeInOut(duration: 0.3), value: rearIndex)
    }
    
    @ViewBuilder
    private func linearSlotView(at index: Int) -> some View {
        let slot = slots.indices.contains(index) ? slots[index] : QueueSlot()
        let isOccupied = slot.value != nil
        let isHighlighted = highlightedSlotIndex == index
        
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(slotFillColor(slot: slot, isHighlighted: isHighlighted))
                .frame(maxWidth: .infinity)
                .frame(height: 55)
            
            RoundedRectangle(cornerRadius: 6)
                .strokeBorder(
                    slotBorderColor(slot: slot, isHighlighted: isHighlighted),
                    lineWidth: isOccupied ? 2 : 1
                )
                .frame(maxWidth: .infinity)
                .frame(height: 55)
            
            if let value = slot.value {
                Text("\(value)")
                    .font(.headline)
                    .bold()
                    .foregroundStyle(.white)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .scaleEffect(isHighlighted ? 1.08 : 1.0)
        .shadow(color: isHighlighted ? .yellow.opacity(0.5) : .clear, radius: 6)
        .animation(.easeInOut(duration: 0.25), value: isHighlighted)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: slot.value)
    }
    
    private func slotFillColor(slot: QueueSlot, isHighlighted: Bool) -> Color {
        if isHighlighted { return .yellow.opacity(0.3) }
        if slot.value != nil { return Color.blue }
        return Color.gray.opacity(0.15)
    }
    
    private func slotBorderColor(slot: QueueSlot, isHighlighted: Bool) -> Color {
        if isHighlighted { return .yellow }
        if slot.value != nil { return .blue.opacity(0.6) }
        return .gray.opacity(0.3)
    }
    
    // Circular Canvas
    @ViewBuilder
    private var circularCanvas: some View {
        ZStack {
            // Ring of slots
            let angleStep = 360.0 / Double(capacity)
            let radius: CGFloat = 100
            
            // Draw connection arcs
            Circle()
                .strokeBorder(Color.gray.opacity(0.2), lineWidth: 2)
                .frame(width: radius * 2 + 60, height: radius * 2 + 60)
            
            ForEach(0..<capacity, id: \.self) { i in
                let angle = Angle.degrees(angleStep * Double(i) - 90)
                let x = radius * CGFloat(cos(angle.radians))
                let y = radius * CGFloat(sin(angle.radians))
                let slot = slots.indices.contains(i) ? slots[i] : QueueSlot()
                let isHighlighted = highlightedSlotIndex == i
                
                circularSlotView(slot: slot, index: i, isHighlighted: isHighlighted)
                    .offset(x: x, y: y)
            }
            
            // Center label
            VStack(spacing: 2) {
                Text("Circular")
                    .font(.caption2)
                    .bold()
                Text("\(itemCount)/\(capacity)")
                    .font(.caption)
                    .bold()
            }
            .foregroundStyle(.gray)
        }
        .frame(height: 280)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func circularSlotView(slot: QueueSlot, index: Int, isHighlighted: Bool) -> some View {
        ZStack {
            Circle()
                .fill(slotFillColor(slot: slot, isHighlighted: isHighlighted))
                .frame(width: 48, height: 48)
            
            Circle()
                .strokeBorder(
                    slotBorderColor(slot: slot, isHighlighted: isHighlighted),
                    lineWidth: slot.value != nil ? 2 : 1
                )
                .frame(width: 48, height: 48)
            
            VStack(spacing: 0) {
                if let value = slot.value {
                    Text("\(value)")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white)
                } else {
                    Text("\(index)")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundStyle(.gray.opacity(0.5))
                }
            }
        }
        .overlay(alignment: .bottom) {
            circularPointerLabel(at: index)
                .offset(y: 16)
        }
        .scaleEffect(isHighlighted ? 1.15 : 1.0)
        .shadow(color: isHighlighted ? .yellow.opacity(0.5) : .clear, radius: 6)
        .animation(.easeInOut(duration: 0.25), value: isHighlighted)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: slot.value)
    }
    
    @ViewBuilder
    private func circularPointerLabel(at index: Int) -> some View {
        if itemCount > 0 && index == frontIndex && index == rearIndex {
            Text("F/R")
                .font(.system(size: 8, weight: .bold, design: .monospaced))
                .foregroundStyle(.green)
        } else if itemCount > 0 && index == frontIndex {
            Text("F")
                .font(.system(size: 9, weight: .bold, design: .monospaced))
                .foregroundStyle(.orange)
        } else if itemCount > 0 && index == rearIndex {
            Text("R")
                .font(.system(size: 9, weight: .bold, design: .monospaced))
                .foregroundStyle(.cyan)
        } else {
            EmptyView()
        }
    }
    
    // MARK: - Control Buttons
    @ViewBuilder
    private var controlButtons: some View {
        Group {
            switch currentMode {
            case .standard, .circular:
                standardControls
            case .deque:
                dequeControls
            }
        }
        .padding(.vertical, 20)
    }
    
    @ViewBuilder
    private var standardControls: some View {
        HStack(spacing: 40) {
            // DEQUEUE
            Button(action: dequeueItem) {
                VStack {
                    Image(systemName: "arrow.left.circle")
                        .font(.system(size: 44))
                    Text("Dequeue")
                        .font(.caption)
                        .bold()
                }
                .foregroundStyle(itemCount == 0 ? .gray : .red)
            }
            .disabled(itemCount == 0 || isAnimating)
            
            // ENQUEUE
            Button {
                enqueueItem()
            } label: {
                VStack {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 44))
                    Text("Enqueue")
                        .font(.caption)
                        .bold()
                }
                .foregroundStyle(itemCount >= capacity ? .gray : .green)
            }
            .disabled(itemCount >= capacity || isAnimating)
        }
    }
    
    @ViewBuilder
    private var dequeControls: some View {
        VStack(spacing: 12) {
            HStack(spacing: 30) {
                // ADD FRONT
                Button(action: addFront) {
                    VStack {
                        Image(systemName: "arrow.left.circle.fill")
                            .font(.system(size: 36))
                        Text("Add Front")
                            .font(.caption2)
                            .bold()
                    }
                    .foregroundStyle(itemCount >= capacity ? .gray : .green)
                }
                .disabled(itemCount >= capacity || isAnimating)
                
                // REMOVE FRONT
                Button(action: removeFront) {
                    VStack {
                        Image(systemName: "arrow.left.circle")
                            .font(.system(size: 36))
                        Text("Rmv Front")
                            .font(.caption2)
                            .bold()
                    }
                    .foregroundStyle(itemCount == 0 ? .gray : .red)
                }
                .disabled(itemCount == 0 || isAnimating)
                
                // REMOVE REAR
                Button(action: removeRear) {
                    VStack {
                        Image(systemName: "arrow.right.circle")
                            .font(.system(size: 36))
                        Text("Rmv Rear")
                            .font(.caption2)
                            .bold()
                    }
                    .foregroundStyle(itemCount == 0 ? .gray : .red)
                }
                .disabled(itemCount == 0 || isAnimating)
                
                // ADD REAR
                Button(action: addRear) {
                    VStack {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 36))
                        Text("Add Rear")
                            .font(.caption2)
                            .bold()
                    }
                    .foregroundStyle(itemCount >= capacity ? .gray : .green)
                }
                .disabled(itemCount >= capacity || isAnimating)
            }
        }
    }
    
    // Initialization
    func initializeSlots() {
        slots = (0..<capacity).map { _ in QueueSlot() }
        frontIndex = 0
        rearIndex = -1
        itemCount = 0
    }
    
    // Mode Switching
    func switchMode(to mode: QueueMode) {
        guard !isAnimating else { return }
        withAnimation(.easeInOut(duration: 0.3)) {
            currentMode = mode
            initializeSlots()
            highlightedSlotIndex = nil
            
            switch mode {
            case .standard:
                codeHistory = ["Queue<Integer> q = new LinkedList<>();"]
            case .circular:
                codeHistory = ["// Circular: rear = (rear+1) % cap", "Queue<Integer> q = new CircularQueue<>(6);"]
            case .deque:
                codeHistory = ["Deque<Integer> dq = new ArrayDeque<>();"]
            }
        }
    }
    
    //Standard and Circular Enqueue
    func enqueueItem() {
        guard itemCount < capacity else { return }
        let newValue = Int.random(in: 10...99)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        let nextRear: Int
        if currentMode == .circular {
            nextRear = (rearIndex + 1) % capacity
        } else {
            nextRear = rearIndex + 1
            guard nextRear < capacity else {
                withAnimation {
                    codeHistory.append("// ERROR: Array full! No wrap-around.")
                }
                return
            }
        }
        
        isAnimating = true
        Task { @MainActor in
            // Highlight target slot
            withAnimation(.easeInOut(duration: 0.3)) {
                highlightedSlotIndex = nextRear
            }
            try? await Task.sleep(nanoseconds: 400_000_000)
            
            // Place value
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                slots[nextRear].value = newValue
                rearIndex = nextRear
                itemCount += 1
                codeHistory.append("q.add(\(newValue)); // size=\(itemCount)")
                highlightedSlotIndex = nil
            }
            
            try? await Task.sleep(nanoseconds: 200_000_000)
            isAnimating = false
        }
    }
    
    //Dequeue
    func dequeueItem() {
        guard itemCount > 0 else { return }
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
        
        isAnimating = true
        Task { @MainActor in
            withAnimation(.easeInOut(duration: 0.3)) {
                highlightedSlotIndex = frontIndex
            }
            try? await Task.sleep(nanoseconds: 400_000_000)
            
            let removedValue = slots[frontIndex].value ?? 0
            
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                slots[frontIndex] = QueueSlot()
                itemCount -= 1
                highlightedSlotIndex = nil
                
                if itemCount == 0 {
                    frontIndex = 0
                    rearIndex = -1
                    codeHistory.append("q.poll(); // removed \(removedValue), empty")
                } else {
                    if currentMode == .circular {
                        frontIndex = (frontIndex + 1) % capacity
                    } else {
                        frontIndex += 1
                    }
                    codeHistory.append("q.poll(); // removed \(removedValue)")
                }
            }
            try? await Task.sleep(nanoseconds: 200_000_000)
            isAnimating = false
        }
    }
    
    // Deque Operations
    func addFront() {
        guard itemCount < capacity else { return }
        let newValue = Int.random(in: 10...99)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        let newFront: Int
        if itemCount == 0 {
            newFront = 0
            rearIndex = 0
        } else {
            newFront = (frontIndex - 1 + capacity) % capacity
        }
        
        guard slots[newFront].value == nil else {
            withAnimation { codeHistory.append("// No space at front!") }
            return
        }
        
        isAnimating = true
        Task { @MainActor in
            withAnimation(.easeInOut(duration: 0.3)) {
                highlightedSlotIndex = newFront
            }
            try? await Task.sleep(nanoseconds: 400_000_000)
            
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                slots[newFront].value = newValue
                frontIndex = newFront
                itemCount += 1
                if itemCount == 1 { rearIndex = newFront }
                codeHistory.append("dq.addFirst(\(newValue));")
                highlightedSlotIndex = nil
            }
            try? await Task.sleep(nanoseconds: 200_000_000)
            isAnimating = false
        }
    }
    
    func addRear() {
        guard itemCount < capacity else { return }
        let newValue = Int.random(in: 10...99)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        let newRear: Int
        if itemCount == 0 {
            newRear = 0
            frontIndex = 0
        } else {
            newRear = (rearIndex + 1) % capacity
        }
        
        guard slots[newRear].value == nil else {
            withAnimation { codeHistory.append("// No space at rear!") }
            return
        }
        
        isAnimating = true
        Task { @MainActor in
            withAnimation(.easeInOut(duration: 0.3)) {
                highlightedSlotIndex = newRear
            }
            try? await Task.sleep(nanoseconds: 400_000_000)
            
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                slots[newRear].value = newValue
                rearIndex = newRear
                itemCount += 1
                if itemCount == 1 { frontIndex = newRear }
                codeHistory.append("dq.addLast(\(newValue));")
                highlightedSlotIndex = nil
            }
            try? await Task.sleep(nanoseconds: 200_000_000)
            isAnimating = false
        }
    }
    
    func removeFront() {
        guard itemCount > 0 else { return }
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
        
        isAnimating = true
        Task { @MainActor in
            withAnimation(.easeInOut(duration: 0.3)) {
                highlightedSlotIndex = frontIndex
            }
            try? await Task.sleep(nanoseconds: 400_000_000)
            
            let removed = slots[frontIndex].value ?? 0
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                slots[frontIndex] = QueueSlot()
                itemCount -= 1
                highlightedSlotIndex = nil
                
                if itemCount == 0 {
                    frontIndex = 0
                    rearIndex = -1
                    codeHistory.append("dq.pollFirst(); // removed \(removed), empty")
                } else {
                    frontIndex = (frontIndex + 1) % capacity
                    codeHistory.append("dq.pollFirst(); // removed \(removed)")
                }
            }
            try? await Task.sleep(nanoseconds: 200_000_000)
            isAnimating = false
        }
    }
    
    func removeRear() {
        guard itemCount > 0 else { return }
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
        
        isAnimating = true
        Task { @MainActor in
            withAnimation(.easeInOut(duration: 0.3)) {
                highlightedSlotIndex = rearIndex
            }
            try? await Task.sleep(nanoseconds: 400_000_000)
            
            let removed = slots[rearIndex].value ?? 0
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                slots[rearIndex] = QueueSlot()
                itemCount -= 1
                highlightedSlotIndex = nil
                
                if itemCount == 0 {
                    frontIndex = 0
                    rearIndex = -1
                    codeHistory.append("dq.pollLast(); // removed \(removed), empty")
                } else {
                    rearIndex = (rearIndex - 1 + capacity) % capacity
                    codeHistory.append("dq.pollLast(); // removed \(removed)")
                }
            }
            try? await Task.sleep(nanoseconds: 200_000_000)
            isAnimating = false
        }
    }
}

// haptic is not compatible with ios 17 and < so i have used if else fix.
extension View {
    func queueHaptic(trigger: [Int]) -> some View {
        Group {
            if #available(iOS 17.0, *) {
                self.sensoryFeedback(.impact(weight: .medium), trigger: trigger)
            } else {
                self
            }
        }
    }
}

#Preview {
    NavigationStack {
        QueueVisualizerView()
            .preferredColorScheme(.dark)
    }
}
