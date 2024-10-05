import SwiftUI

/// The view that displays the Friend Activity page which contains the listening activity for the user's friends.
///
/// - Returns: The friend activity page view.
struct FriendActivityView: View {
    @EnvironmentObject var friendActivityViewModel: FriendActivityViewModel
    
    var body: some View {
        VStack {
//            Button("create document") {
//                let profile = SpotifyProfile(spotifyId: "yousuf9", spotifyUri: "someUri",
//                                                     displayName: "yousuf", image: "someImage")
//                
//                let spDcCookie = AppwriteSpDcCookie(value: "cookieValue", expiresDate: Date())
//                
//                let friend1 = SpotifyProfile(spotifyId: "friend1", spotifyUri: "someUri",
//                                                     displayName: "friend1", image: "someImage")
//                
//                let friend2 = SpotifyProfile(spotifyId: "friend2", spotifyUri: "someUri",
//                                                     displayName: "friend2", image: "someImage")
//                
//                let accessToken = AppwriteSpotifyWebAccessToken(
//                    access_token: "tokenValue", token_type: "someType", scope: "scopesHere",
//                    expires_in: 3600, refresh_token: "refreshToken",
//                    accessTokenExpirationTimestampMs: 932847239879)
//                
//                let internalToken = AppwriteInternalAPIAccessToken(
//                clientId: "clientId", accessToken: "accessToken",
//                accessTokenExpirationTimestampMs: 23832849387, isAnonymous: false)
//                
//                let user = User(spotifyId: "yousuf9", spotifyProfile: profile,
//                                        friends: [friend1, friend2],
//                                        authorizationCode: "someAuthCode",
//                                        spotifyWebAcessToken: accessToken,
//                                        internalAPIAccessToken: internalToken,
//                                        spDcCookie: spDcCookie)
//                Task {
//                    let encoder = JSONEncoder()
//                    let data = try? encoder.encode(user)
//                    
//                    await Appwrite.shared.createDocument(collectionId: "users", documentId: user.spotifyId, data: data!)
//                }
//            }
//            
//            Button("get document") {
//                Task {
////                    await Appwrite.shared.getDocument(collectionId: "users", documentId: "yousuf9")
//                    let userServiceManager = UserServiceManager()
//                    try await userServiceManager.getUserFromDB(withSpotifyId: "yousuf9")
//                }
//            }
            
            // Friend Activity Header
            PageTitle(pageTitle: "Friend Activity")
            
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
                    VStack(alignment: .center) {
                        ForEach(friendActivityViewModel.friendActivites) { activity in
                            activity
                                .environmentObject(friendActivityViewModel)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }
            }
        }
        .refreshable {
//            try? await friendActivityViewModel.setFriendActivity()
        }
        .onAppear {
            Task {
//                try? await friendActivityViewModel.setFriendActivity()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.PresetColour.darkgrey)
    }
}

#Preview {
    ZStack {
        let user = UserMock.userJimHalpert
        let activities = ListeningActivityCardMock.allCards
        
        FriendActivityView()
            .environmentObject(FriendActivityViewModel(user: user, friendActivites: activities))
    }
}
