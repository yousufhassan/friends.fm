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
    
    func fetchSentResources(sender: SpotifyProfile, limit: Int, lastResourceId: UUID?)
    async throws -> [SharedResource] {
        // Create queries
        let senderQuery = Query.equal(SharedResource.CodingKeys.sender.rawValue, value: sender.getSpotifyId())
        let recentFirstQuery = Query.orderDesc(SharedResource.CodingKeys.sharedTs.rawValue)
        let limitQuery = Query.limit(limit)
        var queries = [senderQuery, recentFirstQuery, limitQuery]
        
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
        let signedInUser: User
        if let cachedUser = Cache.shared.getSignedInUser() {
            signedInUser = cachedUser
        } else {
            signedInUser = try await UserServiceManager.shared.getUserFromDB(withSpotifyId: sender.getSpotifyId())
        }
        let accessToken = try await UserServiceManager.shared.getSpotifyWebAccessToken(forUser: signedInUser)
        
        var sentResources: [SharedResource] = []
        for document in documents.documents {
            let data = try JSONEncoder().encode(document.data)
            let sharedResource = try JSONDecoder().decode(SharedResource.self, from: data)
            
            // TODO: Extract into helper method because fetch call will be different depending on `resourceType`.
            let pathParams: [String:String] = ["id": sharedResource.getResourceId()]
            let resource = try await SpotifyAPI.shared.fetch(method: .GET, endpoint: .getTrack,
                                                             responseType: Track.self,
                                                             accessToken: accessToken.getAccessToken(),
                                                             pathParams: pathParams)
            sharedResource.setResource(resource: resource)
            sentResources.append(sharedResource)
        }
        
        return sentResources
    }
    
    func fetchReceivedResources(receiver: SpotifyProfile, limit: Int, lastResourceId: UUID?)
    async throws -> [SharedResource] {
        // Create queries
        let receiverQuery = Query.equal(SharedResource.CodingKeys.receiver.rawValue, value: receiver.getSpotifyId())
        let limitQuery = Query.limit(limit)
        var queries = [receiverQuery, limitQuery]
        
        if let lastResourceId = lastResourceId {
            let paginationQuery = Query.cursorAfter(lastResourceId.uuidString)
            queries.append(paginationQuery)
        }
        
        // Fetch matching documents
        guard let documents = await
                Appwrite.shared.listDocuments(collectionId: sharedResourcesCollectionId, queries: queries) else {
            printInfo("No received resources found for the signed in user.")
            return []
        }
        
        // Convert each document to a SharedResource and return as an array
        let signedInUser: User
        if let cachedUser = Cache.shared.getSignedInUser() {
            signedInUser = cachedUser
        } else {
            signedInUser = try await UserServiceManager.shared.getUserFromDB(withSpotifyId: receiver.getSpotifyId())
        }
        let accessToken = try await UserServiceManager.shared.getSpotifyWebAccessToken(forUser: signedInUser)
        
        var receivedResources: [SharedResource] = []
        for document in documents.documents {
            let data = try JSONEncoder().encode(document.data)
            let sharedResource = try JSONDecoder().decode(SharedResource.self, from: data)
            
            // TODO: Extract into helper method because fetch call will be different depending on `resourceType`.
            let pathParams: [String:String] = ["id": sharedResource.getResourceId()]
            let resource = try await SpotifyAPI.shared.fetch(method: .GET, endpoint: .getTrack,
                                                             responseType: Track.self,
                                                             accessToken: accessToken.getAccessToken(),
                                                             pathParams: pathParams)
            sharedResource.setResource(resource: resource)
            receivedResources.append(sharedResource)
        }
        
        return receivedResources
    }
}
