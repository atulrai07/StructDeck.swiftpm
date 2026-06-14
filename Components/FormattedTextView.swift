import SwiftUI

struct FormattedTextView: View {
    let text: String
    var defaultFont: Font = .body
    var defaultColor: Color = .white.opacity(0.9)
    var alignment: TextAlignment = .leading
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(parseMarkdown(text)) { block in
                switch block.type {
                case .header(let content):
                    Text(LocalizedStringKey(content))
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 4)
                        .padding(.bottom, 2)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(alignment)
                    
                case .code(let content):
                    Text(content)
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.green)
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white.opacity(0.06))
                        .cornerRadius(8)
                        .textSelection(.enabled)
                        
                case .paragraph(let content):
                    if content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Spacer().frame(height: 4)
                    } else {
                        // SwiftUI parses inline markdown like **bold** dynamically
                        Text(LocalizedStringKey(content.replacingOccurrences(of: "***", with: "**")))
                            .font(defaultFont)
                            .foregroundColor(defaultColor)
                            .lineSpacing(4)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(alignment)
                    }
                    
                case .bullet(let content):
                    HStack(alignment: .top, spacing: 8) {
                        Text("•")
                            .font(defaultFont)
                            .bold()
                            .foregroundColor(defaultColor)
                        Text(LocalizedStringKey(content.replacingOccurrences(of: "***", with: "**")))
                            .font(defaultFont)
                            .foregroundColor(defaultColor)
                            .lineSpacing(4)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(alignment)
                    }
                    .padding(.leading, 8)
                }
            }
        }
    }
    
    private func parseMarkdown(_ text: String) -> [ContentBlock] {
        var blocks: [ContentBlock] = []
        let lines = text.components(separatedBy: .newlines)
        
        var currentCodeLines: [String] = []
        var inCodeBlock = false
        
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Handle code block toggle
            if trimmed.hasPrefix("```") {
                if inCodeBlock {
                    // End of code block
                    let codeText = currentCodeLines.joined(separator: "\n")
                    blocks.append(ContentBlock(type: .code(codeText)))
                    currentCodeLines.removeAll()
                    inCodeBlock = false
                } else {
                    // Start of code block
                    inCodeBlock = true
                }
                continue
            }
            
            if inCodeBlock {
                currentCodeLines.append(line)
                continue
            }
            
            // Handle headers
            if trimmed.hasPrefix("### ") {
                let content = String(trimmed.dropFirst(4))
                blocks.append(ContentBlock(type: .header(content)))
            } else if trimmed.hasPrefix("## ") {
                let content = String(trimmed.dropFirst(3))
                blocks.append(ContentBlock(type: .header(content)))
            } else if trimmed.hasPrefix("# ") {
                let content = String(trimmed.dropFirst(2))
                blocks.append(ContentBlock(type: .header(content)))
            } else if trimmed.hasPrefix("**") && trimmed.hasSuffix("**") && trimmed.count > 4 {
                let content = String(trimmed.dropFirst(2).dropLast(2))
                blocks.append(ContentBlock(type: .header(content)))
            } else if trimmed.hasPrefix("* ") {
                let content = String(trimmed.dropFirst(2))
                blocks.append(ContentBlock(type: .bullet(content)))
            } else if trimmed.hasPrefix("- ") {
                let content = String(trimmed.dropFirst(2))
                blocks.append(ContentBlock(type: .bullet(content)))
            } else if trimmed.hasPrefix("• ") {
                let content = String(trimmed.dropFirst(2))
                blocks.append(ContentBlock(type: .bullet(content)))
            } else {
                blocks.append(ContentBlock(type: .paragraph(line)))
            }
        }
        
        if !currentCodeLines.isEmpty {
            let codeText = currentCodeLines.joined(separator: "\n")
            blocks.append(ContentBlock(type: .code(codeText)))
        }
        
        return blocks
    }
}

enum BlockType {
    case paragraph(String)
    case header(String)
    case code(String)
    case bullet(String)
}

struct ContentBlock: Identifiable {
    let id = UUID()
    let type: BlockType
}

#Preview {
    ScrollView {
        FormattedTextView(
            text: """
            ### Introduction
            Consider the following binary tree:
            ```
              1
             / \\
            2   3
            ```
            This is a ***beautiful*** binary tree.
            """
        )
        .padding()
        .preferredColorScheme(.dark)
    }
}
