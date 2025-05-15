//
//  PersistenceService.swift
//  52 Push
//
//  Created by Wyatt O. Combs on 1/4/25.
//


import Foundation

class PersistenceService {
    static let shared = PersistenceService()

    private let statsKey = "statsKey"
    private let deckKey = "deckKey"
    private let cardHistoryKey = "cardHistoryKey"
    private let settingsKey = "settingsKey"
    private var stats: Stats = Stats(lifetimePushups: 0, currentWorkoutPushups: 0)
    private var settings: Settings = Settings(darkMode: false, aceLast: false, includeJokers: false, gambleMode: false, liteMode: false)
    
    init() {
        self.loadStats()
        self.loadSettings()
    }
    
    func getStats() -> Stats {
        return stats
    }

    func saveStats(_ stats: Stats) {
        if let encoded = try? JSONEncoder().encode(stats) {
            UserDefaults.standard.set(encoded, forKey: statsKey)
            self.stats = stats
        }
    }

    func loadStats() {
        if let data = UserDefaults.standard.data(forKey: statsKey),
           let stats = try? JSONDecoder().decode(Stats.self, from: data) {
            self.stats = stats
        }
    }

    func saveDeck(_ deck: [Card]) {
        if let encoded = try? JSONEncoder().encode(deck) {
            UserDefaults.standard.set(encoded, forKey: deckKey)
        }
    }

    func loadDeck() -> [Card] {
        if let data = UserDefaults.standard.data(forKey: deckKey),
           let deck = try? JSONDecoder().decode([Card].self, from: data) {
            return deck
        }
        return []
    }
    
    func saveCardHistory(_ cardHistory: [[Card]]) {
        if let encoded = try? JSONEncoder().encode(cardHistory) {
            UserDefaults.standard.set(encoded, forKey: cardHistoryKey)
        }
    }
    
    func loadCardHistory() -> [[Card]] {
        if let data = UserDefaults.standard.data(forKey: cardHistoryKey),
           let cardHistory = try? JSONDecoder().decode([[Card]].self, from: data) {
            return cardHistory
        }
        return [[]]
    }
    
    func getSettings() -> Settings {
        return settings
    }

    func saveSettings(_ settings: Settings) {
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: settingsKey)
            self.settings = settings
        }
    }

    func loadSettings() {
        if let data = UserDefaults.standard.data(forKey: settingsKey),
           let settings = try? JSONDecoder().decode(Settings.self, from: data) {
            self.settings = settings
        }
    }
}
