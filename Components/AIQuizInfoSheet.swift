import SwiftUI

struct AIQuizInfoSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            // AI SF Symbol at the center top with top padding
            VStack(spacing: 16) {
                Image(systemName: "sparkles")
                    .font(.system(size: 64, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.purple, .indigo, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .purple.opacity(0.3), radius: 8, x: 0, y: 4)
                    .padding(.top, 36) // Add top padding to position it perfectly beneath the grabber
                
                Text("Apple Intelligence")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            // Info beneath it
            VStack(alignment: .leading, spacing: 16) {
                Text("This quiz was generated dynamically using your device's built-in language models.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 24)
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "cpu")
                            .foregroundColor(.purple)
                            .font(.body)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("On-Device Processing")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            Text("Runs locally on Apple Silicon for privacy and speed.")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "pencil.and.outline")
                            .foregroundColor(.indigo)
                            .font(.body)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Tailored Content")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .navyBorder()
                                .fixedSize(horizontal: false, vertical: true)
                            Text("Questions are dynamically generated to focus on key DSA concepts, complexity analysis, and edge cases.")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .padding()
                .background(Color(white: 0.15).opacity(0.6)) // Translucent card background
                .cornerRadius(16)
                .padding(.horizontal, 24)
            }
            
            Spacer()
        }
        .presentationDragIndicator(.visible)
        .preferredColorScheme(.dark)
    }
}

// Simple helper extension to avoid compile errors on navyBorder if not defined
private extension View {
    func navyBorder() -> some View {
        self
    }
}

#Preview {
    Text("Sheet Preview")
        .sheet(isPresented: .constant(true)) {
            AIQuizInfoSheet()
                .presentationDetents([.medium])
        }
}
