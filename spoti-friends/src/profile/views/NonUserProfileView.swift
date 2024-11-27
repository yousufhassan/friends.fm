import SwiftUI

struct NonUserProfileView: View {
    let profile: SpotifyProfile
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    init(profile: SpotifyProfile) {
        self.profile = profile
    }
    
    var body: some View {
        VStack (alignment: .leading, spacing: 34) {
            // Profile Details
            ProfileDetails(profile: profile)
                .environmentObject(profileViewModel)
        }
    }
}

#Preview {
    let user = UserMock.userJimHalpert
    
    NonUserProfileView(profile: user.spotifyProfile)
}
