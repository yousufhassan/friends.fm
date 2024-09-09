import SwiftUI

struct ViewMoreButton: View {
    var body: some View {
        Text("View more \u{2192}")
            .foregroundStyle(Color.PresetColour.whitePrimary)
            .font(.callout)
    }
}

#Preview {
    ViewMoreButton()
}
