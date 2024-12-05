import SwiftUI

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
    let searchBarPlaceholderText = "What song do you want to share?"
    @State private var isSearching: Bool = false
    @State var selectedTab: SongShareTab = .received
    
    var body: some View {
        ZStack {
            if (self.isSearching) {
                SongSearchView(searchBarPlaceholderText: searchBarPlaceholderText,
                               isSearching: $isSearching,
                               selectedTab: $selectedTab)
                .transition(.opacity)
            } else {
                SongShareHomeView(searchBarPlaceholderText: searchBarPlaceholderText,
                                  isSearching: $isSearching,
                                  selectedTab: $selectedTab)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.PresetColour.darkgrey)
    }
}

#Preview {
    SongShareView()
}
