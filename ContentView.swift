//
//  ContentView.swift
//  DSAK
//
//  Created by Atul on 30/12/25.
//
import SwiftUI

struct ContentView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some View {
        NavigationStack{
            OpeningScreenView()
        }
        .preferredColorScheme(.dark)
        .fullScreenCover(isPresented: Binding(
            get: { !hasSeenOnboarding },
            set: { if !$0 { hasSeenOnboarding = true } }
        )) {
            OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
                .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
