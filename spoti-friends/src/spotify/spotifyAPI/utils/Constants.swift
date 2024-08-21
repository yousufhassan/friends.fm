import Foundation

/// Constants relevant to the Spotify Web API.
internal enum APIConstants {
    static let host: String = "https://api.spotify.com/v1"
}

/// The Spotify Web API endpoints the app uses.
///
/// Always start the endpoint with a `/`.
internal enum APIEndpoint: String {
    case getCurrentUsersProfile = "/me"
    case getCurrentUsersPlaylists = "/me/playlists"
    case getCurrentUsersTopTracks = "/me/top/tracks"
}
