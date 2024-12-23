import SwiftUI

/// The view that displays the Friend Activity page which contains the listening activity for the user's friends.
///
/// - Returns: The friend activity page view.
struct FriendActivityView: View {
    @EnvironmentObject var friendActivityViewModel: FriendActivityViewModel
    @State private var contentHeight: CGFloat = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                // Friend Activity Header
                PageTitle(pageTitle: "Friend Activity")
                    .padding()
                
                // List of friend's listening activities
                if friendActivityViewModel.friendActivites.isEmpty {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(Color.PresetColour.spotifyGreen)
                        .scaleEffect(1.6)
                    Text("Spying on your friends' tunes...")
                        .foregroundStyle(Color.PresetColour.spotifyGreen)
                        .padding(.top, 20)
                        .font(.subheadline)
                    Spacer()
                }
                else {
                    ScrollView {
                        LazyVStack(alignment: .center) {
                            ForEach(friendActivityViewModel.friendActivites) { activity in
                                activity
                                    .environmentObject(friendActivityViewModel)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        
                        // Spotify Attribution
                        VStack {
                            Text("Data provided by")
                                .font(.callout)
                                .foregroundStyle(Color.PresetColour.spotifyDarkGrey)
                            Image("spotify-logo-black")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 120)
                        }
                        .padding(.vertical, 12)
                        
                    }
                }
            }
            .refreshable {
                try? await friendActivityViewModel.setFriendActivity()
            }
            .onAppear {
                Task {
                    try? await friendActivityViewModel.setFriendActivity()
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.PresetColour.darkgrey)
        }
    }
}

#Preview {
    ZStack {
        let user = UserMock.userJimHalpert
        let activities = ListeningActivityCardMock.allCards
        
        FriendActivityView()
            .environmentObject(FriendActivityViewModel(user: user, friendActivites: activities))
            .environmentObject(ProfileViewModel(user: user))
    }
}
