import SwiftUI

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
