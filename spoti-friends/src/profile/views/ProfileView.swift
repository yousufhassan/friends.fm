import SwiftUI

/// Renders the View for a user's profile, such as their details and top songs.
///
/// - Parameters:
///   - profile: The Spotify profile to display.
///   - topTracks: A list of the profile's top tracks over the last month.
///
/// - Returns: A view for the user's Spotify Profile.
struct ProfileView: View {
    let profile: SpotifyProfile
    @State private var topTracks: ProfileViewModel.TracksWithResponseMetadata
    @StateObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject var authorizationViewModel: AuthorizationViewModel
    @EnvironmentObject var friendActivityViewModel: FriendActivityViewModel
    
    init(profile: SpotifyProfile, topTracks: [Track] = []) {
        self.profile = profile
        _profileViewModel = StateObject(wrappedValue: ProfileViewModel(user: AuthorizationViewModel().user))
        self.topTracks = ProfileViewModel.TracksWithResponseMetadata(tracks: topTracks)
    }
    
    var body: some View {
        GeometryReader { reader in
            ScrollView {
                VStack (alignment: .leading) {
                    // Profile Details
                    ProfileDetails(profile: profile)
                        .environmentObject(profileViewModel)
                        .environmentObject(friendActivityViewModel)
                        .padding(.bottom, 40)
                    
                    // Top Tracks
                    VStack (alignment: .leading) {
                        Text("Top Songs")
                            .font(.body)
                            .foregroundStyle(Color.PresetColour.whitePrimary)
                        Text("From this month")
                            .font(.footnote)
                            .foregroundStyle(Color.PresetColour.whiteSecondary)
                        
                        if (topTracks.isEmpty) {
                            Text("Not enough listening data this month.")
                                .font(.callout)
                                .foregroundStyle(Color.PresetColour.whitePrimary)
                                .padding(.vertical, 4)
                        }
                        else {
                            TrackOrArtistList(trackList: topTracks.tracks)
                        }
                    }
                    Spacer()
                }
                .frame(minHeight: reader.size.height)
                .padding(.horizontal, 20)
                
                // TODO: This needs to be moved to a view for only the logged in profile
                // or keep it here but conditionally render it.
                LogoutButton()
                    .padding(.bottom, 10)
            }
            .padding(.top)
            .background(Color.PresetGradient.profileViewGradient(profile: profile))
            .onAppear {
                profileViewModel.user = authorizationViewModel.user
                
                Task {
                    topTracks = await profileViewModel.getCurrentUsersTopTracks(timeRange: .oneMonth, limit: 5)
                    ?? ProfileViewModel.TracksWithResponseMetadata(tracks: [])
                }
            }
        }
    }
    
    /// The view for the log out button.
    struct LogoutButton: View {
        @EnvironmentObject private var authorizationViewModel: AuthorizationViewModel
        
        var body: some View {
            let buttonLabel = "Log out"
            Button(action: {
                authorizationViewModel.signOutUser()
            }) {
                Text(buttonLabel)
                    .frame(width: 320, height: 50)
                    .background(Color.PresetColour.transparentMaroon)
                    .foregroundColor(Color.PresetColour.red)
                    .fontWeight(.semibold)
                    .cornerRadius(12)
            }
        }
    }
}

#Preview {
    ZStack {
        let user = UserMock.userJimHalpert
        let topTracks = [TrackMock.iRememberEverything, TrackMock.luxury, TrackMock.traitor]
        ProfileView(profile: user.spotifyProfile!, topTracks: topTracks)
            .environmentObject(AuthorizationViewModel())
            .environmentObject(FriendActivityViewModel(user: user, friendActivites: []))
    }
}
