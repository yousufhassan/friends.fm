import SwiftUI

// TODO: Add docs
struct SongSearchView: View {
    let searchBarPlaceholderText: String
    @Binding var isSearching: Bool
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            // Search bar with conditional cancel button
            HStack {
                SearchBar(placeholderText: searchBarPlaceholderText, searchText: $searchText)
                Button(action: {
                    withAnimation(.easeOut(duration: 0.2)) {
                        self.isSearching = false
                    }
                }) {
                    Text("Cancel")
                        .font(.footnote)
                        .foregroundStyle(Color.PresetColour.whitePrimary)
                }
            }
            .padding()
            
            Spacer() // To top-align the search bar when there are no results to show
            
            // Search results
            if (searchText != "") {
                ScrollView {
                    TrackList(tracks: [TrackMock.iRememberEverything, TrackMock.luxury, TrackMock.traitor])
                    .padding(.horizontal)
                }
                .scrollDismissesKeyboard(.immediately)
            }
        }
        .searchable(text: $searchText, prompt: searchBarPlaceholderText)
        .background(
            // Adding a clear background to capture taps to hide the keyboard
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    hideKeyboard()
                }
        )
    }
}

// Helper method to hide the keyboard
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    @Previewable @State var isSearching: Bool = true
    SongSearchView(searchBarPlaceholderText: "Search...", isSearching: $isSearching)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.PresetColour.darkgrey)
}
