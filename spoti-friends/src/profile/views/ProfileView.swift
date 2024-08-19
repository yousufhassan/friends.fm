import SwiftUI

/// Renders the View for a user's profile.
struct ProfileView: View {
    let profile: SpotifyProfile
    @StateObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject var authorizationViewModel: AuthorizationViewModel
    @EnvironmentObject var friendActivityViewModel: FriendActivityViewModel
    
    init(profile: SpotifyProfile) {
        self.profile = profile
        _profileViewModel = StateObject(wrappedValue: ProfileViewModel(user: AuthorizationViewModel().user))
    }
    
    var body: some View {
        //        ScrollView {
        VStack {
            ProfileDetails(profile: profile)
                .environmentObject(profileViewModel)
                .environmentObject(friendActivityViewModel)
            
            Spacer()
            
            LogoutButton()
                .padding(.bottom, 10)
        }
        //        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.PresetColour.darkgrey)
        .onAppear {
            profileViewModel.user = authorizationViewModel.user
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
