//
//  StatsView.swift
//  52 Push
//
//  Created by Wyatt O. Combs on 1/4/25.
//


import SwiftUI

struct StatsView: View {
    @ObservedObject var viewModel = StatsViewModel()

    var body: some View {
        VStack {
            Text("Total Pushups: \(viewModel.totalPushups)")
                .font(.title)
            Spacer()
        }
        .padding()
    }
}
