import SwiftUI

struct EmptyStateView: View {
    let text: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            
            Text("No Results Found")
                .font(.headline)
            
            Text("No matches for \"\(text)\"")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}
