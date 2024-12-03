import SwiftUI

struct SongShareView: View {
    let searchBarPlaceholderText = "What song do you want to share?"
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
        VStack {
            VStack {
                PageTitle(pageTitle: "Share")
                
                SearchBar(placeholderText: searchBarPlaceholderText)
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
                TrackList(tracks: receivedTracks)
                    .tag(0)
                
                // Sent songs tab
                TrackList(tracks: sentTracks)
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.PresetColour.darkgrey)
    }
}

#Preview {
    let receivedTracks: [Track] = [TrackMock.iRememberEverything]
    let sentTracks: [Track] = []
    SongShareView(receivedTracks: receivedTracks, sentTracks: sentTracks)
}
