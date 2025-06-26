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
    
    var colorTheme: ColorTheme {
        settingsViewModel.settings.darkMode ? DarkTheme() : LightTheme()
    }
    
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor.white.withAlphaComponent(0.7) : UIColor.black.withAlphaComponent(0.7)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [colorTheme.backgroundGradientTop, colorTheme.backgroundGradientBottom]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                TabView {
                    WorkoutView(viewModel: WorkoutViewModel(), settingsViewModel: settingsViewModel)
                        .environment(\ .colorTheme, colorTheme)
                        .tabItem {
                            Label("Workout", systemImage: "flame.fill")
                        }
                    
                    StatsView(viewModel: StatsViewModel())
                        .environment(\ .colorTheme, colorTheme)
                        .tabItem {
                            Label("Stats", systemImage: "chart.bar.fill")
                        }
                    
                    SettingsView(settingsViewModel: settingsViewModel)
                        .environment(\ .colorTheme, colorTheme)
                        .tabItem {
                            Label("Settings", systemImage: "gearshape.fill")
                        }
                }
                .background(settingsViewModel.settings.darkMode ? .black : .white)
                .accentColor(settingsViewModel.settings.darkMode ? .red : .black)
            }
        }
    }
}
