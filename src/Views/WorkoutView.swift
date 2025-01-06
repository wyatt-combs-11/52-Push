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
    @State private var isAnimating = false
    @State private var visibleCards: [Card] = []
    @State private var dealLeft = false
    // computed property for text color
    var textColor: Color {
        settingsViewModel.settings.darkMode ? Color.white : Color.black
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: settingsViewModel.settings.darkMode
                    ? [Color.black, Color.gray]
                    : [Color.blue.opacity(0.1), Color.white]
                ),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Round Pushups: \(viewModel.currentRoundPushups)").foregroundColor(textColor)
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
                                .offset(x: (isAnimating ? 0 : (self.dealLeft ? -1 : 1) * 800) + card.offset.width, y: 0 + card.offset.height)
                                .rotationEffect(Angle(degrees: card.rotationAngle))
                                .animation(.easeOut(duration: 0.5), value: isAnimating)
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
            .onAppear {
                isAnimating = true
            }
        }
    }

    private func drawNewCard() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            visibleCards = []
            isAnimating = false
            
            viewModel.drawCard()
            visibleCards = viewModel.cardHistory.last ?? []

            // Animate the new card(s) into view
            withAnimation {
                isAnimating = true
            }
        }
        self.dealLeft.toggle()
    }
    
    private func shuffleDeck() {
        viewModel.shuffleDeck()
        visibleCards = []
    }
}

