import Foundation

/// The `ShareServiceManager` class is responsible for managing services and operations related to the resource sharing functionality.
///
/// This class acts as a facade for interacting with the underlying share service implementation,
/// such as `AppwriteShareService`, which is responsible for accessing and manipulating resource sharing data.
///
/// This adds a layer of abstraction between the app business logic and the underlying implementation. It ensures that the
/// business logic is not coupled with the implementation, making it easier to modify and swap out in the future.
class ShareServiceManager {
    static let shared = ShareServiceManager()
    private let shareService: ShareServiceProtocol
    
    init(shareService: ShareServiceProtocol = AppwriteShareService()) {
        self.shareService = shareService
    }
    
    /// Shares a Spotify resource by storing it in the database.
    ///
    /// - Parameters:
    ///   - resource: A `SharedResource` object encapsulating the Spotify resource to be shared,
    ///               along with metadata such as the sender, receiver, and timestamp.
    ///
    /// This method takes a `SharedResource` object, which can encapsulate any type of Spotify resource
    /// (e.g., a track, album, etc), and stores it in the database for sharing purposes.
    func share(resource: SharedResource) async throws -> Void {
        return try await self.shareService.share(resource: resource)
    }
    
    /// Fetches a list of shared resources sent by the `sender`, with support for cursor-based pagination.
    /// This function retrieves shared resources starting after the provided `lastResourceId`,
    /// and limits the number of results based on the specified `limit`.
    ///
    /// - Parameters:
    ///   - sender: The user who sent these resources.
    ///   - limit: Optional. The maximum number of resources to fetch in one request. Default: 25.
    ///   - lastResourceId: Optional. The ID of the last resource from the previous fetch for cursor pagination.
    ///     If `nil`, the request fetches resources from the beginning.
    ///
    /// - Returns: An array of `SharedResource` objects of type `T`, where `T` conforms to `SpotifyResource`.
    /// - Throws: This function throws an error if the data cannot be fetched, such as a network error or invalid data response.
    func fetchSentResources(sender: User, limit: Int = 25, lastResourceId: UUID? = nil)
    async throws -> [SharedResource] {
        return try await
        self.shareService.fetchSentResources(sender: sender, limit: limit, lastResourceId: lastResourceId)
    }
    
    func fetchReceivedResources(receiver: User, limit: Int = 25, lastResourceId: UUID? = nil)
    async throws -> [SharedResource] {
        return try await
        self.shareService.fetchReceivedResources(receiver: receiver, limit: limit, lastResourceId: lastResourceId)
    }
}
