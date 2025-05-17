//
//  FiftyTwoPushApp.swift
//  52 Push
//
//  Created by Wyatt O. Combs on 1/4/25.
//

import SwiftUI

@main
struct FiftyTwoPushApp: App {
    @StateObject var settingsViewModel = SettingsViewModel()
    
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor.white.withAlphaComponent(0.7) : UIColor.black.withAlphaComponent(0.7)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                TabView {
                    WorkoutView(viewModel: WorkoutViewModel(), settingsViewModel: settingsViewModel)
                        .tabItem {
                            Label("Workout", systemImage: "flame.fill")
                        }
                    
                    StatsView(viewModel: StatsViewModel(), settingsViewModel: settingsViewModel)
                        .tabItem {
                            Label("Stats", systemImage: "chart.bar.fill")
                        }
                    
                    SettingsView(settingsViewModel: settingsViewModel)
                        .tabItem {
                            Label("Settings", systemImage: "gearshape.fill")
                        }
                }
                .accentColor(color(for: settingsViewModel.settings.darkMode))
                .background(colorForTabBackground(darkMode: settingsViewModel.settings.darkMode))
            }
        }
    }
    
    private func color(for darkMode: Bool) -> Color {
        return darkMode ? Color.red : Color.black
    }
        
    private func colorForTabBackground(darkMode: Bool) -> Color {
        return darkMode ? Color.black : Color.white
    }
    
}

