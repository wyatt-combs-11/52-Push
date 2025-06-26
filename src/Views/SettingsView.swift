//
//  SettingsView.swift
//  52 Push
//
//  Created by Wyatt O. Combs on 1/4/25.
//


import SwiftUI

struct SettingsView: View {
    @ObservedObject var settingsViewModel: SettingsViewModel
    @Environment(\.colorTheme) private var colorTheme
    
    init(settingsViewModel: SettingsViewModel) {
        UITableView.appearance().backgroundColor = .clear
        self.settingsViewModel = settingsViewModel
    }

    var body: some View {
        ZStack {
            settingsViewModel.getBackgroundGradient(colorTheme: colorTheme)
                .opacity(1.0)
                .ignoresSafeArea()

            if #available(iOS 16, *) {
                createForm()
                .scrollContentBackground(.hidden)
            } else {
                createForm()
            }
        }
    }
    
    private func createForm() -> some View {
        return Form {
            Toggle("Dark Mode", isOn: $settingsViewModel.settings.darkMode)
                .listRowBackground(Color.clear)
            Toggle("Ace Last", isOn: $settingsViewModel.settings.aceLast)
                .listRowBackground(Color.clear)
            Toggle("Include Jokers", isOn: $settingsViewModel.settings.includeJokers)
                .listRowBackground(Color.clear)
            Toggle("Gamble Mode", isOn: $settingsViewModel.settings.gambleMode)
                .listRowBackground(Color.clear)
            Toggle("Lite Mode", isOn: $settingsViewModel.settings.liteMode)
                .listRowBackground(Color.clear)
        }
        .foregroundColor(settingsViewModel.getTextColor())
        .navigationTitle("Settings")
        .onDisappear {
            settingsViewModel.saveSettings()
        }
    }
}
    
