import SwiftUI

/// Defines the animation style for loading placeholders.
/// This is used mainly to create a SwiftUI View modifier to simplify the animation of different placeholders.
struct PlaceholderAnimation: ViewModifier {
    @State private var isAnimating = false
    
    let duration: Double
    
    func body(content: Content) -> some View {
        content
            .opacity(isAnimating ? 0.4 : 1.0)
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
    /// The SwiftUI View modifier to animate a loading placeholder.
    ///
    /// - Parameters:
    ///   - duration: The animation duration in seconds (optional). Default: 1.
    func animatePlaceholder(duration: Double = 1) -> some View {
        self.modifier(PlaceholderAnimation(duration: duration))
    }
}

