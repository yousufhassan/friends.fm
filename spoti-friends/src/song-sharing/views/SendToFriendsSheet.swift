import SwiftUI

struct SendToFriendsSheet: View {
    let track: Track
    let friends: [SpotifyProfile]
    @State var selectedFriends: Set<SpotifyProfile> = []
    
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
            Text("Send to")
                .bold()
            
            ScrollView {
                LazyVGrid(columns: threeColumns, spacing: 8) {
                    ForEach(friends) { friend in
                        ZStack {
                            FriendGridItem(friend: friend)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    toggleSelected(forFriend: friend)
                                }
                            
                            if isSelected(friend: friend){
                                FriendSelectedIndicator()
                            }
                            
                        }
                    }
                }
                .padding(.horizontal, 8)
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
    let track = TrackMock.traitor
    let friends = [SpotifyProfileMock.dwightSchrute, SpotifyProfileMock.jimHalpert,
                   SpotifyProfileMock.michaelScott, SpotifyProfileMock.stanleyHudson]
    
    Button("Open sheet") {
        showSheet = true
    }
    .sheet(isPresented: $showSheet) {
        SendToFriendsSheet(track: track, friends: friends)
    }
}


struct FriendGridItem: View {
    let friend: SpotifyProfile
    
    var body: some View {
        VStack(spacing: 8) {
            // Image - fixed size for all items to keep them aligned
            ImageWithSpecs(imageUrl: friend.image, width: 64, height: 64, cornerRadius: 100)
                .padding(.horizontal)
            
            // Text - limited to two lines and centered
            Text(friend.displayName)
                .foregroundStyle(Color.PresetColour.whiteSecondary)
                .font(.footnote)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
    }
}

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
                Image(systemName: "checkmark") // Checkmark inside the circle
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.PresetColour.darkgrey)
                    .frame(width: 8, height: 8)
                    .fontWeight(.bold)
            )
            .offset(x: 26, y: 10)
    }
}
