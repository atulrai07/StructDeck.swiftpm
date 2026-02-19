//
//  ContentView.swift
//  DSAK
//
//  Created by Atul on 30/12/25.
//
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            OpeningScreenView()
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
