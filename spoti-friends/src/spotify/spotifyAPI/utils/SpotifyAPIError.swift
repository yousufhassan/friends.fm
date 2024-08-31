import Foundation

/// Errors related to the Spotify Web API.
enum SpotifyAPIError: Error {
    case unauthorized
    case forbidden
    case unknown
}


/// Throws the appropriate Spotify API error.
///
/// - Parameters:
///   - response: The Spotify API response
///
/// - Throws: A Spotify API error corresponding to what went wrong.
internal func throwSpotifyAPIError(_ response: HTTPURLResponse) throws -> SpotifyAPIError {
    if (response.statusCode == 401) {
        printError("Unauthorized - The request requires user authentication or, if the request included authorization credentials, authorization has been refused for those credentials.")
        throw SpotifyAPIError.unauthorized
    }
    else if (response.statusCode == 403) {
        printError("Forbidden - The server understood the request, but is refusing to fulfill it.")
        throw SpotifyAPIError.forbidden
    }
    else {
        printError("Unknown Spotify API Error.")
        throw SpotifyAPIError.unknown
    }
}
