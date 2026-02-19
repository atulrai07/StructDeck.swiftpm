//
//  FeatureRow.swift
//  DSAK
//
//  Created by Atul on 30/12/25.
//
            
import SwiftUI

struct Feature2Row: View {
    let icon: String
    let title: String
    let desc: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)
                Text(desc)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
        }
    }
}
#Preview {
    Feature2Row(icon: "icon", title: "title", desc: "desc")
}
