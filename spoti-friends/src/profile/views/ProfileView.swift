import SwiftUI

/// Renders the View for a user's profile.
struct ProfileView: View {
    let profile: SpotifyProfile
    @State private var trackList: [ProfileViewModel.GetCurrentUserTopTracks.Track2]
    @StateObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject var authorizationViewModel: AuthorizationViewModel
    @EnvironmentObject var friendActivityViewModel: FriendActivityViewModel
    
    init(profile: SpotifyProfile) {
        self.profile = profile
        _profileViewModel = StateObject(wrappedValue: ProfileViewModel(user: AuthorizationViewModel().user))
        self.trackList = []
    }
    
    var body: some View {
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
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.PresetColour.darkgrey)
        .onAppear {
            profileViewModel.user = authorizationViewModel.user
            
            Task {
                trackList = await profileViewModel.getCurrentUsersTopTracks(timeRange: .oneMonth, limit: 5) ?? []
                //                await profileViewModel.getCurrentUsersTopTracks() ?? []
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
    //    ProfileView()
    ProfileView(profile: user.spotifyProfile!)
        .environmentObject(AuthorizationViewModel())
        .environmentObject(FriendActivityViewModel(user: user, friendActivites: []))
}
