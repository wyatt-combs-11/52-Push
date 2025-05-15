//
//  PulseGlowEffect.swift
//  52 Push
//
//  Created by Wyatt O. Combs on 1/7/25.
//
import SwiftUI

struct PulseGlowEffect: ViewModifier {
    @State private var scale: CGFloat = 1.0
    @State private var glowOpacity: Double = 0.5
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .shadow(color: Color.yellow.opacity(glowOpacity), radius: 10)
            .onAppear {
                // Pulse effect: scale the text
                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                    scale = 1.1
                }
                // Glow effect: increase glow opacity
                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                    glowOpacity = 1.0
                }
            }
    }
}
