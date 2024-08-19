import Foundation

/// Constants relevant to the Spotify Web API.
internal enum APIConstants {
    static let host: String = "https://api.spotify.com/v1"
}

/// The Spotify Web API endpoints the app uses.
internal enum APIEndpoint: String {
    case getCurrentUsersProfile = "/me"
    case getCurrentUsersPlaylists = "/me/playlists"
}
