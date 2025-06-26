//
//  StatsView.swift
//  52 Push
//
//  Created by Wyatt O. Combs on 1/4/25.
//


import SwiftUI

struct StatsView: View {
    @ObservedObject var viewModel = StatsViewModel()
    @ObservedObject var settingsViewModel = SettingsViewModel()
    @Environment(\.colorTheme) var colorTheme

    var body: some View {
        ZStack {
            settingsViewModel.getBackgroundGradient(colorTheme: colorTheme)
                .opacity(1.0)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Total Pushups: \(viewModel.totalPushups)")
                    .foregroundColor(colorTheme.textPrimary)
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding()
            .onAppear {
                viewModel.updateTotalPushups()
            }
        }
    }
}
