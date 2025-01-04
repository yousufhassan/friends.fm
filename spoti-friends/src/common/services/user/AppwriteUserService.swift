import Foundation
import Appwrite

/// The `AppwriteUserService` class provides functionality to interact with user data stored in the Appwrite database.
///
/// It allows checking if a user exists, retrieving user details from the database, and saving user information.
/// The class conforms to the `UserServiceProtocol`, which ensures it provides the necessary user-related operations.
class AppwriteUserService: UserServiceProtocol {
    let usersCollectionId = "users"
    
    init() {}
    
    public func userExists(withSpotifyId spotifyId: String) async -> Bool {
        let query = Query.equal("$id", value: spotifyId)
        let documents = await Appwrite.shared.listDocuments(collectionId: usersCollectionId,
                                                            queries: [query])
        return documents?.total == 1
    }
    
    public func getUserFromDB(withSpotifyId spotifyId: String) async throws -> User {
        guard let document = await Appwrite.shared.getDocument(collectionId: usersCollectionId,
                                                               documentId: spotifyId)
        else {
            printInfo("User (id=\(spotifyId)) could not be found.")
            throw UserServiceError.userNotFound
        }
        let data = try JSONEncoder().encode(document.data)
        let user = try JSONDecoder().decode(User.self, from: data)
        return user
    }
    
    public func saveUserToDB(_ user: User) async throws -> Void {
        let data = try JSONEncoder().encode(user)
        try await Appwrite.shared.createDocument(collectionId: usersCollectionId,
                                                 documentId: user.spotifyId, data: data)
    }
    
    public func updateUserInDB(_ user: User) async throws -> Void {
        let data = try JSONEncoder().encode(user)
        try await Appwrite.shared.updateDocument(collectionId: usersCollectionId,
                                                 documentId: user.spotifyId, data: data)
    }
}
