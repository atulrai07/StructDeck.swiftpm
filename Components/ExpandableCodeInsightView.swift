//
//  ExpandableCodeInsightView.swift
//  StructViz
//
//  Created by Atul on 14/06/26.
//

import SwiftUI

struct ExpandableCodeInsightView: View {
    let codeHistory: [String]
    let dataStructure: String
    
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack {
                Text("JAVA CODE INSIGHT")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.gray)
                    .accessibilityHidden(true)
                
                Spacer()
                
                // Explain Button
                AIExplainButton(
                    codeSnippet: codeHistory.joined(separator: "\n"),
                    dataStructure: dataStructure
                )
                
                // Expand/Collapse Button
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        isExpanded.toggle()
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(isExpanded ? "Collapse" : "Expand")
                            .font(.system(size: 11, weight: .semibold))
                        Image(systemName: isExpanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(.blue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                }
                .accessibilityLabel(isExpanded ? "Collapse Code Insight" : "Expand Code Insight")
                .accessibilityHint(isExpanded ? "Collapses the view to show only the last operation line." : "Expands the view to show the complete history of operations with line numbers.")
            }
            .padding(.horizontal)
            
            // Code Card Container
            VStack(alignment: .leading, spacing: 0) {
                if isExpanded {
                    // Expanded View: IDE-style editor with line numbers
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(Array(codeHistory.enumerated()), id: \.offset) { index, line in
                                HStack(alignment: .top, spacing: 10) {
                                    // Line Number column
                                    Text(String(format: "%02d", index + 1))
                                        .font(.system(.body, design: .monospaced))
                                        .foregroundStyle(.gray.opacity(0.5))
                                        .frame(width: 24, alignment: .trailing)
                                        .padding(.trailing, 2)
                                    
                                    // Vertical line separator
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.25))
                                        .frame(width: 1)
                                        .frame(maxHeight: .infinity)
                                    
                                    // Code snippet
                                    Text(line)
                                        .font(.system(.body, design: .monospaced))
                                        .foregroundStyle(.green)
                                        .multilineTextAlignment(.leading)
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                    Spacer()
                                }
                            }
                        }
                        .padding()
                    }
                    .frame(maxHeight: 220)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                } else {
                    // Collapsed View: Show only the last line
                    HStack {
                        Text(codeHistory.last ?? "")
                            .font(.system(.body, design: .monospaced))
                            .foregroundStyle(.green)
                            .lineLimit(1)
                            .contentTransition(.numericText())
                        
                        Spacer()
                    }
                    .padding()
                    .transition(.opacity)
                }
            }
            .background(Color(uiColor: .secondarySystemBackground).opacity(0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .padding(.horizontal)
            .accessibilityElement(children: .combine)
            .accessibilityLabel(isExpanded ? "Complete Java operation history: \(codeHistory.joined(separator: ", "))" : "Last Java operation: \(codeHistory.last ?? "")")
        }
    }
}
