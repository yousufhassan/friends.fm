import Foundation
import Appwrite

class AppwriteUserService: UserServiceProtocol {
    let usersCollectionId = "users"
    
    public func userExists(withSpotifyId spotifyId: String) async -> Bool {
        let query = Query.equal("$id", value: spotifyId)
        let documents = await Appwrite.shared.listDocuments(collectionId: usersCollectionId,
                                                            queries: [query])
        return documents?.total == 1
    }
    
    public func getUserFromDB(withSpotifyId spotifyId: String) async throws -> AppwriteUser {
        let document = await Appwrite.shared.getDocument(collectionId: usersCollectionId,
                                                         documentId: spotifyId)
        let data = try JSONEncoder().encode(document?.data)
        let user = try JSONDecoder().decode(AppwriteUser.self, from: data)
        return user
    }
}
