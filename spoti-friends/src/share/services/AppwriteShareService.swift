import Foundation

// TODO: Add better class documentation.
/// The `AppwriteUserService` class provides functionality to interact with shared resource data stored in the Appwrite database.
class AppwriteShareService: ShareServiceProtocol {
    let sharedResourcesCollectionId = "sharedResources"
    
    public func share<T: SpotifyResource>(resource: SharedResource<T>) async throws -> Void {
        let data = try JSONEncoder().encode(resource)
        try await Appwrite.shared.createDocument(collectionId: sharedResourcesCollectionId, data: data)
    }
}
