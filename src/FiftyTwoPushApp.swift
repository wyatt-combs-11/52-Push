//
//  FiftyTwoPushApp.swift
//  52 Push
//
//  Created by Wyatt O. Combs on 1/4/25.
//

import SwiftUI

@main
struct FiftyTwoPushApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                WorkoutView(viewModel: WorkoutViewModel())
                    .tabItem {
                        Label("Workout", systemImage: "flame.fill")
                    }

                StatsView(viewModel: StatsViewModel())
                    .tabItem {
                        Label("Stats", systemImage: "chart.bar.fill")
                    }

                NavigationView {
                    SettingsView()
                }
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
            }
        }
    }
}

