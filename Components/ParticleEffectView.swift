//
//  ParticleEffectView.swift
//  StructDeck
//
//  Created by Atul on 24/02/26.
//

import SwiftUI
import Combine
import UIKit

// MARK: - Particle Model
struct Particle {
    var x: Double
    var y: Double
    var originX: Double
    var originY: Double
    var vx: Double = 0
    var vy: Double = 0
    var driftVX: Double
    var driftVY: Double
    var size: Double
    var opacity: Double
}

// MARK: - Particle System (drives the animation loop)
final class ParticleSystem: ObservableObject {

    @Published var tick: Int = 0

    // Physics tuning
    private let particleCount = 500
    private let repulsionRadius = 90.0
    private let repulsionForce = 15.0
    private let returnSpeed = 0.035
    private let friction = 0.80
    private let maxDrift = 0.30

    private(set) var particles: [Particle] = []
    private(set) var canvasSize: CGSize = .zero
    var touchPoint: CGPoint? = nil

    private var displayLink: AnyCancellable?

    func setup(size: CGSize) {
        guard size.width > 1, size.height > 1 else { return }
        guard abs(canvasSize.width - size.width) > 2 || particles.isEmpty else { return }
        canvasSize = size
        spawnParticles(in: size)
        startLoop()
    }

    private func spawnParticles(in size: CGSize) {
        particles = (0..<particleCount).map { _ in
            let x = Double.random(in: 0...size.width)
            let y = Double.random(in: 0...size.height)
            return Particle(
                x: x, y: y,
                originX: x, originY: y,
                driftVX: Double.random(in: -maxDrift...maxDrift),
                driftVY: Double.random(in: -maxDrift...maxDrift),
                size: Double.random(in: 1.2...3.5),
                opacity: Double.random(in: 0.3...0.9)
            )
        }
    }

    private func startLoop() {
        displayLink?.cancel()
        displayLink = Timer.publish(every: 1.0 / 60.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.update()
            }
    }

    private func update() {
        let width  = canvasSize.width
        let height = canvasSize.height
        let touch  = touchPoint

        for i in particles.indices {
            var p = particles[i]

            // 1. Repulsion from finger
            if let tp = touch {
                let dx   = p.x - Double(tp.x)
                let dy   = p.y - Double(tp.y)
                let dist = (dx * dx + dy * dy).squareRoot()
                if dist < repulsionRadius && dist > 0.5 {
                    let strength = repulsionForce * (1.0 - dist / repulsionRadius)
                    p.vx += (dx / dist) * strength
                    p.vy += (dy / dist) * strength
                }
            }

            // 2. Spring back toward origin
            p.vx += (p.originX - p.x) * returnSpeed
            p.vy += (p.originY - p.y) * returnSpeed

            // 3. Friction damping
            p.vx *= friction
            p.vy *= friction

            // 4. Integrate position
            p.x += p.vx
            p.y += p.vy

            // 5. Slowly drift the origin
            p.originX += p.driftVX * 0.04
            p.originY += p.driftVY * 0.04

            // Wrap origin at screen edges
            if p.originX < -10        { p.originX = width + 10  }
            if p.originX > width + 10  { p.originX = -10         }
            if p.originY < -10        { p.originY = height + 10 }
            if p.originY > height + 10 { p.originY = -10         }

            particles[i] = p
        }

        tick &+= 1
    }

    deinit {
        displayLink?.cancel()
    }
}

// MARK: - Global Window Touch Tracker
// This allows the background to see touches even if a ScrollView is on top of it.
struct WindowTouchTracker: UIViewRepresentable {
    var onTouch: (CGPoint?) -> Void

    func makeUIView(context: Context) -> UIView {
        let view = TouchTrackingUIView()
        view.onTouch = onTouch
        view.backgroundColor = .clear
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

class TouchTrackingUIView: UIView {
    var onTouch: ((CGPoint?) -> Void)?
    private var gesture: GlobalTouchRecognizer?

    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        if let oldGesture = gesture, let oldWindow = oldGesture.view {
            oldWindow.removeGestureRecognizer(oldGesture)
        }
        
        if let window = self.window {
            let newGesture = GlobalTouchRecognizer()
            newGesture.onTouch = { [weak self] point in
                self?.onTouch?(point)
            }
            // Crucial settings to avoid breaking your app's main interactions
            newGesture.cancelsTouchesInView = false
            newGesture.delaysTouchesBegan = false
            newGesture.delegate = newGesture
            window.addGestureRecognizer(newGesture)
            self.gesture = newGesture
        }
    }
}

class GlobalTouchRecognizer: UIGestureRecognizer, UIGestureRecognizerDelegate {
    var onTouch: ((CGPoint?) -> Void)?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        state = .began
        onTouch?(touches.first?.location(in: nil))
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        state = .changed
        onTouch?(touches.first?.location(in: nil))
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        state = .ended
        onTouch?(nil)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        state = .cancelled
        onTouch?(nil)
    }

    // Allows normal app gestures (like scrolling) to continue simultaneously
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


// MARK: - ParticleEffectView
struct ParticleEffectView: View {
    @StateObject private var system = ParticleSystem()

    var body: some View {
        GeometryReader { geo in
            let _ = system.tick

            Canvas { context, size in
                for p in system.particles {
                    guard p.x > -5, p.x < size.width + 5,
                          p.y > -5, p.y < size.height + 5 else { continue }

                    let speed     = (p.vx * p.vx + p.vy * p.vy).squareRoot()
                    let energized = min(speed / 12.0, 1.0)

                    let color = Color(
                        hue: 0.60 - energized * 0.10,
                        saturation: max(0, 0.35 - energized * 0.35),
                        brightness: 0.75 + energized * 0.25
                    ).opacity(p.opacity)

                    let drawSize = p.size + energized * 1.8

                    context.fill(
                        Path(ellipseIn: CGRect(
                            x: p.x - drawSize / 2,
                            y: p.y - drawSize / 2,
                            width: drawSize,
                            height: drawSize
                        )),
                        with: .color(color)
                    )
                }
            }
            .onAppear {
                system.setup(size: geo.size)
            }
            .onChange(of: geo.size) { newSize in
                system.setup(size: newSize)
            }
            .background(
                WindowTouchTracker { location in
                    system.touchPoint = location
                }
            )
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ZStack {
        Color.black
            .ignoresSafeArea()
        
        ParticleEffectView()
    }
}
