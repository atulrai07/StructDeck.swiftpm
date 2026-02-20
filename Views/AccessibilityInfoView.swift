//
//  AccessibilityInfoView.swift
//  DSAK
//
//  Created by Atul.
//

import SwiftUI

struct AccessibilityInfoView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.opacity(0.8).ignoresSafeArea()
                
                VStack(spacing: 25) {
                    Image(systemName: "accessibility.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(.blue)
                        .padding(.top)
                        .accessibilityHidden(true)
                    
                    Text("Inclusive Learning")
                        .font(.title.bold())
                        .foregroundStyle(.white)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        AccessibilityFeatureRow(
                            icon: "waveform",
                            title: "Haptic Feedback",
                            desc: "Feel the data structures move with physical vibrations during visualizer operations."
                        )
                        
                        AccessibilityFeatureRow(
                            icon: "mouth.fill",
                            title: "VoiceOver Optimized",
                            desc: "Complex visualizations described structurally for non-visual learners."
                        )
                        AccessibilityFeatureRow(
                            icon: "info.circle",
                            title: "To Turn on Voice Over",
                            desc: "Open Settings > Accessibility > Switch on the Voice Over switch."
                        )
                    }
                    .padding()
                    
                    Spacer()
                    
                    // Button to jump directly to iOS System Accessibility Settings
                    Button {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Text("Open Accessibility")
                            .font(.headline)
                            .bold()
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(16)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .bold()
                }
            }
        }
    }
}

// Reusable row for accessibility features
struct AccessibilityFeatureRow: View {
    let icon: String
    let title: String
    let desc: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 30)
                .accessibilityHidden(true)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)
                Text(desc)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .fixedSize(horizontal: false, vertical: true)  // Add this
                    .lineLimit(nil)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(desc)")
    }
}

#Preview {
    AccessibilityInfoView()
        .preferredColorScheme(.dark)
}
