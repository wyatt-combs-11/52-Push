//
//  Card.swift
//  52 Push
//
//  Created by Wyatt O. Combs on 1/4/25.
//


import Foundation

struct Card: Identifiable, Codable {
    var id = UUID()
    let value: Int
    let suit: String
    let imageName: String
    var rotationAngle: Double = Double.random(in: -10...10)
}
