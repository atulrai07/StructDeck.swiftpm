//
//  StackVisualizerView.swift
//  DSAK
//
//  Created by Atul on 30/12/25.
//

import SwiftUI

struct StackVisualizerView: View {
    @Environment(\.dismiss) var dismiss
    
    // State for the Visual Stack Items
    @State private var stackItems: [Int] = []
    
    // State for the java code
    @State private var codeHistory: [String] = ["Stack<Integer> stack = new Stack<>();"]
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    
                    // VISUALIZATION AREA (canvas)
                    ZStack(alignment: .bottom) {
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(Color.gray.opacity(0.3), lineWidth: 2)
                            .frame(width: 140, height: 350)
                            .background(.gray.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        VStack(spacing: 4) {
                            ForEach(stackItems.reversed(), id: \.self) { item in
                                Text("\(item)")
                                    .font(.headline)
                                    .bold()
                                    .foregroundStyle(.white)
                                    .frame(width: 120, height: 50)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                                    .transition(.move(edge: .top).combined(with: .opacity))
                            }
                        }
                        .padding(.bottom, 10)
                        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: stackItems)
                    }
                    .frame(height: 360)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(stackItems.isEmpty ? "Empty Stack." : "Stack containing \(stackItems.count) items. The top item is \(stackItems.last!).")
                    .accessibilityHint("Use the Push and Pop buttons below to modify the stack.")
                    
                    // CONTROLS
                    HStack(spacing: 50) {
                        Button(action: popItem) {
                            VStack {
                                Image(systemName: "arrow.up.circle")
                                    .font(.system(size: 44))
                                Text("Pop")
                                    .font(.caption)
                                    .bold()
                            }
                            .foregroundStyle(stackItems.isEmpty ? .gray : .red)
                        }
                        .disabled(stackItems.isEmpty)
                        .accessibilityLabel("Pop")
                        .accessibilityHint("Removes the top item from the stack.")
                        
                        Button(action: pushItem) {
                            VStack {
                                Image(systemName: "arrow.down.circle.fill")
                                    .font(.system(size: 44))
                                Text("Push")
                                    .font(.caption)
                                    .bold()
                            }
                            .foregroundStyle(stackItems.count >= 6 ? .gray : .blue)
                        }
                        .disabled(stackItems.count >= 6)
                        .accessibilityLabel("Push")
                        .accessibilityHint("Adds a random number to the top of the stack.")
                    }
                    .padding(.vertical, 20)
                    .modifier(SensoryFeedbackModifier(trigger: stackItems))
                    
                    // CODE INSIGHT (Bottom)
                    ExpandableCodeInsightView(codeHistory: codeHistory, dataStructure: "Stack")
                }
                .padding(.vertical)
            }
            .background(Color.VisualizerBackgroundColor)
            .navigationTitle("Stack Visualizer")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // Logic Functions
    
    func pushItem() {
        guard stackItems.count < 6 else { return }
        let newValue = Int.random(in: 10...99)
        stackItems.append(newValue)
        withAnimation {
            codeHistory.append("stack.push(\(newValue));")
        }
    }
    
    func popItem() {
        guard !stackItems.isEmpty else { return }
        let poppedValue = stackItems.popLast() ?? 0
        withAnimation {
            codeHistory.append("stack.pop(); // popped \(poppedValue)")
        }
    }
}

struct SensoryFeedbackModifier: ViewModifier {
    var trigger: [Int]
    
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content.sensoryFeedback(.impact(weight: .medium), trigger: trigger)
        } else {
            content
        }
    }
}

#Preview {
    NavigationStack {
        StackVisualizerView()
            .preferredColorScheme(.dark)
    }
}
