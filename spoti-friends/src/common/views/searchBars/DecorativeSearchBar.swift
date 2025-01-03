import SwiftUI

/// A search bar component that is just for decoration; it is not functional.
///
/// Displays a text input field with a placeholder and a magnifying glass icon on the left.
///
/// - Parameters:
///   - placeholderText: The placeholder text displayed in the search bar.
///
struct DecorativeSearchBar: View {
    var placeholderText: String
    
    var body: some View {
        HStack {
            Text(placeholderText)
                .font(.callout)
                .foregroundStyle(Color.PresetColour.blackSecondary)
                .padding(.vertical, 12)
                .padding(.horizontal, 32)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.PresetColour.whitePrimary)
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color.PresetColour.blackSecondary)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                    }
                )
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 10)
        .contentShape(Rectangle())
    }
}


#Preview {
    DecorativeSearchBar(placeholderText: "Search...")
}
