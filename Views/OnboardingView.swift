//
//  OnboardingView.swift
//  StructDeck
//
//  Created by Atul on 25/02/26.
//

import SwiftUI

// Main Onboarding View
struct OnboardingView: View {
    @Binding var hasSeenOnboarding: Bool
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            // Particle gradient background
            particleGradientAppBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Skip Button
                HStack {
                    Spacer()
                    Button {
                        hasSeenOnboarding = true
                    } label: {
                        Text(currentPage < 3 ? "Skip" : "")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white.opacity(0.8))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(currentPage < 3 ? Color.white.opacity(0.15) : Color.clear)
                            .clipShape(Capsule())
                    }
                    .opacity(currentPage < 3 ? 1 : 0)
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
                
                // Pages
                TabView(selection: $currentPage) {
                    OnboardingWelcomePage()
                        .tag(0)
                    OnboardingTheoryCardsPage()
                        .tag(1)
                    OnboardingVisualizerPage()
                        .tag(2)
                    OnboardingQuizPage()
                        .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.3), value: currentPage)
                
                // Custom Page Indicator
                HStack(spacing: 8) {
                    ForEach(0..<4, id: \.self) { index in
                        if index == currentPage {
                            Capsule()
                                .fill(Color.blue)
                                .frame(width: 28, height: 8)
                        } else {
                            Circle()
                                .fill(Color.white.opacity(0.3))
                                .frame(width: 8, height: 8)
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: currentPage)
                .padding(.bottom, 24)
                
                // Bottom Button
                Button {
                    if currentPage < 3 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        hasSeenOnboarding = true
                    }
                } label: {
                    Text(currentPage == 0 || currentPage == 3 ? "Get Started" : "Continue →")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.white)
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 24)
            }
        }
    }
}

// Welcome
struct OnboardingWelcomePage: View {
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0
    @State private var textOpacity: Double = 0
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // App Icon
            ZStack {
                // Outer glow
                RoundedRectangle(cornerRadius: 32)
                    .fill()
                    .frame(width: 201, height: 201)
                
                Image("appLogo")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 32))
                    .zIndex(1)
            }
            .scaleEffect(logoScale)
            .opacity(logoOpacity)
            
            // App Name
            Text("StructViz")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .opacity(textOpacity)
            
            // Tagline
            Text("KickStart your Data Structures\n& Algorithms journey.")
                .font(.title3)
                .foregroundStyle(.white.opacity(0.6))
                .multilineTextAlignment(.center)
                .opacity(textOpacity)
            
            Spacer()
            Spacer()
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }
            withAnimation(.easeOut(duration: 0.6).delay(0.6)) {
                textOpacity = 1.0
            }
        }
    }
}

// Theory Cards (Fan-out Animation)
struct OnboardingTheoryCardsPage: View {
    @State private var fanned = false
    @State private var textOpacity: Double = 0
    
    private let cardColors: [Color] = [.cyan, .green, .pink]
    private let cardIcons: [String] = ["link", "tray.full.fill", "square.on.square"]
    
    var body: some View {
        VStack(spacing: 28) {
            Spacer()
            
            // Illustration container
            ZStack {
                // Dark container
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white.opacity(0.05))
                    .frame(width: 280, height: 280)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )
                
                // Decorative circles
                Circle()
                    .stroke(Color.white.opacity(0.06), lineWidth: 1)
                    .frame(width: 50, height: 50)
                    .offset(x: -90, y: -80)
                
                Circle()
                    .fill(Color.white.opacity(0.04))
                    .frame(width: 30, height: 30)
                    .offset(x: 100, y: 90)
                
                // Fan-out Cards
                ForEach(Array(cardColors.enumerated()), id: \.offset) { index, color in
                    FanCard(color: color, icon: cardIcons[index])
                        .rotationEffect(
                            .degrees(fanned ? Double(index - 1) * 15 : 0),
                            anchor: .bottom
                        )
                        .offset(
                            x: fanned ? CGFloat(index - 1) * 25 : 0,
                            y: fanned ? CGFloat(abs(index - 1)) * -10 : 0
                        )
                        .scaleEffect(fanned ? 1.0 : 0.85)
                        .opacity(fanned ? 1.0 : 0.3)
                        .zIndex(Double(index))
                        .animation(
                            .spring(response: 0.7, dampingFraction: 0.65)
                                .delay(Double(index) * 0.3),
                            value: fanned
                        )
                }
            }
            
            // Title
            Text("Theory Cards")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .opacity(textOpacity)
            
            // Subtitle
            Text("Master concepts with detailed, easy to understand scrollable theory cards.")
                .font(.body)
                .foregroundStyle(.white.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .opacity(textOpacity)
            
            Spacer()
            Spacer()
        }
        .onAppear {
            withAnimation {
                fanned = true
            }
            withAnimation(.easeOut(duration: 0.5).delay(0.7)) {
                textOpacity = 1.0
            }
        }
        .onDisappear {
            fanned = false
            textOpacity = 0
        }
    }
}

// Single fan card
struct FanCard: View {
    let color: Color
    let icon: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(color.gradient)
                .frame(width: 100, height: 140)
                .shadow(color: color.opacity(0.4), radius: 10, x: 0, y: 5)
            
            VStack {
                Spacer()
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(.white.opacity(0.9))
                    .padding(.bottom, 16)
            }
            .frame(width: 100, height: 140)
        }
    }
}

