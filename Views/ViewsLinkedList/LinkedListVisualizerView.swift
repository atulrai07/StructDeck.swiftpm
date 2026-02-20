//
//  LinkedListVisualizerView.swift
//  DSAK
//
//  Created by Atul on 13/02/26.
//
import SwiftUI

struct LinkedListVisualizerView: View {
    @Environment(\.dismiss) var dismiss
    
    // State: Nodes
    @State private var listItems: [Int] = []
    
    // State: Code
    @State private var codeSnippet: String = "LinkedList<Integer> list = new LinkedList<>();"
    
    var body: some View {
        VStack(spacing: 20) {
            
            // Header -> toolbar
            Spacer()
            // VISUALIZATION AREA (Canvas)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    
                    // The Head Pointer Label
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
                    
                    // The Nodes
                    ForEach(Array(listItems.enumerated()), id: \.element) { index, item in
                        HStack(spacing: 0) {
                            // Node Graphic
                            NodeView(value: item)
                                .transition(.scale.combined(with: .opacity))
                            
                            // Arrow (Pointer)
                            Image(systemName: "arrow.right")
                                .font(.title3)
                                .foregroundStyle(.gray)
                                .padding(.horizontal, 5)
                                .transition(.opacity)
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
            }
            .background(Color.appBackground.opacity(0))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color.gray.opacity(0.3), lineWidth: 2)
            )
            .padding(.horizontal,10)
            
            Spacer()
            
            // CONTROLS
            HStack(spacing: 30) {
                // REMOVE HEAD
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
                .disabled(listItems.isEmpty)
                
                // ADD HEAD
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
                .disabled(listItems.count >= 5)
            }
            
            
            // CODE INSIGHT
            VStack(alignment: .leading, spacing: 8) {
                Text("JAVA CODE INSIGHT")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.gray)
                    .padding(.horizontal)
                
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
            }
            .padding(.top, 30)
            .frame(height:130)
            .navigationTitle("Linked List Visulaizer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Button{
                        dismiss()
                    }label: {
                        Text("Done")
                    }
                }
            }
        }
        .frame(maxHeight: .infinity)
        .background(Color.appBackground.ignoresSafeArea())
    }
    
    // MARK: - Logic
    
    func addHead() {
        guard listItems.count < 5 else { return }
        let newValue = Int.random(in: 10...99)
        
        // Insert at index 0 (Head)
        listItems.insert(newValue, at: 0)
        
        withAnimation {
            codeSnippet = "list.addFirst(\(newValue));"
        }
    }
    
    func removeHead() {
        guard !listItems.isEmpty else { return }
        _ = listItems.removeFirst()
        
        withAnimation {
            codeSnippet = "list.removeFirst();"
        }
    }
}

// Custom Node View to look like [ Data | • ]
struct NodeView: View {
    let value: Int
    
    var body: some View {
        HStack(spacing: 0) {
            // Data Part
            Text("\(value)")
                .font(.headline)
                .bold()
                .foregroundStyle(.black)
                .frame(width: 40, height: 40)
                .background(Color.white)
            
            // Pointer Part
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 1, height: 40)
            
            ZStack {
                Color.blue.opacity(0.8)
                Circle()
                    .fill(Color.white)
                    .frame(width: 8, height: 8)
            }
            .frame(width: 20, height: 40)
        }
        .cornerRadius(6)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.blue, lineWidth: 2)
        )
    }
}

#Preview {
    NavigationStack {
        LinkedListVisualizerView()
            .preferredColorScheme(.dark)
    }
}
