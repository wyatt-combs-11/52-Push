//
//  ConfettiView.swift
//  52 Push
//
//  Created by Wyatt O. Combs on 6/23/25.
//


import SwiftUI

struct ConfettiView: View {
    @State private var confettiItems: [ConfettiItem] = []
    @State private var isEmitting = true
    @State private var startTime: Date? = nil
    // Number of confetti particles
    private let confettiCount = 200
    private let emissionDuration: TimeInterval = 2.0
    private let baseSpeed: CGFloat = 3.0
    private let speedVariation: CGFloat = 1.0
    private let cannonCenterSpread: CGFloat = 0.5 // percent of width for cannon burst
    private let vxRange: ClosedRange<CGFloat> = -2.5...2.5 // horizontal velocity range
    private let vyRange: ClosedRange<CGFloat> = 2.0...5.0 // vertical velocity range
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(confettiItems) { item in
                    ConfettiParticle(item: item)
                }
            }
            .onAppear {
                startTime = Date()
                isEmitting = true
                let center = geo.size.width / 2
                let spread = geo.size.width * cannonCenterSpread / 2
                confettiItems = (0..<confettiCount).map { _ in
                    ConfettiItem(
                        x: CGFloat.random(in: (center - spread)...(center + spread)),
                        y: ((1 - cannonCenterSpread) * center) - CGFloat.random(in: (center - spread)...(center + spread)),
                        vx: CGFloat.random(in: vxRange),
                        vy: CGFloat.random(in: vyRange),
                        rotation3D: (
                            x: Double.random(in: 0...360),
                            y: Double.random(in: 0...360),
                            z: Double.random(in: 0...360)
                        ),
                        rotation3DSpeed: (
                            x: Double.random(in: 0.5...2.0) * (Bool.random() ? 1 : -1),
                            y: Double.random(in: 0.5...2.0) * (Bool.random() ? 1 : -1),
                            z: Double.random(in: 0.5...2.0) * (Bool.random() ? 1 : -1)
                        ),
                        color: Color(hue: Double.random(in: 0...1),
                                     saturation: 0.8,
                                     brightness: 0.9),
                        size: CGFloat.random(in: 6...12)
                    )
                }
            }
            .onReceive(Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()) { now in
                guard let start = startTime else { return }
                let elapsed = now.timeIntervalSince(start)
                if elapsed > emissionDuration {
                    isEmitting = false
                }
                let width = geo.size.width
                let height = geo.size.height
                // Remove confetti that are out of bounds (too low, too left, too right)
                confettiItems.removeAll { item in
                    item.y > height || item.x < 0 || item.x > width
                }
                // Update each particle
                for index in confettiItems.indices {
                    confettiItems[index].x += confettiItems[index].vx
                    confettiItems[index].y += confettiItems[index].vy
                    confettiItems[index].rotation3D.x += confettiItems[index].rotation3DSpeed.x
                    confettiItems[index].rotation3D.y += confettiItems[index].rotation3DSpeed.y
                    confettiItems[index].rotation3D.z += confettiItems[index].rotation3DSpeed.z
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct ConfettiItem: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var vx: CGFloat
    var vy: CGFloat
    var rotation3D: (x: Double, y: Double, z: Double)
    var rotation3DSpeed: (x: Double, y: Double, z: Double)
    var color: Color
    var size: CGFloat
}

struct ConfettiParticle: View {
    let item: ConfettiItem
    
    var body: some View {
        // A rectangle is used to simulate a confetti piece.
        Rectangle()
            .fill(item.color)
            .frame(width: item.size, height: item.size * 0.75)
            .rotation3DEffect(.degrees(item.rotation3D.x), axis: (x: 1, y: 0, z: 0))
            .rotation3DEffect(.degrees(item.rotation3D.y), axis: (x: 0, y: 1, z: 0))
            .rotation3DEffect(.degrees(item.rotation3D.z), axis: (x: 0, y: 0, z: 1))
            .position(x: item.x, y: item.y)
    }
}
