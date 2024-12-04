import SwiftUI

/// A View that allows users to share songs with their friends.
///
/// The view contains a search bar to search for songs to share and two scrollable tabs to display
/// songs received from friends and songs sent to friends.
///
/// - Parameters:
///   - receivedTracks: An array of `Track` objects representing the songs received from friends.
///   - sentTracks: An array of `Track` objects representing the songs sent to friends.
///
struct SongShareView: View {
    let searchBarPlaceholderText = "What song do you want to share?"
    @State private var searchText: String = ""
    @FocusState private var isSearchBarFocused: Bool
    
    @State private var selectedTab = 0
    @State private var receivedTracks: [Track]
    @State private var sentTracks: [Track]
    
    init(receivedTracks: [Track] = [], sentTracks: [Track] = []) {
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
        
        self.receivedTracks = receivedTracks
        self.sentTracks = sentTracks
    }
    
    
    var body: some View {
        //        NavigationStack {
        if (false) {
            VStack {
                //                SearchBar(placeholderText: searchBarPlaceholderText, searchText: $searchText, isEditing: $isEditing)
                
                SearchView()
            }
        } else {
            VStack {
                VStack {
                    PageTitle(pageTitle: "Share")
                    
                    SearchBar(placeholderText: searchBarPlaceholderText, searchText: $searchText)
                        .focused($isSearchBarFocused)
                }
                .padding()
                
                // Received/Sent Tab Bar
                ZStack (alignment: .bottom) {
                    Picker("Tabs", selection: $selectedTab) {
                        Text("Received").tag(0)
                        Text("Sent").tag(1)
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
                    .tag(0)
                    
                    // Sent songs tab
                    ScrollView {
                        TrackList(tracks: sentTracks)
                            .padding(.horizontal)
                    }
                    .tag(1)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.PresetColour.darkgrey)
            
            // Detect taps outside to dismiss focus
            if isSearchBarFocused {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isSearchBarFocused = false // Dismiss focus
                    }
            }
            
            //        }
        }
    }
}

#Preview {
    let receivedTracks: [Track] = [TrackMock.iRememberEverything, TrackMock.luxury, TrackMock.traitor,
                                   TrackMock.iRememberEverything, TrackMock.luxury, TrackMock.traitor,
                                   TrackMock.iRememberEverything, TrackMock.luxury, TrackMock.traitor,
                                   TrackMock.iRememberEverything, TrackMock.luxury, TrackMock.traitor,
                                   TrackMock.iRememberEverything, TrackMock.luxury, TrackMock.traitor]
    let sentTracks: [Track] = [TrackMock.luxury]
    SongShareView(receivedTracks: receivedTracks, sentTracks: sentTracks)
}
