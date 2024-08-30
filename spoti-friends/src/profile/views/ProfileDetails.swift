import SwiftUI


/// Renders the View for a user's Spotify Profile details.
/// In other words: their profile image, display name, follower count, and playlist count.
///
/// - Parameters:
///   - profile: The `SpotifyProfile` to display the details for.
struct ProfileDetails: View {
    let profile: SpotifyProfile
    @State private var followerCount: Int?
    @State private var playlistCount: Int?
    @State private var fetchedDetails: Bool = true
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var friendActivityViewModel: FriendActivityViewModel
    
    init(profile: SpotifyProfile) {
        self.profile = profile
    }
    
    var body: some View {
        HStack(spacing: 12) {
            ProfileImage(imageName: profile.spotifyId, width: 80, height: 80)
                .environmentObject(friendActivityViewModel)
            
            VStack(alignment: .leading) {
                // Display name
                Text(profile.displayName)
                    .foregroundStyle(Color.PresetColour.whitePrimary)
                
                Spacer().frame(height: 4)
                
                // Follower and playlist counts
                HStack {
                    if (followerCount == nil || playlistCount == nil) {
                        // Show placeholder while fetching data
                        Group {
                            Text("\(String(describing: followerCount)) followers")
                                .redacted(reason: .placeholder)
                            Text("\(String(describing: playlistCount)) playlists")
                                .redacted(reason: .placeholder)
                        }
                        .lineLimit(1)
                        .opacity(fetchedDetails ? 0.6 : 1.0)
                        .animation(
                            .easeInOut(duration: 0.8)
                            .repeatForever(autoreverses: true),
                            value: fetchedDetails
                        )
                    } else {
                        // Show data once it is fetched
                        Text("\(followerCount!) followers")
                        Text("•")
                        Text("\(playlistCount!) playlists")
                    }
                }
                .foregroundStyle(Color.PresetColour.whiteSecondary)
                .onAppear {
                    fetchedDetails = false
                    Task {
                        // NOTE: Comment out these two lines to fix SwiftUI Previews
                        followerCount = await profileViewModel.getCurrentUsersFollowerCount()
                        playlistCount = await profileViewModel.getCurrentUsersPlaylistCount()
                        fetchedDetails = true
                    }
                }
                
                Spacer().frame(height: 8)
                
                // Open in Spotify button
                OpenInSpotifyButton(redirectLink: profile.spotifyUri)
            }
            Spacer()
        }
    }
}

#Preview {
    ZStack {
        let user = UserMock.userJimHalpert
        ProfileDetails(profile: user.spotifyProfile!)
            .environmentObject(ProfileViewModel(user: user))
            .environmentObject(FriendActivityViewModel(user: user, friendActivites: []))
    }
}
