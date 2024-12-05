import SwiftUI

/// A view that allows the user to search for songs, displays the search results, and send the selected tracks to their friends.
///
/// This view contains a search bar for the user to input song names and a list of search results.
/// Once a track is selected, a sheet is presented to allow the user to send the track to selected friends.
///
/// - Parameters:
///   - searchBarPlaceholderText: The placeholder text to display in the search bar.
///   - isSearching: A binding to a boolean that indicates whether the user is currently searching.
///   - selectedTab: A binding to the selected tab in the song sharing section, used for navigation or tab-related actions.
///   
struct SongSearchView: View {
    let searchBarPlaceholderText: String
    @Binding var isSearching: Bool
    @Binding var selectedTab: SongShareTab
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
                        SendToFriendsSheet(track: track,
                                           friends: [SpotifyProfileMock.dwightSchrute, SpotifyProfileMock.jimHalpert,
                                                     SpotifyProfileMock.michaelScott, SpotifyProfileMock.stanleyHudson],
                                           isSearching: $isSearching,
                                           selectedTab: $selectedTab)
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
    @Previewable @State var selectedTab = SongShareTab.received
    SongSearchView(searchBarPlaceholderText: "Search...", isSearching: $isSearching, selectedTab: $selectedTab)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.PresetColour.darkgrey)
}
