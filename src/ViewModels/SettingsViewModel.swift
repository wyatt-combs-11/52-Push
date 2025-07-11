//
//  SettingsViewModel.swift
//  52 Push
//
//  Created by Wyatt O. Combs on 1/4/25.
//


import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var settings: Settings
    private let persistence = PersistenceService.shared

    init() {
        self.settings = persistence.getSettings()
    }

    func saveSettings() {
        persistence.saveSettings(settings)
    }
    
    func getTextColor() -> Color {
        return settings.darkMode ? Color.white : Color.black
    }
    
    func getBackgroundColor() -> Color {
        return settings.darkMode ? Color.black : Color.white
    }
    
    func getBackgroundGradient(colorTheme: ColorTheme) -> LinearGradient {
        return LinearGradient(
            gradient: Gradient(colors: [colorTheme.backgroundGradientTop, colorTheme.backgroundGradientBottom]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
