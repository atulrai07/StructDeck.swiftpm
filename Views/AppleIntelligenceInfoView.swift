import SwiftUI

struct AppleIntelligenceInfoView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                // Apple Intelligence glowing icon
                VStack(spacing: 16) {
                    AppleIntelligenceSymbolView(size: 72)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    Color(red: 161/255, green: 221/255, blue: 254/255), // light blue
                                    Color(red: 219/255, green: 172/255, blue: 244/255), // light purple
                                    Color(red: 247/255, green: 153/255, blue: 201/255), // light pink
                                    Color(red: 252/255, green: 201/255, blue: 133/255)  // light orange/yellow
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: Color(red: 219/255, green: 172/255, blue: 244/255).opacity(0.6), radius: 20, x: 0, y: 0)
                        .padding(.top, 36)
                    
                    Text("Apple Intelligence")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                Text("This app uses Apple Intelligence to personalize and enhance your DSA learning journey.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                
                // The points of explanation (no box, short description)
                VStack(alignment: .leading, spacing: 24) {
                    AppleIntelFeatureRow(
                        icon: "sparkles.rectangle.stack.fill",
                        iconColor: .purple,
                        title: "AI-Powered Quizzes",
                        desc: "Generates custom questionnaires dynamically"
                    )
                    
                    AppleIntelFeatureRow(
                        icon: "doc.text.magnifyingglass",
                        iconColor: .blue,
                        title: "Smart Code Explanation",
                        desc: "Provides step-by-step code explanations"
                    )
                }
                .padding(.horizontal, 32)
                
                Spacer()
                
                // Hyperlink Privacy Policy at bottom center
                Link(destination: URL(string: "https://visulo-ios.netlify.app/")!) {
                    Text("Privacy Policy")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 10/255, green: 132/255, blue: 255/255)) // Apple accent blue color
                        .underline()
                }
                .padding(.bottom, 24)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                }
            }
        }
    }
}

struct AppleIntelligenceSymbolView: View {
    var size: CGFloat
    
    var body: some View {
        if UIImage(systemName: "apple.intelligence") != nil {
            Image(systemName: "apple.intelligence")
                .font(.system(size: size, weight: .semibold))
        } else {
            Image(systemName: "sparkles")
                .font(.system(size: size, weight: .semibold))
        }
    }
}

struct AppleIntelFeatureRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let desc: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(iconColor)
                .frame(width: 28, alignment: .center)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(desc)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(nil)
            }
        }
    }
}

#Preview {
    AppleIntelligenceInfoView()
        .preferredColorScheme(.dark)
}
