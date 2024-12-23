import Foundation
import Appwrite

// TODO: Add better class documentation.
/// The `AppwriteUserService` class provides functionality to interact with shared resource data stored in the Appwrite database.
class AppwriteShareService: ShareServiceProtocol {
    let sharedResourcesCollectionId = "sharedResources"
    
    public func share(resource: SharedResource) async throws -> Void {
        let data = try JSONEncoder().encode(resource)
        try await Appwrite.shared.createDocument(collectionId: sharedResourcesCollectionId,
                                                 documentId: resource.getIdString(),
                                                 data: data)
    }
    
    func fetchSentResources(sender: User, limit: Int, lastResourceId: UUID?)
    async throws -> [SharedResource] {
        // Create queries
        let senderQuery = Query.equal(SharedResource.CodingKeys.sender.rawValue, value: sender.spotifyId)
        let limitQuery = Query.limit(limit)
        var queries = [senderQuery, limitQuery]
        
        if let lastResourceId = lastResourceId {
            let paginationQuery = Query.cursorAfter(lastResourceId.uuidString)
            queries.append(paginationQuery)
        }
        
        // Fetch matching documents
        guard let documents = await
                Appwrite.shared.listDocuments(collectionId: sharedResourcesCollectionId, queries: queries) else {
            printInfo("No sent resources found for the signed in user.")
            return []
        }
        
        // Convert each document to a SharedResource and return as an array
        var sentResources: [SharedResource] = []
        for document in documents.documents {
            let data = try JSONEncoder().encode(document.data)
            let resource = try JSONDecoder().decode(SharedResource.self, from: data)
            sentResources.append(resource)
        }
        
        return sentResources
    }
}
