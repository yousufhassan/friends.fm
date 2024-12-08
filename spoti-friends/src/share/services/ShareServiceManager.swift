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
    func share<T: SpotifyResource>(resource: SharedResource<T>) async throws -> Void {
        return try await self.shareService.share(resource: resource)
    }
}
