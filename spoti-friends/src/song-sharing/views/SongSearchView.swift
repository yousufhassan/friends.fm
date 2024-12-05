import SwiftUI

// TODO: Add docs
struct SongSearchView: View {
    let searchBarPlaceholderText: String
    @Binding var isSearching: Bool
    @State private var searchText = ""
    @FocusState private var isSearchFieldFocused: Bool
    @State private var selectedTrack: Track?
    
    var body: some View {
        VStack {
            // Search bar with conditional cancel button
            HStack {
                SearchBar(placeholderText: searchBarPlaceholderText, searchText: $searchText)
                    .focused($isSearchFieldFocused)
                
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
            
            // Search results
            if (searchText != "") {
                ScrollView {
                    TrackList(tracks: [TrackMock.iRememberEverything, TrackMock.luxury, TrackMock.traitor]) { tappedTrack in
                        selectedTrack = tappedTrack
                    }
                    .padding(.horizontal)
                    .sheet(item: $selectedTrack) { track in
                        // Replace with your sheet view
                        Text("Share \(track.name) with a friend")
                    }
                }
                .scrollDismissesKeyboard(.immediately)
            }
            
            Spacer() // To top-align the search bar when there are no results to show
        }
        .background(
            // Adding a clear background to capture taps to hide the keyboard
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    hideKeyboard()
                }
        )
        .onAppear {
            isSearchFieldFocused = true
        }
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
