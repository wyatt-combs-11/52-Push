//
//  StatsViewModel.swift
//  52 Push
//
//  Created by Wyatt O. Combs on 1/4/25.
//


import Foundation

class StatsViewModel: ObservableObject {
    @Published var totalPushups: Int

    private let persistence = PersistenceService.shared

    init() {
        self.totalPushups = persistence.loadStats()
    }
}
