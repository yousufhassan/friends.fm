import Foundation

/// A protocol that defines the methods for interacting with the user service.
///
/// This protocol should encapsulate the required business logic related to users.
protocol UserServiceProtocol {
    
    /// Checks if a user exists in the database using their Spotify ID.
    ///
    /// - Parameter spotifyId: The Spotify ID of the user to check.
    /// - Returns: A `Bool` indicating whether the user exists (`true`) or not (`false`).
    ///
    /// This method asynchronously checks if a user exists in the database based on the given Spotify ID.
    func userExists(withSpotifyId spotifyId: String) async -> Bool
    
    /// Retrieves a user from the database using their Spotify ID.
    ///
    /// - Parameters:
    ///   - spotifyId: The Spotify ID of the user to retrieve.
    ///   - fields: Optional. The `User` object fields to return. Default: all fields.
    /// - Returns: An optional `User` object representing the user, or `nil` if the user could not be found.
    /// - Throws: An error if the retrieval process fails.
    ///
    /// This method asynchronously fetches a user from the database by their Spotify ID.
    /// If no user with the given Spotify ID is found, it returns `nil`.
    func getUserFromDB(withSpotifyId spotifyId: String) async throws -> User
    
    /// Saves a user to the database.
    ///
    /// - Parameter user: The `User` object to save.
    /// - Returns: This method does not return a value.
    /// - Note: If an error occurs during the save operation, it will be caught and logged, but not thrown.
    ///
    /// This method attempts to save the given user to the database asynchronously.
    /// If the operation fails, an error is logged without interrupting the flow.
    func saveUserToDB(_ user: User) async throws -> Void
    
    /// Updates a user in the database.
    ///
    /// - Parameter user: The `User` object to update.
    /// - Returns: This method does not return a value.
    func updateUserInDB(_ user: User) async throws -> Void
    
    /// Retrieves the Spotify Web Access Token for the user with the given `spotifyId`.
    ///
    /// If the user already has an existing access token, it will be reused if still valid.
    /// Otherwise, a new token is fetched using the `SpotifyAuth` service.
    ///
    /// - Parameter spotifyId: The Spotify Id of the user to fetch the token for.
    /// - Returns: A `SpotifyWebAccessToken` for making authenticated requests to Spotify's Web API.
    /// - Throws: An error if token retrieval fails.
    func getSpotifyWebAccessToken(forUserWithSpotifyId spotifyId: String) async throws -> SpotifyWebAccessToken
}

