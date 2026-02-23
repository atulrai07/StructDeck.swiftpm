//
//  VisualizerBackgroundColor.swift
//  StructDeck
//
//  Created by Atul on 23/02/26.
//

import SwiftUI

extension Color {
    static let VisualizerBackgroundColor = Color(
        red: 3/255,
        green: 13/255,
        blue: 21/255
    )
}

#Preview {
    Rectangle()
        .fill(Color.VisualizerBackgroundColor)
}
