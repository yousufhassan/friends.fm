import Foundation

/// The `UserServiceManager` class is responsible for managing user-related services and operations.
///
/// This class acts as a facade for interacting with the underlying user service implementation,
/// such as `AppwriteUserService`, which is responsible for accessing and manipulating user data.
///
/// This adds a layer of abstraction between the app business logic and the underlying implementation. It ensures that the
/// business logic is not coupled with the implementation, making it easier to modify and swap out in the future.
class UserServiceManager {
    static let shared = UserServiceManager()
    private let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol = AppwriteUserService()) {
        self.userService = userService
    }
    
    /// Checks if a user exists in the database using their Spotify ID.
    ///
    /// - Parameter spotifyId: The Spotify ID of the user to check.
    /// - Returns: A `Bool` indicating whether the user exists (`true`) or not (`false`).
    ///
    /// This method asynchronously checks if a user exists in the database based on the given Spotify ID.
    func userExists(withSpotifyId spotifyId: String) async -> Bool {
        return await userService.userExists(withSpotifyId: spotifyId)
    }
    
    /// Retrieves a user from the database using their Spotify ID.
    ///
    /// - Parameter spotifyId: The Spotify ID of the user to retrieve.
    /// - Returns: The `User` object representing the user.
    ///
    /// This method asynchronously fetches a user from the database by their Spotify ID.
    func getUserFromDB(withSpotifyId spotifyId: String) async throws -> User? {
        do {
            let user = try await userService.getUserFromDB(withSpotifyId: spotifyId)
            return user
        } catch {
            printError("Error when trying to get user (id=\(spotifyId)) from database.")
            printError("\(error)")
            throw error // Bubble up the error to be handled specifically depending on the context
        }
    }
    
    /// Saves a user to the database.
    ///
    /// - Parameter user: The `User` object to save.
    /// - Returns: This method does not return a value.
    /// - Note: If an error occurs during the save operation, it will be caught and logged, but not thrown.
    ///
    /// This method attempts to save the given user to the database asynchronously.
    /// If the operation fails, an error is logged without interrupting the flow.
    func saveUserToDB(_ user: User) async throws -> Void {
        do {
            return try await userService.saveUserToDB(user)
        } catch {
            printError("Error when trying to save user (id=\(user.spotifyId)) to database.")
            printError("\(error)")
            throw error
        }
    }
}
