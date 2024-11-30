import SwiftUI

/// The view for when a user is signed into the app.
struct AuthenticatedView: View {
    @StateObject var friendActivityViewModel: FriendActivityViewModel
    @StateObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject var authorizationViewModel: AuthorizationViewModel
    
    init() {
        _friendActivityViewModel = StateObject(
            wrappedValue: FriendActivityViewModel(user: nil, friendActivites: [])
        )
        _profileViewModel = StateObject(wrappedValue: ProfileViewModel(user: nil))
        
        let standardAppearance = UITabBarAppearance()
        standardAppearance.backgroundColor = UIColor(Color.PresetColour.darkgrey)
        UITabBar.appearance().standardAppearance = standardAppearance
        
        let scrollEdgeAppearance = UITabBarAppearance()
        scrollEdgeAppearance.backgroundColor = UIColor(Color.PresetColour.darkgrey)
        UITabBar.appearance().scrollEdgeAppearance = scrollEdgeAppearance
    }
    
    var body: some View {
        TabView {
            FriendActivityView().tabItem {
                Label("Friend Activity", systemImage: "figure.socialdance")
            }
            .environmentObject(friendActivityViewModel)
            .environmentObject(profileViewModel)
            ProfileView(profile: friendActivityViewModel.user?.spotifyProfile ?? SpotifyProfileMock.jimHalpert).tabItem {
                Label("My Profile", systemImage: "person")
            }
            .environmentObject(authorizationViewModel)
            .environmentObject(profileViewModel)
        }
        .tint(Color.PresetColour.spotifyGreen)
        .onAppear {
            guard let signedInUser = authorizationViewModel.user else {
                printError("Expected user but found none (AuthenticatedView)")
                return
            }
            friendActivityViewModel.user = signedInUser
            profileViewModel.user = signedInUser
        }
    }
}

#Preview {
    ZStack {
        let user = UserMock.userJimHalpert
        let activites = ListeningActivityCardMock.allCards
        
        AuthenticatedView()
            .environmentObject(FriendActivityViewModel(user: user, friendActivites: activites))
            .environmentObject(AuthorizationViewModel())
    }
}
