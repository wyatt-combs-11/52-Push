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
    @State private var cardIsAnimating = false
    @State private var messageIsAnimating = false
    @State private var visibleCards: [Card] = []
    @State private var dealLeft = false
    @State private var overlayMessage: String = ""
    @State private var showMessage = false
    @State private var overlayRotation: Double = 0

    var textColor: Color {
        settingsViewModel.getTextColor()
    }

    var body: some View {
        ZStack {
            settingsViewModel.getBackgroundGradient()
            .opacity(1.0)
            .ignoresSafeArea()
            
            Rectangle()
                .fill(Color.black.opacity(0.05))
                .ignoresSafeArea()

            VStack {
                Spacer()
                // Show all pushups for visible cards in a text view
                Text("Round Pushups: \(visibleCards.map { $0.value }.reduce(0, +))").foregroundColor(textColor)
                        .font(.title).bold()
                        .padding(.bottom, 5)
                Text("Current Pushup Total: \(viewModel.currentWorkoutPushups)").foregroundColor(textColor)
                    .font(.headline)
                Text("Cards Left: \(viewModel.deck.count)").foregroundColor(textColor)
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
                
                Spacer()
                
                HStack(spacing: 16) {
                    Button(action: {
                        drawNewCard()
                    }) {
                        HStack {
                            Image(systemName: "rectangle.stack.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24) // Standardized icon size
                            Text("Draw Card")
                                .fontWeight(.semibold)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 50) // Consistent height
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    
                    Button(action: {
                        shuffleDeck()
                    }) {
                        HStack {
                            Image(systemName: "shuffle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24) // Standardized icon size
                            Text("Shuffle Deck")
                                .fontWeight(.semibold)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 50) // Consistent height
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
}

