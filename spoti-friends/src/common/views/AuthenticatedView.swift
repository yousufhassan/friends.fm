import SwiftUI

/// The view for when a user is signed into the app.
struct AuthenticatedView: View {
    @EnvironmentObject var friendActivityViewModel: FriendActivityViewModel
    @EnvironmentObject var authorizationViewModel: AuthorizationViewModel
    
    init() {
//        let appearance = UITabBar.appearance()
//        appearance.backgroundColor = UIColor(Color.PresetColour.darkgrey)
        
        let standardAppearance = UITabBarAppearance()
        standardAppearance.backgroundColor = UIColor(Color.PresetColour.darkgrey)
        UITabBar.appearance().standardAppearance = standardAppearance
        
        let scrollEdgeAppearance = UITabBarAppearance()
        scrollEdgeAppearance.configureWithTransparentBackground()
        scrollEdgeAppearance.backgroundColor = UIColor(Color.PresetColour.darkgrey)
        UITabBar.appearance().scrollEdgeAppearance = scrollEdgeAppearance
    }
    
    var body: some View {
        TabView {
            FriendActivityView().tabItem { Label("Friend Activity", systemImage: "figure.socialdance") }
                .environmentObject(friendActivityViewModel)
            ProfileView(profile: friendActivityViewModel.user.spotifyProfile!).tabItem { Label("My Profile", systemImage: "person") }
                .environmentObject(authorizationViewModel)
        }
    }
}

#Preview {
    let user = UserMock.userJimHalpert
    let activites = ListeningActivityCardMock.allCards
    
    AuthenticatedView()
        .environmentObject(FriendActivityViewModel(user: user, friendActivites: activites))
        .environmentObject(AuthorizationViewModel())
}
