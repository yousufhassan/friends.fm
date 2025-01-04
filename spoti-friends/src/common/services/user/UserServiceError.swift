import Foundation

/// Errors related to the User Service.
enum UserServiceError: Error {
    /// There was an error fetching the user
    case userNotFound
    /// There was an error fetching the user's Spotify Web Access Token
    case spotifyWebAccessTokenNotFound
    /// There was an unknown error.
    case unknown
}
