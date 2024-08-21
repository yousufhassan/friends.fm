import SwiftUI

/// Renders the View for a user's profile.
struct ProfileView: View {
    let profile: SpotifyProfile
    @State private var trackList: [Track]
    @StateObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject var authorizationViewModel: AuthorizationViewModel
    @EnvironmentObject var friendActivityViewModel: FriendActivityViewModel
    
    init(profile: SpotifyProfile, recentTracks: [Track] = []) {
        self.profile = profile
        _profileViewModel = StateObject(wrappedValue: ProfileViewModel(user: AuthorizationViewModel().user))
        self.trackList = recentTracks
    }
    
    var body: some View {
        GeometryReader { reader in
            ScrollView {
                VStack {
                    ProfileDetails(profile: profile)
                        .environmentObject(profileViewModel)
                        .environmentObject(friendActivityViewModel)
                    
                    TrackOrArtistList(trackList: trackList)
                    Spacer()
                    
                    // TODO: This needs to be moved to a view for only the logged in profile
                    // or keep it here but conditionally render it.
                    LogoutButton()
                        .padding(.bottom, 10)
                }
                .frame(minHeight: reader.size.height)
                .padding(.horizontal)
            }
            .padding(.top)
            .background(Color.PresetColour.darkgrey)
            .onAppear {
                profileViewModel.user = authorizationViewModel.user
                
                Task {
                    trackList = await profileViewModel.getCurrentUsersTopTracks(timeRange: .oneMonth, limit: 5) ?? []
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
    let recentTracks = [TrackMock.iRememberEverything, TrackMock.luxury, TrackMock.traitor]
    ProfileView(profile: user.spotifyProfile!, recentTracks: recentTracks)
        .environmentObject(AuthorizationViewModel())
        .environmentObject(FriendActivityViewModel(user: user, friendActivites: []))
}
