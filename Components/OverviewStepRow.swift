//
//  OverviewStepRow.swift
//  DSAK
//
//  Created by Atul on 30/12/25.
//

import SwiftUI

struct OverviewStepRow: View {
    let number: String
    let title: String
    let desc: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 32, height: 32)
                
                Text(number)
                    .fontWeight(.bold)
                    .foregroundStyle(.blue)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)
                
                Text(desc)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
            
        }
        .padding()
        .background(Color(uiColor: .systemGray6).opacity(0.1))
        .cornerRadius(16)
    }
}

#Preview {
    OverviewStepRow(
        number: "1",
        title: "Overview",
        desc: "here will be the topic overview"
    )
    .padding()
    .background(gradientAppBackground())
    .preferredColorScheme(.dark)
}

