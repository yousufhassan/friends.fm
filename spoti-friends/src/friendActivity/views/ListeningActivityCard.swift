import SwiftUI

/// The View that renders a Listening Acvitiy Component.
///
/// - Parameters:
///   - profile: The Spotify Profile that is associated with this listening activity.
///   - track: The current or most recent track to display for the user.
///   - album: The album for the current track.
///   - backgroundColor: The background color to set for this item.
///
/// - Returns: A View for the Listening Activity Card.
struct ListeningActivityCard: View, Identifiable {
    let id: String
    var profile: SpotifyProfile
    let track: CurrentOrMostRecentTrack
    let album: Album
    let backgroundColor: Color;
    @State var fontColor: Color
    @EnvironmentObject var friendActivityViewModel: FriendActivityViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    init(profile: SpotifyProfile, backgroundColor: Color) {
        self.id = profile.spotifyId
        self.profile = profile
        self.track = profile.currentOrMostRecentTrack!
        self.album = (profile.currentOrMostRecentTrack?.track.album)!
        self.backgroundColor = backgroundColor
        self.fontColor = Color(backgroundColor).isDarkBackground() ? Color.white : Color.black
    }
    
    var body: some View {
        VStack {
            // Profile Image
            HStack {
                NavigationLink(destination: ProfileView(profile: profile)
                    .environmentObject(friendActivityViewModel)
                    .environmentObject(profileViewModel)
                ) {
                    ZStack {
                        ProfileImage(imageName: profile.spotifyId, width: 56, height: 56)
                            .environmentObject(friendActivityViewModel)
                        if track.playedWithinLastFifteenMinutes {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 12, height: 12)
                                .offset(x: 22, y: -18)
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                // Listening Activity Details
                ListeningActivityDetails(profile: profile, currentTrack: track)
                    .foregroundStyle(fontColor)
                
                // Album Cover
                Link(destination: URL(string: album.spotifyUri)!) {
                    ImageWithSpecs(imageUrl: album.image, width: 80, height: 80)
                        .padding(.leading, 4)
                }
            }
            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 8))
            .frame(maxWidth: 600, maxHeight: 96)
            .frame(height: 96)
            .background(Color(backgroundColor))
            .cornerRadius(12)
            .transition(.opacity)
        }
    }
}

#Preview {
    ZStack {
        let user = UserMock.userJimHalpert
        let profile = SpotifyProfileMock.michaelScott
        
        ListeningActivityCard(profile: profile, backgroundColor: Color.gray)
            .environmentObject(FriendActivityViewModel(user: user, friendActivites: []))
    }
}
