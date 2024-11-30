import SwiftUI

/// A SwiftUI view for displaying the profile of a user who has not yet joined the app.
///
/// The `NonUserProfileView` presents basic profile details of a non-user and includes
/// a message encouraging the current user to invite them to join the app.
///
/// - Parameters:
///   - profile: The Spotify profile to display.
///   
struct NonUserProfileView: View {
    let profile: SpotifyProfile
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    init(profile: SpotifyProfile) {
        self.profile = profile
    }
    
    var body: some View {
        VStack {
            // Profile Details
            ProfileDetails(profile: profile)
                .environmentObject(profileViewModel)
            
            Spacer()
                .frame(height: 70)
            
            VStack {
                Text("\(profile.displayName) has not joined the app yet.")
                Text("Invite them to be part of the fun!")
            }
            .foregroundStyle(Color.PresetColour.whitePrimary)
            
            Spacer()
        }
        .padding(.top)
    }
}

#Preview {
    let user = UserMock.userJimHalpert
    
    NonUserProfileView(profile: user.spotifyProfile)
        .environmentObject(ProfileViewModel(user: user))
}
