import Foundation
import Appwrite

class AppwriteUserService: UserServiceProtocol {
    let usersCollectionId = "users"
    
    init() {}
    
    public func userExists(withSpotifyId spotifyId: String) async -> Bool {
        let query = Query.equal("$id", value: spotifyId)
        let documents = await Appwrite.shared.listDocuments(collectionId: usersCollectionId,
                                                            queries: [query])
        return documents?.total == 1
    }
    
    public func getUserFromDB(withSpotifyId spotifyId: String) async throws -> AppwriteUser? {
        guard let document = await Appwrite.shared.getDocument(collectionId: usersCollectionId,
                                                               documentId: spotifyId)
        else {
            printInfo("User (id=\(spotifyId)) could not be found.")
            return nil
        }
        let data = try JSONEncoder().encode(document.data)
        let user = try JSONDecoder().decode(AppwriteUser.self, from: data)
        return user
    }
    
    public func saveUserToDB(_ user: AppwriteUser) async throws -> Void {
        let data = try JSONEncoder().encode(user)
        await Appwrite.shared.createDocument(collectionId: usersCollectionId,
                                             documentId: user.spotifyId, data: data)
    }
}
