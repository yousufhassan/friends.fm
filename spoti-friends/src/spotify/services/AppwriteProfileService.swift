import Foundation
import Appwrite
import JSONCodable

class AppwriteProfileService: ProfileServiceProtocol {
    let profilesCollectionId = "spotifyProfiles"
    
    init() {}
    
    public func profileExists(withSpotifyId spotifyId: String) async -> Bool {
        let query = Query.equal("$id", value: spotifyId)
        let documents = await Appwrite.shared.listDocuments(collectionId: profilesCollectionId,
                                                            queries: [query])
        return documents?.total == 1
    }
    
    public func getProfileFromDB(withSpotifyId spotifyId: String) async throws -> AppwriteSpotifyProfile? {
        guard let document = await Appwrite.shared.getDocument(collectionId: profilesCollectionId,
                                                               documentId: spotifyId)
        else {
            printInfo("Profile (id=\(spotifyId)) could not be found.")
            return nil
        }

        return try AppwriteSpotifyProfile(fromAppwrite: document.data)
    }
    
//    public func saveUserToDB(_ user: AppwriteUser) async throws -> Void {
//        // If the friend already exists in the database, use that reference instead of creating
//        // a new one. Do the same for user.SpotifyProfile.
//        
//        
//        
//        let data = try JSONEncoder().encode(user)
//        try await Appwrite.shared.createDocument(collectionId: profilesCollectionId,
//                                             documentId: user.spotifyId, data: data)
//    }
}
