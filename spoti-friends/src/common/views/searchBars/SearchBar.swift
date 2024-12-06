import SwiftUI

/// A customizable search bar component.
///
/// Displays a text input field with a placeholder and a magnifying glass icon on the left.
///
/// - Parameters:
///   - placeholderText: The placeholder text displayed in the search bar.
///   - searchText: The text to search for.
///
/// - Returns: A View that renders the search bar.
struct SearchBar: View {
    var placeholderText: String
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            TextField("",
                      text: $searchText,
                      prompt: Text(placeholderText)
                .foregroundStyle(Color.PresetColour.whiteSecondary)
            )
            .font(.footnote)
            .padding(.vertical, 8)
            .padding(.horizontal, 36)
            .background(Color.PresetColour.blackSecondary)
            .foregroundStyle(Color.PresetColour.whitePrimary)
            .cornerRadius(8)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color.PresetColour.whitePrimary)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                    
                    if (!searchText.isEmpty) {
                        Button(action: {
                            self.searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 8)
                        }
                    }
                }
            )
            .padding(.horizontal, 0)
        }
    }
}

struct ContentView: View {
    @State private var searchText: String = ""
    
    var body: some View {
        VStack {
            SearchBar(placeholderText: "Search...", searchText: $searchText)
            Spacer()
        }
        .padding()
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
