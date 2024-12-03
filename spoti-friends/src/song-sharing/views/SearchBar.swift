import SwiftUI

/// A customizable search bar component.
///
/// Displays a text input field with a placeholder, magnifying glass icon on the left,
/// and a clear button on the right when the user starts typing.
///
/// - Parameters:
///   - placeholderText: The placeholder text displayed in the search bar.
///
/// - Returns: A View that renders the search bar.
struct SearchBar: View {
    var placeholderText: String
    @State private var searchText: String = ""
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            TextField("",
                      text: $searchText,
                      prompt: Text(placeholderText)
                .foregroundStyle(Color.PresetColour.blackSecondary)
            )
            .font(.callout)
            .padding(.vertical, 12)
            .padding(.horizontal, 32)
            .background(Color.PresetColour.whitePrimary)
            .foregroundStyle(Color.PresetColour.blackSecondary)
            .cornerRadius(8)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color.PresetColour.blackSecondary)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                    
                    if isEditing {
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
            .padding(.horizontal, 10)
            .onTapGesture {
                self.isEditing = true
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            SearchBar(placeholderText: "Search...")
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
