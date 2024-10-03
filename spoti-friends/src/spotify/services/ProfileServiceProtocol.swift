import Foundation

/// A protocol that defines the methods for interacting with the Spotify Profile service.
protocol ProfileServiceProtocol {
    
    /// Checks if a spotify profile exists in the database using their Spotify ID.
    ///
    /// - Parameter spotifyId: The Spotify ID of the profile to check.
    /// - Returns: A `Bool` indicating whether the user exists (`true`) or not (`false`).
    ///
    /// This method asynchronously checks if a profile exists in the database based on the given Spotify ID.
    func profileExists(withSpotifyId spotifyId: String) async -> Bool
    
    /// Retrieves a Spotify Profile from the database using their Spotify ID.
    ///
    /// - Parameter spotifyId: The Spotify ID of the Spotify Profile to retrieve.
    /// - Returns: An optional `AppwriteSpotifyProfile` object representing the Spotify Profile, or `nil` if the user could not be found.
    /// - Throws: An error if the retrieval process fails.
    ///
    /// This method asynchronously fetches a Spotify Profile from the database by their Spotify ID.
    /// If no Spotify Profile with the given Spotify ID is found, it returns `nil`.
    func getProfileFromDB(withSpotifyId spotifyId: String) async throws -> AppwriteSpotifyProfile?
    
    /// Saves a Spotify Profile to the database.
    ///
    /// - Parameter profile: The `AppwriteSpotifyProfile` object to save.
    /// - Returns: This method does not return a value.
    /// - Note: If an error occurs during the save operation, it will be caught and logged, but not thrown.
    ///
    /// This method attempts to save the given Spotify Profile to the database asynchronously.
    /// If the operation fails, an error is logged without interrupting the flow.
//    func saveProfileToDB(_ profile: AppwriteUser) async throws -> Void
}
