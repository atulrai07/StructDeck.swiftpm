// App Background View

import SwiftUI
extension Color {
    static let appBackground = Color(
        red: 12/255,
        green: 15/255,
        blue: 43/255
    )
}

struct particleGradientAppBackground: View {
    var body: some View {
        ZStack {
            //The Base Dark Color
            Color(red: 2/255, green: 6/255, blue: 11/255)
                .ignoresSafeArea()
            
            //Top Leading Glow
            RadialGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 20/255, green: 76/255, blue: 107/255), location: 0.0),
                    Gradient.Stop(color: Color(red: 15/255, green: 62/255, blue: 90/255), location: 0.15),
                    Gradient.Stop(color: Color(red: 11/255, green: 47/255, blue: 74/255), location: 0.40),
                    Gradient.Stop(color: Color(red: 8/255, green: 31/255, blue: 54/255).opacity(0.8), location: 0.65),
                    Gradient.Stop(color: Color(red: 5/255, green: 12/255, blue: 22/255).opacity(0.3), location: 0.85),
                    Gradient.Stop(color: Color.clear, location: 1.0)
                ],
                center: .topLeading,
                startRadius: 0,
                endRadius: 500
            )
            .ignoresSafeArea()
            
            //Bottom Trailing Glow
            RadialGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 20/255, green: 76/255, blue: 107/255), location: 0.0),
                    Gradient.Stop(color: Color(red: 15/255, green: 62/255, blue: 90/255), location: 0.15),
                    Gradient.Stop(color: Color(red: 11/255, green: 47/255, blue: 74/255), location: 0.40),
                    Gradient.Stop(color: Color(red: 8/255, green: 31/255, blue: 54/255).opacity(0.8), location: 0.65),
                    Gradient.Stop(color: Color(red: 5/255, green: 12/255, blue: 22/255).opacity(0.3), location: 0.85),
                    Gradient.Stop(color: Color.clear, location: 1.0)
                ],
                center: .bottomTrailing,
                startRadius: 0,
                endRadius: 500
            )
            .ignoresSafeArea()
            
            //The Interactive Grain Effect Layer
            ParticleEffectView()
                .allowsHitTesting(false)
        }
    }
}

struct gradientAppBackground: View {
    var body: some View {
        ZStack {
            Color(red: 2/255, green: 6/255, blue: 11/255) // #02060B
                .ignoresSafeArea()
            // Top Leading Glow
            RadialGradient(
                stops: [
                    
                    Gradient.Stop(color: Color(red: 20/255, green: 76/255, blue: 107/255), location: 0.0), // #144C6B
                    
                    Gradient.Stop(color: Color(red: 15/255, green: 62/255, blue: 90/255), location: 0.15), // #0F3E5A
                    
                    Gradient.Stop(color: Color(red: 11/255, green: 47/255, blue: 74/255), location: 0.40), // #0B2F4A
                    
                    Gradient.Stop(color: Color(red: 8/255, green: 31/255, blue: 54/255).opacity(0.8), location: 0.65), // #081F36
                    
                    Gradient.Stop(color: Color(red: 5/255, green: 12/255, blue: 22/255).opacity(0.3), location: 0.85), // #050C16
            
                    Gradient.Stop(color: Color.clear, location: 1.0) // Fades to clear so it blends with the base color
                    
                ],
                center: .topLeading,
                startRadius: 0,
                endRadius: 500
            )
            .ignoresSafeArea()
            // Bottom Trailing Glow
            RadialGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 20/255, green: 76/255, blue: 107/255), location: 0.0),
                    Gradient.Stop(color: Color(red: 15/255, green: 62/255, blue: 90/255), location: 0.15),
                    Gradient.Stop(color: Color(red: 11/255, green: 47/255, blue: 74/255), location: 0.40),
                    Gradient.Stop(color: Color(red: 8/255, green: 31/255, blue: 54/255).opacity(0.8), location: 0.65),
                    Gradient.Stop(color: Color(red: 5/255, green: 12/255, blue: 22/255).opacity(0.3), location: 0.85),
                    Gradient.Stop(color: Color.clear, location: 1.0)
                ],
                center: .bottomTrailing,
                startRadius: 0,
                endRadius: 500
                
            )
            .ignoresSafeArea()
        }
    }
}

#Preview{
    gradientAppBackground()
}

