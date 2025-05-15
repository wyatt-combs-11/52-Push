//
//  ShakeEffect.swift
//  52 Push
//
//  Created by Wyatt O. Combs on 1/7/25.
//
import SwiftUI

struct ShakeEffect: GeometryEffect {
    var amplitude: CGFloat = 10
    var frequency: Double = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        let offset = amplitude * sin(animatableData * .pi * CGFloat(frequency))
        return ProjectionTransform(CGAffineTransform(translationX: offset, y: 0))
    }
}
