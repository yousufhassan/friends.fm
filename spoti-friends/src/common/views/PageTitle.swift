import SwiftUI

/// Renders the title for a Swift View
struct PageTitle: View {
    let pageTitle: String
    
    var body: some View {
        HStack {
            Text(pageTitle)
                .foregroundStyle(Color.PresetColour.whitePrimary)
                .font(.title)
                .fontWeight(.medium)
            
            Spacer()
        }
    }
}

#Preview {
    PageTitle(pageTitle: "Example Title")
}
