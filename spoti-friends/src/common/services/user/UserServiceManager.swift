import Foundation

class UserServiceManager {
    private let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol = AppwriteUserService()) {
        self.userService = userService
    }
    
    func userExists(withSpotifyId spotifyId: String) async -> Bool {
        return await userService.userExists(withSpotifyId: spotifyId)
    }
    
    func getUserFromDB(withSpotifyId spotifyId: String) async -> AppwriteUser? {
        do {
            return try await userService.getUserFromDB(withSpotifyId: spotifyId)
        } catch {
            printError("Error when trying to get user (id=\(spotifyId)) from database.")
            printError("\(error)")
            return nil
        }
    }
}
