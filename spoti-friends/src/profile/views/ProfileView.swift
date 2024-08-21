import SwiftUI

/// Renders the View for a user's profile.
struct ProfileView: View {
    let profile: SpotifyProfile
    @State private var recentSongs: [Track]
    @StateObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject var authorizationViewModel: AuthorizationViewModel
    @EnvironmentObject var friendActivityViewModel: FriendActivityViewModel
    
    init(profile: SpotifyProfile, recentSongs: [Track] = []) {
        self.profile = profile
        _profileViewModel = StateObject(wrappedValue: ProfileViewModel(user: AuthorizationViewModel().user))
        self.recentSongs = recentSongs
    }
    
    var body: some View {
        GeometryReader { reader in
            ScrollView {
                VStack {
                    ProfileDetails(profile: profile)
                        .environmentObject(profileViewModel)
                        .environmentObject(friendActivityViewModel)
                        .padding(.bottom, 40)
                    
                    TrackOrArtistList(trackList: recentSongs)
                    Spacer()
                    
                    // TODO: This needs to be moved to a view for only the logged in profile
                    // or keep it here but conditionally render it.
                    LogoutButton()
                        .padding(.bottom, 10)
                }
                .frame(minHeight: reader.size.height)
                .padding(.horizontal, 20)
            }
            .padding(.top)
            .background(Color.PresetColour.darkgrey)
            .onAppear {
                profileViewModel.user = authorizationViewModel.user
                
                Task {
                    recentSongs = await profileViewModel.getCurrentUsersTopTracks(timeRange: .oneMonth, limit: 5) ?? []
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
    let recentSongs = [TrackMock.iRememberEverything, TrackMock.luxury, TrackMock.traitor]
    ProfileView(profile: user.spotifyProfile!, recentSongs: recentSongs)
        .environmentObject(AuthorizationViewModel())
        .environmentObject(FriendActivityViewModel(user: user, friendActivites: []))
}
