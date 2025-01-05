//
//  SettingsView.swift
//  52 Push
//
//  Created by Wyatt O. Combs on 1/4/25.
//


import SwiftUI

struct SettingsView: View {
    @ObservedObject private var viewModel = SettingsViewModel()

    var body: some View {
        Form {
            Toggle("Ace Last", isOn: $viewModel.settings.aceLast)
            Toggle("Include Jokers", isOn: $viewModel.settings.includeJokers)
            Toggle("Gamble Mode", isOn: $viewModel.settings.gambleMode)
        }
        .navigationTitle("Settings")
        .onDisappear {
            viewModel.saveSettings()
        }
    }
}
