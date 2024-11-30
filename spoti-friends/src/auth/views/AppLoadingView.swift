import SwiftUI

/// A loading animation view that displays three bouncing dots.
///
/// This view creates an animated loading indicator using three circles that bounce
/// vertically in a staggered sequence.
struct AppLoadingView: View {
    @State private var dotOffset: [CGFloat] = [0, 0, 0]
    
    var body: some View {
        HStack(spacing: 16) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.PresetColour.spotifyGreen)
                    .frame(width: 20, height: 20)
                    .offset(y: dotOffset[index])
                    .animation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.2),
                        value: dotOffset[index]
                    )
                    .onAppear {
                        dotOffset[index] = -30 // Change to adjust the bounce height
                    }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.PresetColour.darkgrey)
    }
}

struct LoadingDots_Previews: PreviewProvider {
    static var previews: some View {
        AppLoadingView()
    }
}
