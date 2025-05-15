//
//  WorkoutViewModel.swift
//  52 Push
//
//  Created by Wyatt O. Combs on 1/4/25.
//


import Foundation

class WorkoutViewModel: ObservableObject {
    @Published var deck: [Card] = []
    @Published var cardHistory: [[Card]] = []
    @Published var currentCards: [Card] = []
    @Published var currentWorkoutPushups: Int = 0

    private let persistence = PersistenceService.shared

    init() {
        self.currentWorkoutPushups = persistence.getStats().currentWorkoutPushups
        self.deck = persistence.loadDeck()
        self.cardHistory = persistence.loadCardHistory()
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
                cards.append(Card(value: cardValue, number: value, suit: suit, imageName: "\(cardName)_of_\(suit)"))
            }
        }

        if persistence.getSettings().includeJokers {
            cards.append(Card(value: 50, number: 0, suit: "joker", imageName: "black_joker"))
            cards.append(Card(value: 50, number: 0, suit: "joker", imageName: "red_joker"))
        }
        
        if persistence.getSettings().liteMode {
            cards = cards.filter { $0.number < 10 && $0.number > 1 }
        }
        
        deck = cards.shuffled()

        if persistence.getSettings().aceLast, let firstAceCardIndex = deck.firstIndex(where: { $0.value == 25 }) {
            let firstAceCard = deck[firstAceCardIndex]
            deck.remove(at: firstAceCardIndex)
            deck = deck.shuffled()
            // add first ace to beginning of deck
            deck.insert(firstAceCard, at: 0)
        }

        var currentStats = persistence.getStats()
        currentStats.currentWorkoutPushups = 0
        self.currentWorkoutPushups = 0
        self.cardHistory = []
        self.currentCards = []
        
        persistence.saveDeck(deck)
        persistence.saveCardHistory([[]])
        persistence.saveStats(currentStats)
    }


    func drawCard() -> String? {
        var currentCards: [Card] = []
        var currentRoundPushups = 0

        guard !deck.isEmpty else { return nil }
        let count = persistence.getSettings().gambleMode ? 2 : 1
        for _ in 0..<count {
            if let card = deck.popLast() {
                currentCards.append(card)
                currentRoundPushups += card.value
            }
        }
        
        var currentStats = persistence.getStats()
        currentStats.currentWorkoutPushups = currentStats.currentWorkoutPushups + currentRoundPushups
        currentStats.lifetimePushups = currentStats.lifetimePushups + currentRoundPushups
        self.currentWorkoutPushups = currentStats.currentWorkoutPushups
        
        cardHistory.append(currentCards)
        
        persistence.saveDeck(deck)
        persistence.saveCardHistory(cardHistory)
        persistence.saveStats(currentStats)
        
        return checkSpecialCondition(for: currentCards)
    }
    
    private func checkSpecialCondition(for cards: [Card]) -> String? {
        let cardValues = cards.map { $0.value }
        if cardValues.contains(10), cardValues.contains(25) {
            return "Blackjack!"
        }
        else if cardValues.filter({ $0 == 50 }).count == 2 {
            return "That REALLY Sucks..."
        }
        else if cardValues.filter({ $0 == 25 }).count == 2 {
            return "That Sucks..."
        }
        else if cardValues.contains(6) && cardValues.contains(9) {
            return "Haha, nice!"
        }
        else if cardValues.count == 2 && cards[0].number == cards[1].number {
            return "Double Down!"
        }
        else if cards.count == 1 && cards[0].value == 50 {
            return "Hurry Up!"
        }
        return nil
    }
}
