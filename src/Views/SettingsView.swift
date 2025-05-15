//
//  SettingsView.swift
//  52 Push
//
//  Created by Wyatt O. Combs on 1/4/25.
//


import SwiftUI

struct SettingsView: View {
    @ObservedObject var settingsViewModel: SettingsViewModel

    var body: some View {
        Form {
            Toggle("Dark Mode", isOn: $settingsViewModel.settings.darkMode)
            Toggle("Ace Last", isOn: $settingsViewModel.settings.aceLast)
            Toggle("Include Jokers", isOn: $settingsViewModel.settings.includeJokers)
            Toggle("Gamble Mode", isOn: $settingsViewModel.settings.gambleMode)
            Toggle("Lite Mode", isOn: $settingsViewModel.settings.liteMode)
        }
        .navigationTitle("Settings")
        .onDisappear {
            settingsViewModel.saveSettings()
        }
    }
}
