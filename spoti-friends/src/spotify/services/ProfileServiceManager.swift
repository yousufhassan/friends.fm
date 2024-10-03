import Foundation

/// The `ProfileServiceManager` class is responsible for managing SpotifyProfile-related services and operations.
///
/// This class acts as a facade for interacting with the underlying profile service implementation,
/// such as `AppwriteProfileService`, which is responsible for accessing and manipulating profile data.
class ProfileServiceManager {
    static let shared = ProfileServiceManager()
    private let profileService: ProfileServiceProtocol
    
    init(profileService: ProfileServiceProtocol = AppwriteProfileService()) {
        self.profileService = profileService
    }
    
    /// Checks if a profile exists in the database using their Spotify ID.
    ///
    /// - Parameter spotifyId: The Spotify ID of the Spotify Profile to check.
    /// - Returns: A `Bool` indicating whether the Spotify Profile exists (`true`) or not (`false`).
    ///
    /// This method asynchronously checks if a Spotify Profile exists in the database based on the given Spotify ID.
    func profileExists(withSpotifyId spotifyId: String) async -> Bool {
        return await profileService.profileExists(withSpotifyId: spotifyId)
    }
    
    /// Retrieves a Spotify Profile from the database using their Spotify ID.
    ///
    /// - Parameter spotifyId: The Spotify ID of the Spotify Profile to retrieve.
    /// - Returns: The `AppwriteSpotifyProfile` object representing the profile.
    ///
    /// This method asynchronously fetches a Spotify Profile from the database by their Spotify ID.
    func getProfileFromDB(withSpotifyId spotifyId: String) async throws -> AppwriteSpotifyProfile? {
        do {
            return try await profileService.getProfileFromDB(withSpotifyId: spotifyId)
        } catch {
            printError("Error when trying to get profile (id=\(spotifyId)) from database.")
            printError("\(error)")
            throw error // Bubble up the error to be handled specifically depending on the context
        }
    }
    
//    /// Saves a user to the database.
//    ///
//    /// - Parameter user: The `AppwriteUser` object to save.
//    /// - Returns: This method does not return a value.
//    /// - Note: If an error occurs during the save operation, it will be caught and logged, but not thrown.
//    ///
//    /// This method attempts to save the given user to the database asynchronously.
//    /// If the operation fails, an error is logged without interrupting the flow.
//    func saveUserToDB(_ user: AppwriteUser) async throws -> Void {
//        do {
//            return try await profileService.saveUserToDB(user)
//        } catch {
//            printError("Error when trying to save user (id=\(user.spotifyId) to database.")
//            printError("\(error)")
//            throw error
//        }
//    }
}
