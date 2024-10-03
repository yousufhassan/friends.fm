import Foundation

/// A protocol that defines the methods for interacting with the user service.
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
    /// - Parameter spotifyId: The Spotify ID of the user to retrieve.
    /// - Returns: An optional `User` object representing the user, or `nil` if the user could not be found.
    /// - Throws: An error if the retrieval process fails.
    ///
    /// This method asynchronously fetches a user from the database by their Spotify ID.
    /// If no user with the given Spotify ID is found, it returns `nil`.
    func getUserFromDB(withSpotifyId spotifyId: String) async throws -> User?
    
    /// Saves a user to the database.
    ///
    /// - Parameter user: The `User` object to save.
    /// - Returns: This method does not return a value.
    /// - Note: If an error occurs during the save operation, it will be caught and logged, but not thrown.
    ///
    /// This method attempts to save the given user to the database asynchronously.
    /// If the operation fails, an error is logged without interrupting the flow.
    func saveUserToDB(_ user: User) async throws -> Void
}

