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
    /// - Returns: The `SpotifyProfile` object representing the profile.
    ///
    /// This method asynchronously fetches a Spotify Profile from the database by their Spotify ID.
    func getProfileFromDB(withSpotifyId spotifyId: String) async throws -> SpotifyProfile? {
        do {
            return try await profileService.getProfileFromDB(withSpotifyId: spotifyId)
        } catch {
            printError("Error when trying to get profile (id=\(spotifyId)) from database.")
            printError("\(error)")
            throw error // Bubble up the error to be handled specifically depending on the context
        }
    }
    
    /// Saves a Spotify Profile to the database.
    ///
    /// - Parameter profile: The `SpotifyProfile` object to save.
    /// - Returns: This method does not return a value.
    /// - Note: If an error occurs during the save operation, it will be caught and logged, but not thrown.
    ///
    /// This method attempts to save the given Spotify Profile to the database asynchronously.
    /// If the operation fails, an error is logged without interrupting the flow.
    func saveProfileToDB(_ profile: SpotifyProfile) async throws -> Void {
        do {
            return try await profileService.saveProfileToDB(profile)
        } catch {
            printError("Error when trying to save Spotify Profile (id=\(profile.spotifyId) to database.")
            printError("\(error)")
            throw error
        }
    }
    
    /// Asynchronously stores a Spotify user's profile picture locally.
    ///
    /// This method downloads the profile image from the provided `SpotifyProfile`, checks if the image URL is valid,
    /// fetches the image data, and stores it on disk in a directory named `profile_pictures`. If the profile has no image or
    /// an error occurs, it returns early or handles the error.
    ///
    /// - Parameter profile: The `SpotifyProfile` containing the user's `spotifyId` and profile image URL.
    ///
    /// - Note: The image is saved with the user's `spotifyId` as the filename.
    func storeProfilePictureLocally(profile: SpotifyProfile) async -> Void {
        do {
            let imageName = profile.spotifyId
            let link = profile.image
            
            // Return early if the user does not have a profile picture
            if link == "" {
                printInfo("Profile has no image; skipping.")
                return
            }
            
            // Fetch the image data
            guard let imageURL = URL(string: link) else { return }
            let request = URLRequest(url: imageURL)
            let (data, _) = try await URLSession.shared.data(for: request)
            
            // Store image data on disk
            let fileURL = URL.documentsDirectory.appending(path: "images/profile_pictures/\(imageName)")
            try createDirectoryIfNotExists(at: fileURL)
            try data.write(to: fileURL)
        } catch {
            printError("When trying to the profile image (id=\(profile.spotifyId)) locally.")
            printError("\(error)")
        }
    }
}