// MARK: - Screen 3: Interactive Visualizers (Stack Push Animation)
struct OnboardingVisualizerPage: View {
    @State private var visibleElements: [Bool] = [false, false, false, false]
    @State private var showLabels = false
    @State private var textOpacity: Double = 0
    
    private let stackValues = ["86", "71", "56", "29"]
    
    var body: some View {
        VStack(spacing: 28) {
            Spacer()
            
            // Illustration container
            ZStack {
                // Dark container
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white.opacity(0.05))
                    .frame(width: 250, height: 320)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )
                
                // Stack elements
                VStack(spacing: 8) {
                    ForEach(Array(stackValues.enumerated()), id: \.offset) { index, value in
                        Text(value)
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .frame(width: 160, height: 48)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(red: 0, green: 0.55, blue: 1), Color(red: 0, green: 0.4, blue: 0.95)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                            .offset(y: visibleElements[index] ? 0 : -60)
                            .opacity(visibleElements[index] ? 1 : 0)
                            .scaleEffect(visibleElements[index] ? 1 : 0.7)
                    }
                }
                
                // Code label: stack.push(item)
                Text("stack.push(item)")
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.6))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color(red: 0.15, green: 0.2, blue: 0.35).opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .offset(x: 100, y: -110)
                    .opacity(showLabels ? 1 : 0)
                
                // LIFO label
                Text("LIFO")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.5))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .background(Color(red: 0.15, green: 0.2, blue: 0.35).opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .offset(x: -120, y: 50)
                    .opacity(showLabels ? 1 : 0)
            }
            
            // Title
            Text("Interactive\nVisualizers")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .opacity(textOpacity)
            
            // Subtitle
            Text("Watch algorithms come alive with real time animations")
                .font(.body)
                .foregroundStyle(.white.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .opacity(textOpacity)
            
            Spacer()
            Spacer()
        }
        .onAppear {
            // Push elements one by one from bottom to top
            for i in (0..<stackValues.count).reversed() {
                let delay = Double(stackValues.count - 1 - i) * 0.25 + 0.3
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(delay)) {
                    visibleElements[i] = true
                }
            }
            withAnimation(.easeOut(duration: 0.4).delay(1.5)) {
                showLabels = true
            }
            withAnimation(.easeOut(duration: 0.5).delay(0.5)) {
                textOpacity = 1.0
            }
        }
        .onDisappear {
            visibleElements = [false, false, false, false]
            showLabels = false
            textOpacity = 0
        }
    }
}

// MARK: - Screen 4: Test Your Knowledge (Quiz Animation)
struct OnboardingQuizPage: View {
    @State private var showChecklist = false
    @State private var showTrophy = false
    @State private var showBulb = false
    @State private var showStatusPill = false
    @State private var textOpacity: Double = 0
    
    var body: some View {
        VStack(spacing: 28) {
            Spacer()
            
            // Illustration area
            ZStack {
                // Blue checklist badge — bottom left
                
                // Orange trophy badge — top center
                ZStack {
                    QuizBadge(
                        icon: "trophy.fill",
                        secondaryIcon: nil,
                        gradientColors: [Color.orange, Color(red: 0.95, green: 0.6, blue: 0.1)],
                        size: 180
                    )
                    
                    // MASTERY label
                    Text("MASTERY")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.4))
                        .clipShape(Capsule())
                        .offset(y: 150)
                }
                .offset(x: 0, y: -70)
                .scaleEffect(showTrophy ? 1 : 0.3)
                .opacity(showTrophy ? 1 : 0)
                
                
                // Quiz Status pill — bottom center
                HStack(spacing: 10) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .font(.title3)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Quiz Status")
                            .font(.caption2)
                            .foregroundStyle(.white.opacity(0.6))
                        Text("Knowledge Checked")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                )
                .offset(y: 100)
                .scaleEffect(showStatusPill ? 1 : 0.8)
                .opacity(showStatusPill ? 1 : 0)
                .padding(.top)
            }
            .frame(height: 280)
            
            // Title
            Text("Test Your Knowledge")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .opacity(textOpacity)
            
            // Subtitle
            Text("Challenge yourself with interactive quizzes after every topic")
                .font(.body)
                .foregroundStyle(.white.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .opacity(textOpacity)
            
            Spacer()
            Spacer()
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.65).delay(0.2)) {
                showChecklist = true
            }
            withAnimation(.spring(response: 0.6, dampingFraction: 0.65).delay(0.4)) {
                showTrophy = true
            }
            withAnimation(.spring(response: 0.6, dampingFraction: 0.65).delay(0.6)) {
                showBulb = true
            }
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.9)) {
                showStatusPill = true
            }
            withAnimation(.easeOut(duration: 0.5).delay(0.5)) {
                textOpacity = 1.0
            }
        }
        .onDisappear {
            showChecklist = false
            showTrophy = false
            showBulb = false
            showStatusPill = false
            textOpacity = 0
        }
    }
}

// Reusable quiz badge icon
struct QuizBadge: View {
    let icon: String
    let secondaryIcon: String?
    let gradientColors: [Color]
    let size: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.25)
                .fill(
                    LinearGradient(
                        colors: gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
                .shadow(color: gradientColors[0].opacity(0.4), radius: 12, x: 0, y: 6)
            
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: size * 0.35, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.9))
                
                if let secondary = secondaryIcon {
                    Image(systemName: secondary)
                        .font(.system(size: size * 0.2, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.6))
                }
            }
        }
    }
}

#Preview {
    OnboardingView(hasSeenOnboarding: .constant(false))
        .preferredColorScheme(.dark)
}
