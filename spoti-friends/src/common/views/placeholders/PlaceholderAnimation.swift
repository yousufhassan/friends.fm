import SwiftUI

struct PlaceholderAnimation: ViewModifier {
    @State private var isAnimating = false
    
    let duration: Double
    let minOpacity: Double
    
    func body(content: Content) -> some View {
        content
            .opacity(isAnimating ? minOpacity : 1.0)
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: duration)
                        .repeatForever(autoreverses: true)
                ) {
                    isAnimating.toggle()
                }
            }
    }
}

extension View {
    func animatePlaceholder(duration: Double = 1, minOpacity: Double = 0.4) -> some View {
        self.modifier(PlaceholderAnimation(duration: duration, minOpacity: minOpacity))
    }
}

