import Foundation

/// Errors related to the Spotify Web API.
enum SpotifyAPIError: Error {
    case invalidToken
    case unsuccessfulRequest
    case unknown
}


/// Throws the appropriate Spotify API error.
///
/// - Parameters:
///   - response: The Spotify API response
///
/// - Throws: A Spotify API error corresponding to what went wrong.
internal func throwSpotifyAPIError(_ response: HTTPURLResponse) throws {
    if response.statusCode == 401 {
        printError("Unauthorized - The request requires user authentication or, if the request included authorization credentials, authorization has been refused for those credentials.")
        throw SpotifyAPIError.invalidToken
    }
}
