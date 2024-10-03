import Foundation
import Combine
import SwiftUI

class FriendActivityViewModel: ObservableObject {
    @Published var user: AppwriteUser?
    @Published var friendActivites: [ListeningActivityCard]
    private var cancellables = Set<AnyCancellable>()
    
    init(user: AppwriteUser?, friendActivites: [ListeningActivityCard]) {
        self.user = user
        self.friendActivites = friendActivites
        
        let refreshIntervalinSeconds: TimeInterval = 60
        Timer.publish(every: refreshIntervalinSeconds, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.refreshFriendActivity()
            }
            .store(in: &cancellables)
    }
    
//    @MainActor public func setFriendActivity() async throws -> Void {
//        do {
//            let accessToken = try await self.user.getInternalAPIAccessToken().accessToken
//            let friends: [SpotifyProfile] = try await SpotifyAPI.shared.getListOfUsersFriends(internalAPIAccessToken: accessToken)
//            var friendActivities: [ListeningActivityCard] = []
//            for friend in friends.reversed() {
//                // If the friend does not exist in the database already, then
//                // add them as a friend for the user (which automatically saves them to the database)
//                if !friend.existsInDatabase() {
//                    self.user.addFriend(friend)
//                }
//                
//                await friend.storeProfilePictureLocally()
//                
//                let backgroundColor = Color(try await getAccentColorForImage((friend.currentOrMostRecentTrack?.track?.album!.image)!))
//                let activity = ListeningActivityCard(profile: friend, backgroundColor: backgroundColor)
//                friendActivities.append(activity)
//            }
//            self.friendActivites = friendActivities
//        } catch {
//            printError("\(error)")
//            throw error
//        }
//    }
    
    private func refreshFriendActivity() {
        Task {
//            try? await setFriendActivity()
        }
    }
}
