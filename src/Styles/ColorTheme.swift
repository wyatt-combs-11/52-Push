//
//  ColorTheme.swift
//  52 Push
//
//  Created by Wyatt O. Combs on 6/25/25.
//


// ColorTheme.swift

import SwiftUI

protocol ColorTheme {
    var backgroundGradientTop: Color { get }
    var backgroundGradientBottom: Color { get }

    var textPrimary: Color { get }
    var textSecondary: Color { get }
}

struct LightTheme: ColorTheme {
    // #eaf4ff
    let backgroundGradientTop = Color(red: 0.922, green: 0.949, blue: 1.0) // Light blue background
    let backgroundGradientBottom = Color.white

    let textPrimary = Color.black
    let textSecondary = Color.gray.opacity(0.7)
}

struct DarkTheme: ColorTheme {
    let backgroundGradientTop = Color(red: 0.1, green: 0.1, blue: 0.1) // Dark gray background
    let backgroundGradientBottom = Color(red: 0.2, green: 0.2, blue: 0.2)

    let textPrimary = Color.white
    let textSecondary = Color.gray.opacity(0.7)
}

// MARK: - EnvironmentKey for ColorTheme
private struct ColorThemeKey: EnvironmentKey {
    static let defaultValue: ColorTheme = LightTheme()
}

extension EnvironmentValues {
    var colorTheme: ColorTheme {
        get { self[ColorThemeKey.self] }
        set { self[ColorThemeKey.self] = newValue }
    }
}
