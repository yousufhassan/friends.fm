import SwiftUI

/// An enum for the available tabs in the song sharing home view.
enum SongShareTab {
    case received
    case sent
}

/// A View that allows users to share songs with their friends.
///
/// This view provides a search bar for finding songs to share, along with two tabs
/// to display songs received from friends and songs sent to friends. The `isSearching`
/// state determines whether the user is actively searching for a song or viewing
/// the main tabs.
///
/// The view dynamically switches between `SearchView` for searching and
/// `SongShareHomeView` for displaying received/sent songs.
///
/// - Properties:
///   - searchBarPlaceholderText: A string used as placeholder text in the search bar.
///   - isSearching: A state variable that tracks whether the user is in search mode.
struct SongShareView: View {
    @EnvironmentObject var shareViewModel: ShareViewModel
    let searchBarPlaceholderText = "What song do you want to share?"
    @State private var isSearching: Bool = false
    @State var selectedTab: SongShareTab = .received
    @State var receivedTracks: [Track] = []
    @State var sentResources: [SharedResource] = []
    
    var body: some View {
        ZStack {
            if (self.isSearching) {
                SongSearchView(searchBarPlaceholderText: searchBarPlaceholderText,
                               isSearching: $isSearching,
                               selectedTab: $selectedTab,
                               sentResources: $sentResources)
                .transition(.opacity)
                .environmentObject(shareViewModel)
            } else {
                SongShareHomeView(searchBarPlaceholderText: searchBarPlaceholderText,
                                  isSearching: $isSearching,
                                  selectedTab: $selectedTab,
                                  receivedTracks: $receivedTracks,
                                  sentResources: $sentResources)
                .environmentObject(shareViewModel)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.PresetColour.darkgrey)
    }
}

#Preview {
    let user = UserMock.userJimHalpert
    let receivedTracks: [Track] = [TrackMock.iRememberEverything, TrackMock.luxury, TrackMock.traitor,
                                   TrackMock.iRememberEverything, TrackMock.luxury, TrackMock.traitor,
                                   TrackMock.iRememberEverything, TrackMock.luxury, TrackMock.traitor,
                                   TrackMock.iRememberEverything, TrackMock.luxury, TrackMock.traitor,
                                   TrackMock.iRememberEverything, TrackMock.luxury, TrackMock.traitor]
    let sentResources: [SharedResource] = SharedResourceMock.sentResources
    
    SongShareView(receivedTracks: receivedTracks, sentResources: sentResources)
        .environmentObject(ShareViewModel(user: user))
}
