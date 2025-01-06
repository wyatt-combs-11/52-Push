//
//  SettingsViewModel.swift
//  52 Push
//
//  Created by Wyatt O. Combs on 1/4/25.
//


import Foundation

class SettingsViewModel: ObservableObject {
    @Published var settings: Settings
    private let persistence = PersistenceService.shared

    init() {
        self.settings = persistence.getSettings()
    }

    func saveSettings() {
        persistence.saveSettings(settings)
    }
}
