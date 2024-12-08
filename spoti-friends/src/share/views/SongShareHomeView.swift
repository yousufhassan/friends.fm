import SwiftUI

/// A View that allows users to share songs with their friends.
///
/// The view contains a search bar to search for songs to share and two scrollable tabs to display
/// songs received from friends and songs sent to friends.
///
/// - Parameters:
///   - searchBarPlaceholderText: The placeholder text for the search bar.
///   - isSearching: A boolean denoting whether or not the search bar is focused (true) or unfocused (false).
///
struct SongShareHomeView: View {
    let searchBarPlaceholderText: String
    @Binding var isSearching: Bool
    @Binding var selectedTab: SongShareTab
    @State private var receivedTracks: [Track]
    @State private var sentTracks: [Track]
    
    init(searchBarPlaceholderText: String, isSearching: Binding<Bool>, selectedTab: Binding<SongShareTab>,
         receivedTracks: [Track] = [], sentTracks: [Track] = []) {
        self.searchBarPlaceholderText = searchBarPlaceholderText
        self._isSearching = isSearching
        self._selectedTab = selectedTab
        self.receivedTracks = receivedTracks
        self.sentTracks = sentTracks
        
        
        // Picker background color
        UISegmentedControl.appearance().backgroundColor = UIColor(Color(red: 0.06, green: 0.06, blue: 0.06))
        
        // Picker background color of selected
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color(red: 0.11, green: 0.11, blue: 0.11))
        
        // Picker foreground color of selected
        UISegmentedControl.appearance().setTitleTextAttributes(
            [.foregroundColor: UIColor(Color.PresetColour.spotifyGreen)], for: .selected)
        
        // Picker foreground color of inactive
        UISegmentedControl.appearance().setTitleTextAttributes(
            [.foregroundColor: UIColor(Color.PresetColour.whitePrimary)], for: .normal)
    }
    
    var body: some View {
        VStack {
            // Page Title and Search Bar
            VStack {
                PageTitle(pageTitle: "Share")
                
                DecorativeSearchBar(placeholderText: searchBarPlaceholderText)
                    .onTapGesture {
                        withAnimation(.easeOut(duration: 0.2)) {
                            self.isSearching = true
                        }
                    }
            }
            .padding()
            
            // Received/Sent Tab Bar
            ZStack (alignment: .bottom) {
                Picker("Tabs", selection: $selectedTab) {
                    Text("Received").tag(SongShareTab.received)
                    Text("Sent").tag(SongShareTab.sent)
                }
                .pickerStyle(.segmented)
                
                Divider()
                    .frame(height: 1)
                    .background(Color.PresetColour.whitePrimary)
                    .opacity(0.8)
            }
            
            // Horizontal scrollable TabView
            TabView(selection: $selectedTab) {
                // Received songs tab
                ScrollView {
                    TrackList(tracks: receivedTracks)
                        .padding(.horizontal)
                }
                .tag(SongShareTab.received)
                
                // Sent songs tab
                ScrollView {
                    TrackList(tracks: sentTracks)
                        .padding(.horizontal)
                }
                .tag(SongShareTab.sent)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
    }
}

#Preview {
    @Previewable @State var isSearching = false
    @Previewable @State var selectedTab = SongShareTab.received
    let placeholderText = "What song do you want to share?"
    let receivedTracks: [Track] = [TrackMock.iRememberEverything, TrackMock.luxury, TrackMock.traitor,
                                   TrackMock.iRememberEverything, TrackMock.luxury, TrackMock.traitor,
                                   TrackMock.iRememberEverything, TrackMock.luxury, TrackMock.traitor,
                                   TrackMock.iRememberEverything, TrackMock.luxury, TrackMock.traitor,
                                   TrackMock.iRememberEverything, TrackMock.luxury, TrackMock.traitor]
    let sentTracks: [Track] = [TrackMock.luxury]
    
    SongShareHomeView(searchBarPlaceholderText: placeholderText, isSearching: $isSearching, selectedTab: $selectedTab,
                      receivedTracks: receivedTracks, sentTracks: sentTracks)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.PresetColour.darkgrey)
}
