import SwiftUI

/// A generic view that renders a "View more" navigation link and allows you to pass in any destination view.
///
/// - Parameters:
///   - destination: The view that the user will navigate to when tapping the "View more" link.
///
/// The button will render with the "View more →" label and will push the passed in view..
struct ViewMoreButton<Destination: View>: View {
    let destination: Destination
    var body: some View {
        NavigationLink("View more \u{2192}") {
            destination
        }
        .foregroundStyle(Color.PresetColour.whitePrimary)
        .font(.callout)
    }
}

#Preview {
    NavigationStack {
        ViewMoreButton(destination: Text("New stacked view"))
    }
}
