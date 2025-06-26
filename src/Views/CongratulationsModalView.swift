import SwiftUI

struct CongratulationsModalView: View {
    let stats: String?
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            // Dimmed background for tap-to-dismiss
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }
            
            VStack(spacing: 24) {
                Text("Congratulations!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                if let stats = stats {
                    Text(stats)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                }
                Button(action: onDismiss) {
                    Text("Close")
                        .font(.headline)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 20)
            .padding(.horizontal, 32)
        }
    }
}
