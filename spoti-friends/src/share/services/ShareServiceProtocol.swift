import Foundation

/// A protocol that defines the methods related to the sharing feature.
///
/// This protocol should encapsulate the required business logic related to Spotify resource sharing (tracks, albums, etc).
protocol ShareServiceProtocol {
    
    /// Shares a Spotify resource by storing it in the database.
    ///
    /// - Parameters:
    ///   - resource: A `SharedResource` object encapsulating the Spotify resource to be shared,
    ///               along with metadata such as the sender, receiver, and timestamp.
    ///
    /// This method takes a `SharedResource` object, which can encapsulate any type of Spotify resource
    /// (e.g., a track, album, etc), and stores it in the database for sharing purposes.
    func share<T: SpotifyResource>(resource: SharedResource<T>) async throws -> Void
}
