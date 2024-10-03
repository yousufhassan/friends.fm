import SwiftUI

/// The view for when a user is signed into the app.
struct AuthenticatedView: View {
    @StateObject var friendActivityViewModel: FriendActivityViewModel
    @EnvironmentObject var authorizationViewModel: AuthorizationViewModel
    
    init() {
        _friendActivityViewModel = StateObject(wrappedValue: FriendActivityViewModel(user: AuthorizationViewModel().user, friendActivites: []))
        
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
//            ProfileView(profile: friendActivityViewModel.user.spotifyProfile ?? SpotifyProfile()).tabItem {
//                Label("My Profile", systemImage: "person")
//            }
//            .environmentObject(authorizationViewModel)
//            .environmentObject(friendActivityViewModel)
        }
        .tint(Color.PresetColour.spotifyGreen)
        .onAppear {
            friendActivityViewModel.user = authorizationViewModel.user
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
