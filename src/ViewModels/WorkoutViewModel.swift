//
//  WorkoutViewModel.swift
//  52 Push
//
//  Created by Wyatt O. Combs on 1/4/25.
//


import Foundation

class WorkoutViewModel: ObservableObject {
    @Published var deck: [Card] = []
    @Published var currentCards: [Card] = []
    @Published var pushupsCompleted: Int = 0
    @Published var currentWorkoutPushups: Int = 0

    private let persistence = PersistenceService.shared
    private let settings: Settings

    init() {
        self.settings = persistence.loadSettings()
        self.pushupsCompleted = persistence.loadStats()
        self.deck = persistence.loadDeck()
        if deck.isEmpty {
            shuffleDeck()
        }
    }

    func shuffleDeck() {
        var cards: [Card] = []
        let suits = ["hearts", "spades", "diamonds", "clubs"]
        let faceCardValues = [11: "jack", 12: "queen", 13: "king"]

        for suit in suits {
            for value in 1...13 {
                let cardValue = value == 1 ? 25 : (value > 10 ? 10 : value)
                let cardName = value == 1 ? "ace" : (faceCardValues[value] ?? "\(value)")
                cards.append(Card(value: cardValue, suit: suit, imageName: "\(cardName)_of_\(suit)"))
            }
        }

        if settings.includeJokers {
            cards.append(Card(value: 50, suit: "joker", imageName: "black_joker"))
            cards.append(Card(value: 50, suit: "joker", imageName: "red_joker"))
        }

        if settings.aceLast {
            let aceCards = cards.filter { $0.value == 25 }
            cards.removeAll { $0.value == 25 }
            cards.append(contentsOf: aceCards)
        }

        deck = cards.shuffled()
        persistence.saveDeck(deck)
    }


    func drawCard() {
        currentCards.removeAll()

        guard !deck.isEmpty else { return }
        let count = settings.gambleMode ? 2 : 1
        for _ in 0..<count {
            if let card = deck.popLast() {
                currentCards.append(card)
                currentWorkoutPushups += card.value
                pushupsCompleted += card.value
            }
        }
        persistence.saveDeck(deck)
        persistence.saveStats(pushupsCompleted)
    }
}
