import Foundation

protocol UserServiceProtocol {
    func userExists(withSpotifyId spotifyId: String) async -> Bool
    func getUserFromDB(withSpotifyId spotifyId: String) async throws -> AppwriteUser
}
