//
//  CardView.swift
//  52 Push
//
//  Created by Wyatt O. Combs on 1/5/25.
//


import SwiftUI

struct CardView: View {
    let card: Card

    var body: some View {
        ZStack {
            // White background with a subtle shadow
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(radius: 5)

            // Card image
            Image(card.imageName)
                .resizable()
                .scaledToFit()
                .padding(5) // Padding to avoid touching the border
        }
        .frame(width: 150, height: 225) // Standard card dimensions
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black, lineWidth: 1) // Black border
        )
    }
}
