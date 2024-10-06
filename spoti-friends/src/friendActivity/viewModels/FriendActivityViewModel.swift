import Foundation
import Combine
import SwiftUI

class FriendActivityViewModel: ObservableObject {
    @Published var user: User?
    @Published var friendActivites: [ListeningActivityCard]
    private var cancellables = Set<AnyCancellable>()
    
    init(user: User?, friendActivites: [ListeningActivityCard]) {
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
    
    @MainActor public func setFriendActivity() async throws -> Void {
        do {
            guard let signedInUser = user else {
                throw FriendActivityError.missingUser
            }
            
            let accessToken = try await UserServiceManager.shared
                .getInternalAPIAccessToken(forUser: signedInUser)
                .getAccessToken()
            let friends: [SpotifyProfile] = try await SpotifyAPI.shared
                .getListOfUsersFriends(internalAPIAccessToken: accessToken)
            
            var friendActivities: [ListeningActivityCard] = []
            var addedNewFriends = false
            for friend in friends.reversed() {
                // If this is a new friend, update the `User` object to add them as a friend.
                if (!signedInUser.isFriendsWith(friend)) {
                    signedInUser.addFriend(friend)
                    addedNewFriends = true
                }
                
                await ProfileServiceManager.shared.storeProfilePictureLocally(profile: friend)

                let backgroundColor = Color(try await getAccentColorForImage((friend.currentOrMostRecentTrack?.track.album.image) ?? ""))
                let activity = ListeningActivityCard(profile: friend, backgroundColor: backgroundColor)
                friendActivities.append(activity)
            }
            
            // Update the user document if new friends were added.
            if addedNewFriends {
                try await UserServiceManager.shared.updateUserInDB(signedInUser)
            }
            self.friendActivites = friendActivities
        } catch {
            printError("\(error)")
            throw error
        }
    }
    
    private func refreshFriendActivity() {
        Task {
            try? await setFriendActivity()
        }
    }
}

enum FriendActivityError: Error {
    case missingAccessToken
    case missingUser
}
