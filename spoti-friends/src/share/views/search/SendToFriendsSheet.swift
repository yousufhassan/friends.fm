import SwiftUI

/// A sheet that allows the user to send a track to selected friends.
///
/// This view displays a grid of friends, where each friend can be tapped to select or deselect them.
/// Once at least one friend is selected, a "Send" button is displayed at the bottom.
///
/// - Parameters:
///   - track: The track to be sent to friends.
///   - friends: A list of the user's friends.
///   - selectedFriends: Tracks the currently selected friends to send the song to.
///
struct SendToFriendsSheet: View {
    @EnvironmentObject var shareViewModel: ShareViewModel
    let track: Track
    let friends: [SpotifyProfile]
    @State var selectedFriends: Set<SpotifyProfile> = []
    @Binding var isSearching: Bool
    @Binding var selectedTab: SongShareTab
    @Binding var sentTracks: [Track]
    
    /// Toggles the selected status for `friend`.
    ///
    /// If `friend` is already in `selectedFriends`, then remove it. Vice versa.
    private func toggleSelected(forFriend friend: SpotifyProfile) {
        if selectedFriends.contains(friend) {
            selectedFriends.remove(friend)
        } else {
            selectedFriends.insert(friend)
        }
    }
    
    /// Returns whether or not the friend is selected to share the song with.
    private func isSelected(friend: SpotifyProfile) -> Bool {
        return selectedFriends.contains(friend)
    }
    
    // Define the grid layout with 3 columns and spacing
    let threeColumns = [GridItem(.flexible(), spacing: 8),
                        GridItem(.flexible(), spacing: 8),
                        GridItem(.flexible(), spacing: 8)]
    
    var body: some View {
        VStack {
            // Send to label
            Text("Send to")
                .bold()
            
            // Preview of track to send
            TrackView(track: track) {
                () // Overriding the on-tap gesture to do nothing.
            }
            .padding(.horizontal)
            Divider()
            
            // List of friends
            ScrollView {
                LazyVGrid(columns: threeColumns, spacing: 8) {
                    ForEach(friends) { friend in
                        ZStack {
                            // Friend item with profile image and name
                            FriendGridItem(friend: friend)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.1)) {
                                        toggleSelected(forFriend: friend)
                                    }
                                }
                            
                            // Conditional Selected Indicator, if friend is selected
                            if isSelected(friend: friend){
                                FriendSelectedIndicator()
                            }
                            
                        }
                    }
                }
                .padding(.horizontal, 8)
            }
            
            // Conditional Send Button, if friend(s) are selected
            if (!selectedFriends.isEmpty) {
                SendTrackButton(track: track, toFriends: $selectedFriends, isSearching: $isSearching, selectedTab: $selectedTab, sentTracks: $sentTracks)
                    .environmentObject(shareViewModel)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top)
        .presentationDetents([.medium, .large])
    }
}


#Preview {
    @Previewable @State var showSheet = true
    @Previewable @State var selectedTab = SongShareTab.received
    @Previewable @State var sentTracks = [TrackMock.luxury]
    let track = TrackMock.traitor
    let friends = [SpotifyProfileMock.dwightSchrute, SpotifyProfileMock.jimHalpert,
                   SpotifyProfileMock.michaelScott, SpotifyProfileMock.stanleyHudson]
    
    Button("Open sheet") {
        showSheet = true
    }
    .sheet(isPresented: $showSheet) {
        SendToFriendsSheet(track: track, friends: friends, isSearching: $showSheet,
                           selectedTab: $selectedTab, sentTracks: $sentTracks)
    }
}


/// A view that represents a friend in a grid layout.
///
/// This view shows the friend's profile image and display name.
///
/// - Parameters:
///   - friend: The friend to display, including their profile image and display name.
///
struct FriendGridItem: View {
    let friend: SpotifyProfile
    
    var body: some View {
        VStack(spacing: 8) {
            // Profile image
            ProfileImage(profile: friend, width: 64, height: 64)
                .padding(.horizontal)
            
            // Friend's name
            Text(friend.displayName)
                .foregroundStyle(Color.PresetColour.whiteSecondary)
                .font(.footnote)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
    }
}


/// A visual indicator for a selected friend in the grid.
///
/// This view overlays a circle with a checkmark to indicate that the friend is selected.
struct FriendSelectedIndicator: View {
    var body: some View {
        Circle()
            .fill(Color.blue)
            .frame(width: 18, height: 18)
            .overlay(
                // Border around the selected circle
                Circle()
                    .stroke(Color.PresetColour.darkgrey, lineWidth: 2)
            )
            .overlay(
                // Checkmark inside the circle
                Image(systemName: "checkmark")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.PresetColour.darkgrey)
                    .frame(width: 8, height: 8)
                    .fontWeight(.bold)
            )
            .offset(x: 26, y: 10)
    }
}


/// A button that allows the user to send the selected track to friends.
///
/// The button displays the number of selected friends when more than one friend is selected.
/// It animates when shown or hidden.
///
/// - Parameters:
///   - track: The track to be sent.
///   - selectedFriends: A binding to the set of currently selected friends.
struct SendTrackButton: View {
    @EnvironmentObject var shareViewModel: ShareViewModel
    let track: Track
    @Binding var selectedFriends: Set<SpotifyProfile>
    @Binding var isSearching: Bool
    @Binding var selectedTab: SongShareTab
    @Binding var sentTracks: [Track]
    
    init(track: Track, toFriends: Binding<Set<SpotifyProfile>>, isSearching: Binding<Bool>,
         selectedTab: Binding<SongShareTab>, sentTracks: Binding<[Track]>) {
        self.track = track
        self._selectedFriends = toFriends
        self._isSearching = isSearching
        self._selectedTab = selectedTab
        self._sentTracks = sentTracks
    }
    
    var body: some View {
        Button(action: {
            let friendNames = selectedFriends.map { $0.displayName }.joined(separator: ", ")
            printInfo("Sending \(track.name) to \(friendNames)")
            Task {
                let successful = await shareViewModel.share(resource: track, to: selectedFriends)
                
                if (successful) {
                    sentTracks.append(track)
                }
                else {
                    // TODO: Render the error to the user
                }
            }
            
            
            // Redirect back to the Song Share - Sent tab
            withAnimation(.easeOut(duration: 0.2)) {
                self.selectedTab = SongShareTab.sent
                self.isSearching = false
            }
            
        }) {
            Text(selectedFriends.count > 1 ? "Send (\(selectedFriends.count))" : "Send")
                .bold()
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(Color.PresetColour.whitePrimary)
                .background(Color.PresetColour.spotifyGreen)
                .cornerRadius(16)
        }
        .padding(.horizontal)
        .transition(.move(edge: .bottom))
    }
}
