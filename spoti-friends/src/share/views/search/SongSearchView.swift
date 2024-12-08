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
    @EnvironmentObject var shareViewModel: ShareViewModel
    let searchBarPlaceholderText: String
    @Binding var isSearching: Bool
    @Binding var selectedTab: SongShareTab
    @Binding var sentTracks: [Track]
    @State private var searchText = ""
    @FocusState private var isSearchFieldFocused: Bool
    
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
            SearchResults(searchText: $searchText,
                          isSearching: $isSearching,
                          selectedTab: $selectedTab,
                          sentTracks: $sentTracks)
                .environmentObject(shareViewModel)
            
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
            // Open the keyboard when this view is rendered
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
    @Previewable @State var sentTracks: [Track] = [TrackMock.luxury]
    let user = UserMock.userJimHalpert
    
    SongSearchView(searchBarPlaceholderText: "Search...", isSearching: $isSearching,
                   selectedTab: $selectedTab, sentTracks: $sentTracks)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.PresetColour.darkgrey)
        .environmentObject(ShareViewModel(user: user))
}
