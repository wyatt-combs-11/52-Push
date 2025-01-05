//
//  WorkoutView.swift
//  52 Push
//
//  Created by Wyatt O. Combs on 1/4/25.
//


import SwiftUI

struct WorkoutView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @State private var isAnimating = false
    @State private var visibleCards: [Card] = []

    var body: some View {
        VStack {
            Text("Total Pushups: \(viewModel.currentWorkoutPushups)")
                .font(.headline)
                .padding()

            HStack {
                ForEach(visibleCards) { card in
                    CardView(card: card)
                        .frame(width: 100, height: 150)
                        .offset(x: isAnimating ? 0 : -800, y: 0)
                        .opacity(isAnimating ? 1 : 0) // Hide card off-screen
                        .rotationEffect(Angle(degrees: card.rotationAngle))
                        .animation(.easeOut(duration: 0.5), value: isAnimating)
                }
            }

            Button(action: {
                drawNewCard()
            }) {
                Text("Draw Card")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .onAppear {
            isAnimating = true
        }
    }

    private func drawNewCard() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            visibleCards = [] // Clear old cards
            isAnimating = false
            viewModel.drawCard()
            visibleCards = viewModel.currentCards

            // Animate the new card(s) into view
            withAnimation {
                isAnimating = true
            }
        }
    }
}

