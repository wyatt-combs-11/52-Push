//
//  WorkoutView.swift
//  52 Push
//
//  Created by Wyatt O. Combs on 1/4/25.
//


import SwiftUI

struct WorkoutView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @ObservedObject var settingsViewModel: SettingsViewModel
    @Environment(\.colorTheme) var colorTheme
    @State private var cardIsAnimating = false
    @State private var messageIsAnimating = false
    @State private var visibleCards: [Card] = []
    @State private var dealLeft = false
    @State private var overlayMessage: String = ""
    @State private var showMessage = false
    @State private var overlayRotation: Double = 0
    @State private var showConfetti = false
    @State private var showCongratulationsModal = false
    
    private var statsText: String {
        "Total Pushups: \(viewModel.currentWorkoutPushups)\nRounds: \(viewModel.cardHistory.count)"
    }

    var textColor: Color {
        settingsViewModel.getTextColor()
    }
    
    // Computed property for correct pushup total
    private var totalPushups: Int {
        viewModel.cardHistory.last?.map { $0.value }.reduce(0, +) ?? 0
    }

    var body: some View {
        ZStack {
            settingsViewModel.getBackgroundGradient(colorTheme: colorTheme)
                .opacity(1.0)
                .ignoresSafeArea()
                .contentShape(Rectangle())
            
            Rectangle()
                .fill(Color.black.opacity(0.05))
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture {
                    drawNewCard()
                }

            VStack {
                Spacer()
                Text("Round Pushups: \(visibleCards.map { $0.value }.reduce(0, +))")
                    .foregroundColor(textColor)
                    .font(.title).bold()
                    .padding(.bottom, 5)
                Text("Current Pushup Total: \(totalPushups)")
                    .foregroundColor(textColor)
                    .font(.headline)
                Text("Cards Left: \(viewModel.deck.count)")
                    .foregroundColor(textColor)
                    .font(.headline)
                    .padding(.bottom)
                Spacer()
                ZStack {
                    ForEach(Array(viewModel.cardHistory.indices.dropLast()), id: \.self) { index in
                        HStack {
                            ForEach(viewModel.cardHistory[index]) { card in
                                CardView(card: card)
                                    .frame(width: 150, height: 225)
                                    .offset(x: 0 + card.offset.width, y: 0 + card.offset.height)
                                    .rotationEffect(Angle(degrees: card.rotationAngle))
                            }
                        }
                        .frame(height: 250)
                    }
                    HStack {
                        ForEach(visibleCards) { card in
                            CardView(card: card)
                                .frame(width: 150, height: 225)
                                .offset(x: (cardIsAnimating ? 0 : (self.dealLeft ? -1 : 1) * 800) + card.offset.width, y: 0 + card.offset.height)
                                .rotationEffect(Angle(degrees: card.rotationAngle))
                                .animation(.easeOut(duration: 0.5), value: cardIsAnimating)
                        }
                    }
                    .frame(height: 250)
                }
                .onAppear {
                    visibleCards = viewModel.cardHistory.last ?? []
                }
                .gesture(
                    DragGesture(minimumDistance: 30, coordinateSpace: .local)
                        .onEnded { value in
                            if value.translation.width < -30 {
                                goBackToPreviousCards()
                            }
                        }
                )
                Spacer()
                HStack(spacing: 16) {
                    Button(action: {
                        shuffleDeck()
                    }) {
                        HStack {
                            Image(systemName: "shuffle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                            Text("Shuffle Deck")
                                .fontWeight(.semibold)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                Spacer()
            }
//            .opacity(messageIsAnimating ? 0.25 : 1)
            .onAppear {
                cardIsAnimating = true
            }
            .onTapGesture {
                drawNewCard()
            }
            
            if showMessage {
                Color.white
                    .opacity(messageIsAnimating ? 0.8 : 0)
                    .blur(radius: 8)
                    .ignoresSafeArea()
                    .transition(.opacity)
                
                
                Text(overlayMessage)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                    .rotationEffect(Angle(degrees: (messageIsAnimating ? 1 : -1) * overlayRotation))
                    .scaleEffect(messageIsAnimating ? 1.5 : 0)
                    .lineLimit(nil)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
                    .multilineTextAlignment(.center)
                    .transition(.opacity)
                    .modifier(PulseGlowEffect())  // Apply Pulse and Glow effect here
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            messageIsAnimating.toggle() // Start scaling and fading in
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                messageIsAnimating.toggle() // Fade out and shrink
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                showMessage = false // Remove message
                            }
                        }
                    }
            }
            
            // Show confetti when triggered
            if showConfetti {
                ConfettiView()
                    .transition(.opacity)
            }
            // Show congratulations modal when triggered
            if showCongratulationsModal {
                CongratulationsModalView(stats: statsText) {
                    withAnimation {
                        showCongratulationsModal = false
                        showConfetti = false
                    }
                }
                .transition(.opacity)
            }
        }
    }

    private func drawNewCard() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            visibleCards = []
            cardIsAnimating = false
            let comboMessage = viewModel.drawCard()
            visibleCards = viewModel.cardHistory.last ?? []
            if comboMessage != nil {
                showOverlayMessage(comboMessage!)
                overlayRotation = Double.random(in: -20...20)
            }
            withAnimation {
                cardIsAnimating = true
            }
            // Show confetti and modal if deck is finished
            if viewModel.deck.isEmpty {
                withAnimation {
                    showConfetti = true
                    showCongratulationsModal = true
                }
            }
        }
        self.dealLeft.toggle()
    }
    
    private func showOverlayMessage(_ message: String) {
        overlayMessage = message
        showMessage = true
    }
    
    private func shuffleDeck() {
        viewModel.shuffleDeck()
        visibleCards = []
    }
    
    private func goBackToPreviousCards() {
        guard viewModel.cardHistory.count >= 1 else { return }
        // Remove the last drawn cards from history and restore them to the deck in reverse order
        let lastDrawnCards = viewModel.cardHistory.removeLast()
        viewModel.deck.append(contentsOf: lastDrawnCards.reversed())
        visibleCards = viewModel.cardHistory.last ?? []
        viewModel.currentWorkoutPushups -= lastDrawnCards.map { $0.value }.reduce(0, +)
    }
}
