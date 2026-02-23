//
//  QueueVisualizerView.swift
//  DSAK
//
//  Created by Atul on 11/02/26.
//
import SwiftUI

struct QueueVisualizerView: View {
    @Environment(\.dismiss) var dismiss
    
    // State for Queue Items
    @State private var queueItems: [Int] = []
    
    // State for Reactive Code
    @State private var codeSnippet: String = "Queue<Integer> queue = new LinkedList<>();"
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            // VISUALIZATION AREA (canvas)
            ZStack {
                // Container Box
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color.gray.opacity(0.3), lineWidth: 3)
                    .frame(height: 100)
                    .background(.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                    
                
                // The Queue Items (Horizontal Stack)
                HStack(spacing: 10) {
                    ForEach(queueItems, id: \.self) { item in
                        Text("\(item)")
                            .font(.headline)
                            .bold()
                            .foregroundStyle(.white)
                            .frame(width: 60, height: 60)
                            .background(
                                Color.blue
                            )
                            .cornerRadius(8)
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
                    }
                }
                .animation(.spring(response: 0.3, dampingFraction: 1), value: queueItems)
                .padding(.horizontal)
            }
            .frame(maxHeight: .infinity)
            // STRUCTURAL AUDIO DESCRIPTION
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(queueItems.isEmpty ? "Empty Queue." : "Queue containing \(queueItems.count) items. The front item is \(queueItems.first!).")
            .accessibilityHint("Use the Enqueue and Dequeue buttons below to modify the queue.")
            
            // CONTROLS
            HStack(spacing: 40) {
                // DEQUEUE Button
                Button(action: dequeueItem) {
                    VStack {
                        Image(systemName: "arrow.left.circle")
                            .font(.system(size: 44))
                        Text("Dequeue")
                            .font(.caption)
                            .bold()
                    }
                    .foregroundStyle(queueItems.isEmpty ? .gray : .red)
                }
                .disabled(queueItems.isEmpty)
                .accessibilityLabel("Dequeue")
                .accessibilityHint("Removes the front item from the queue.") // Explains button action
                
                // ENQUEUE Button
                Button(action: enqueueItem) {
                    VStack {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 44))
                        Text("Enqueue")
                            .font(.caption)
                            .bold()
                    }
                    .foregroundStyle(queueItems.count >= 5 ? .gray : .green)
                }
                .disabled(queueItems.count >= 5)
                .accessibilityLabel("Enqueue")
                .accessibilityHint("Adds a random number to the back of the queue.") // Explains button action
            }
            .padding(.vertical, 20)
            
            // HAPTIC FEEDBACK: Vibrates every time the queue array changes
            .queueHaptic(trigger: queueItems)
            
            // 4. CODE IN'SIGHT
            VStack(alignment: .leading, spacing: 8) {
                Text("JAVA CODE INSIGHT")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.gray)
                    .padding(.horizontal)
                    .accessibilityHidden(true)
                
                HStack {
                    Text(codeSnippet)
                        .font(.system(.body, design: .monospaced))
                        .foregroundStyle(.green)
                        .contentTransition(.numericText())
                    Spacer()
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground).opacity(0.1))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .padding(.horizontal)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Java Code Snippet: \(codeSnippet)")
            }
            .padding(.bottom, 30)
            .frame(height: 126)
        }
        .background(Color.VisualizerBackgroundColor)
        .navigationTitle("Queue Visualizer")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") { dismiss() }
            }

        }
    }
    
    // Logic
    
    func enqueueItem() {
        guard queueItems.count < 5 else { return }
        let newValue = Int.random(in: 10...99)
        queueItems.append(newValue) // Add to end
        
        withAnimation {
            codeSnippet = "queue.add(\(newValue));"
        }
    }
    
    func dequeueItem() {
        guard !queueItems.isEmpty else { return }
        _ = queueItems.removeFirst() // Remove from front
        
        withAnimation {
            codeSnippet = "queue.poll();"
        }
    }
}

// haptic is not compatible with ios 17 and < 
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
