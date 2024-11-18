import SwiftUI

/// Renders the View for a Spotify profile. It conditionally displays either the app user's profile or a generic non-user profile view,
/// depending on whether the given profile is associated with someone who uses the app.
///
/// - Parameters:
///   - profile: The Spotify profile to display.
///
/// - Returns: A view showing either the app user's profile or a non-user profile view.
struct ProfileView: View {
    let profile: SpotifyProfile
    @State var isAppUser: Bool = true
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var friendActivityViewModel: FriendActivityViewModel
    
    init(profile: SpotifyProfile) {
        self.profile = profile
    }
    
    var body: some View {
        HStack {
            if (isAppUser) {
                UserProfileView(profile: profile)
                    .environmentObject(friendActivityViewModel)
                    .environmentObject(profileViewModel)
            } else {
                NonUserProfileView()
            }
        }
        .onAppear {
            Task {
                self.isAppUser = await UserServiceManager.shared.userExists(withSpotifyId: profile.spotifyId)
            }
        }
    }
}

#Preview {
    let user = UserMock.userJimHalpert
    let profile = SpotifyProfileMock.michaelScott
    
    ProfileView(profile: profile)
        .environmentObject(FriendActivityViewModel(user: user, friendActivites: []))
}
