import SwiftUI

/// Renders the placeholder view for some text.
///
/// - Parameters:
///   - size: The size of the text placeholder to create.
struct TextPlaceholder: View {
    let size: PlaceholderSize
    let text: String
    @State private var isAnimating = false
    
    init(size: PlaceholderSize) {
        self.size = size
        
        switch size {
        case .small: self.text = "small text"
        case .medium: self.text = "kinda medium-ish text"
        case .large: self.text = "some very long text to render"
        case .extraLarge: self.text = "some very long text that is even longer"
        }
    }
    
    var body: some View {
        Text(text)
            .redacted(reason: .placeholder)
            .animatePlaceholder()
    }
}

#Preview {
    VStack (alignment: .leading) {
        TextPlaceholder(size: .small)
        TextPlaceholder(size: .medium)
        TextPlaceholder(size: .large)
        TextPlaceholder(size: .extraLarge)
    }
}
