import Foundation
import Combine
import SwiftUI

class FriendActivityViewModel: ObservableObject {
    @Published var user: User
    @Published var friendActivites: [ListeningActivityCard]
    private var cancellables = Set<AnyCancellable>()
    
    init(user: User, friendActivites: [ListeningActivityCard]) {
        self.user = user
        self.friendActivites = friendActivites
        
        let refreshInterval: TimeInterval = 60
        Timer.publish(every: refreshInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.refreshFriendActivity()
            }
            .store(in: &cancellables)
    }
    
    @MainActor public func setFriendActivity() async throws -> Void {
        do {
            let accessToken = try await self.user.getInternalAPIAccessToken().accessToken
            let friends: [SpotifyProfile] = try await SpotifyAPI.shared.getListOfUsersFriends(internalAPIAccessToken: accessToken)
            var friendActivities: [ListeningActivityCard] = []
            for friend in friends.reversed() {
                // If the friend does not exist in the database already, then
                // add them as a friend for the user (which automatically saves them to the database)
                if !friend.existsInDatabase() {
                    self.user.addFriend(friend)
                }
                
                await friend.storeProfilePictureLocally()
                
                let backgroundColor = Color(try await getAccentColorForImage((friend.currentOrMostRecentTrack?.track?.album!.image)!))
                let activity = ListeningActivityCard(profile: friend, backgroundColor: backgroundColor)
                friendActivities.append(activity)
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
    
//    /// Stores the profile picture on disk.
//    ///
//    /// - Parameters:
//    ///   - imageName: The name to store the image as (will be the user's Spotify ID)
//    ///   - link: The URL at which the image is stored.
//    private func storeProfilePictureLocally(imageName: String, link: String) async -> Void {
//        do {
//            // Return early if the user does not have a profile picture
//            if link == "" { return }
//            
//            // Fetch the image data
//            guard let imageURL = URL(string: link) else { return }
//            let request = URLRequest(url: imageURL)
//            let (data, _) = try await URLSession.shared.data(for: request)
//            
//            // Store image data on disk
//            let fileURL = URL.documentsDirectory.appending(path: "images/profile_pictures/\(imageName)")
//            try createDirectoryIfNotExists(at: fileURL)
//            try data.write(to: fileURL)
//        } catch {
//            printError("\(error)")
//        }
//    }
    
    /// Gets the profile picture named `imageName` from disk and returns as a `UIImage`.
    ///
    /// - Parameters:
    ///   - imageName: The name which the image is stored as (will be the user's Spotify ID).
    public func getProfilePictureFromDisk(imageName: String) -> UIImage? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent("images/profile_pictures/\(imageName)")
        if let data = try? Data(contentsOf: fileURL) {
            return UIImage(data: data)
        }
        return nil
    }
}
