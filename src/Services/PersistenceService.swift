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
    private let settingsKey = "settingsKey"

    func saveStats(_ pushupsCompleted: Int) {
        UserDefaults.standard.set(pushupsCompleted, forKey: statsKey)
    }

    func loadStats() -> Int {
        UserDefaults.standard.integer(forKey: statsKey)
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

    func saveSettings(_ settings: Settings) {
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: settingsKey)
        }
    }

    func loadSettings() -> Settings {
        if let data = UserDefaults.standard.data(forKey: settingsKey),
           let settings = try? JSONDecoder().decode(Settings.self, from: data) {
            return settings
        }
        return Settings(aceLast: false, includeJokers: false, gambleMode: false)
    }
}
