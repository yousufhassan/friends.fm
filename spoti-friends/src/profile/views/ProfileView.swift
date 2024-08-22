import SwiftUI

/// Renders the View for a user's profile.
struct ProfileView: View {
    let profile: SpotifyProfile
    @State private var topTracks: [Track]
    @StateObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject var authorizationViewModel: AuthorizationViewModel
    @EnvironmentObject var friendActivityViewModel: FriendActivityViewModel
    
    init(profile: SpotifyProfile, topTracks: [Track] = []) {
        self.profile = profile
        _profileViewModel = StateObject(wrappedValue: ProfileViewModel(user: AuthorizationViewModel().user))
        self.topTracks = topTracks
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
                        TrackOrArtistList(trackList: topTracks)
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
                    topTracks = await profileViewModel.getCurrentUsersTopTracks(timeRange: .oneMonth, limit: 5) ?? []
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
                    .frame(width: 320, height: 50) // Adjust the height as needed
                    .background(Color.PresetColour.transparentMaroon)
                    .foregroundColor(Color.PresetColour.red)
                    .fontWeight(.semibold)
                    .cornerRadius(12)
            }
        }
    }
}

#Preview {
    let user = UserMock.userJimHalpert
    let topTracks = [TrackMock.iRememberEverything, TrackMock.luxury, TrackMock.traitor]
    ProfileView(profile: user.spotifyProfile!, topTracks: topTracks)
        .environmentObject(AuthorizationViewModel())
        .environmentObject(FriendActivityViewModel(user: user, friendActivites: []))
}
