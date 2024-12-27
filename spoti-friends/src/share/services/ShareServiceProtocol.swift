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
    /// - Throws: An error if fetching the resources fails, such as network or database errors.
    func share(resource: SharedResource) async throws -> Void
    
    
    /// Fetches a list of shared resources sent by the `sender`, with support for cursor-based pagination.
    /// This function retrieves shared resources starting after the provided `lastResourceId`,
    /// and limits the number of results based on the specified `limit`.
    ///
    /// - Parameters:
    ///   - sender: The `SpotifyProfile` who sent these resources.
    ///   - limit: Optional. The maximum number of resources to fetch in one request. Default: 25.
    ///   - lastResourceId: Optional. The ID of the last resource from the previous fetch for cursor pagination.
    ///     If `nil`, the request fetches resources from the beginning.
    ///
    /// - Returns: An array of `SharedResource` objects.
    /// - Throws: This function throws an error if the data cannot be fetched, such as a network error or invalid data response.
    func fetchSentResources(sender: SpotifyProfile, limit: Int, lastResourceId: UUID?)
    async throws -> [SharedResource]
    
    /// Fetches a list of shared resources received by the `receiver`, with support for cursor-based pagination.
    /// This function retrieves shared resources starting after the provided `lastResourceId`,
    /// and limits the number of results based on the specified `limit`.
    ///
    /// - Parameters:
    ///   - receiver: The `SpotifyProfile` who received these resources.
    ///   - limit: Optional. The maximum number of resources to fetch in one request. Default: 25.
    ///   - lastResourceId: Optional. The ID of the last resource from the previous fetch for cursor pagination.
    ///     If `nil`, the request fetches resources from the beginning.
    ///
    /// - Returns: An array of `SharedResource` objects.
    /// - Throws: This function throws an error if the data cannot be fetched, such as a network error or invalid data response.
    func fetchReceivedResources(receiver: SpotifyProfile, limit: Int, lastResourceId: UUID?)
    async throws -> [SharedResource]
}
