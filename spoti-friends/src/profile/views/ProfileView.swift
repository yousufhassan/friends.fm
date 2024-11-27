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
    @State var isAppUser: Bool
    @EnvironmentObject var authorizationViewModel: AuthorizationViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    init(profile: SpotifyProfile, isAppUser: Bool = true) {
        self.profile = profile
        self.isAppUser = isAppUser
    }
    
    var body: some View {
        GeometryReader { reader in
            Group {
                if (isAppUser) {
                    UserProfileView(profile: profile)
                        .environmentObject(authorizationViewModel)
                        .environmentObject(profileViewModel)
                } else {
                    NonUserProfileView(profile: profile)
                        .environmentObject(profileViewModel)
                }
            }
            .frame(minHeight: reader.size.height)
            .padding(.horizontal, 20)
        }
        .background(Color.PresetGradient.profileViewGradient(profile: profile))
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
        .environmentObject(AuthorizationViewModel())
        .environmentObject(ProfileViewModel(user: user))
}
