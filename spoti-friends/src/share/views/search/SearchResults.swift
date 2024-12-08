import SwiftUI

/// A view that displays search results for tracks and allows the user to interact with them.
///
/// This view listens for changes to the search text and updates the search results accordingly.
/// Users can tap on a track to open a sheet for sharing the track with friends.
///
/// - Parameters:
///   - searchText: A binding to the current search text entered by the user.
///   - isSearching: A binding that indicates whether the user is currently performing a search.
///   - selectedTab: A binding to the currently selected tab in the `SongShareView` view.
///
struct SearchResults: View {
    @EnvironmentObject var shareViewModel: ShareViewModel
    @Binding var searchText: String
    @Binding var isSearching: Bool
    @Binding var selectedTab: SongShareTab
    @Binding var sentTracks: [Track]
    @State private var searchResults: [Track]? = []
    @State private var selectedTrack: Track?
    
    var body: some View {
        ScrollView {
            if let searchResults {
                LazyVStack {
                    ForEach(searchResults, id: \.id) { track in
                        TrackView(track: track) {
                            selectedTrack = track
                        }
                    }
                }
                .padding(.horizontal)
                .sheet(item: $selectedTrack) { track in
                    if let user = shareViewModel.user {
                        SendToFriendsSheet(track: track,
                                           friends: user.getFriends(),
                                           isSearching: $isSearching,
                                           selectedTab: $selectedTab,
                                           sentTracks: $sentTracks)
                        .environmentObject(shareViewModel)
                    } else {
                        SomethingWentWrongView()
                    }
                }
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .onChange(of: searchText) { oldSearchText, newSearchText in
            if (searchText.isEmpty) {
                searchResults = []
            } else {
                Task {
                    self.searchResults = await shareViewModel.searchSpotify(for: [.track], text: newSearchText)
                }
            }
        }
    }
}
