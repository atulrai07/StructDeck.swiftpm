//
//  AccessibilityFeatureRow.swift
//  StructDeck
//
//  Created by Atul on 23/02/26.
//

import SwiftUI

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
}
