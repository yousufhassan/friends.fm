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
    
    public func getProfileFromDB(withSpotifyId spotifyId: String) async throws -> SpotifyProfile? {
        guard let document = await Appwrite.shared.getDocument(collectionId: profilesCollectionId,
                                                               documentId: spotifyId)
        else {
            printInfo("Profile (id=\(spotifyId)) could not be found.")
            return nil
        }

        return try SpotifyProfile(fromAppwrite: document.data)
    }
    
    public func saveProfileToDB(_ profile: SpotifyProfile) async throws -> Void {
        let data = try JSONEncoder().encode(profile)
        try await Appwrite.shared.createDocument(collectionId: profilesCollectionId,
                                                 documentId: profile.getSpotifyId(), data: data)
    }
}
