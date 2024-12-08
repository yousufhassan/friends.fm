import Foundation

/// The `ShareViewModel` class is responsible for managing and providing data related to the `SongShareView` and its subviews.
/// It handles song sharing related functionality, including search functionality.
///
/// - Parameters:
///   - user: The `User` object representing the currently logged-in user.
///
class ShareViewModel: ObservableObject {
    @Published var user: User?
    
    init(user: User?) {
        self.user = user
    }
    
    /// An enum representing the types of resources that can be searched on Spotify, such as `track`, `album`, and `artist`.
    enum SearchableResource: String, CaseIterable {
        case track
        // TODO: Maybe add functionality in the future.
        // case album
        // case artist
        // case playlist
    }
    
    /// Searches for tracks, albums, and artists on Spotify based on the provided query and resource types.
    ///
    /// - Parameters:
    ///   - resourceTypes: The types of resources to search for (e.g., track, album, artist). Searches all by default.
    ///   - text: The search query.
    ///   - limit: The maximum number of results to return. Default is 25.
    ///
    /// - Returns: An array of `Track` objects if successful, or `nil` if an error occurs.
    public func searchSpotify(for resourceTypes: [SearchableResource]? = nil, text: String,
                              limit: Int = 25) async -> [Track]? {
        do {
            guard let signedInUser = user else { throw AuthorizationError.missingUser }
            let accessToken = try await UserServiceManager.shared
                .getSpotifyWebAccessToken(forUser: signedInUser)
                .getAccessToken()
            
            // Stringify array elements for the API call.
            // If no types were specified, then search for all types (i.e. no filtering).
            let resourceTypesAsStrings = (resourceTypes ?? SearchableResource.allCases)
                .map { $0.rawValue }
                .joined(separator: ",")
            let queryParams = [
                URLQueryItem(name: "q", value: text),
                URLQueryItem(name: "type", value: resourceTypesAsStrings),
                URLQueryItem(name: "limit", value: String(limit))
            ]
            let response = try await SpotifyAPI.shared.fetch(method: .GET,
                                                             endpoint: .search,
                                                             responseType: SearchResponse.self,
                                                             accessToken: accessToken,
                                                             queryParams: queryParams)
            return response.tracks.items
            
        } catch {
            printError("When performing Spotify search: \(error)")
            return nil
        }
    }
    
    /// Shares a Spotify resource (e.g., track) with a set of receivers.
    ///
    /// - Parameters:
    ///   - resource: The Spotify resource to be shared. The resource must conform to the `SpotifyResource` protocol.
    ///   - receivers: A set of `SpotifyProfile` objects representing the users to whom the resource will be shared.
    ///
    /// - Returns: A Boolean indicating whether the sharing operation was successful (`true`) or failed (`false`).
    ///
    /// The signed in user is the sender.
    public func share<T: SpotifyResource>(resource: T, to receivers: Set<SpotifyProfile>)
    async -> Bool {
        do {
            guard let sender = self.user else { throw AuthorizationError.missingUser }
            
            for receiver in receivers {
                let sharedResource = SharedResource(resource: resource, sender: sender, receiver: receiver)
                try await ShareServiceManager.shared.share(resource: sharedResource)
            }
            return true
        } catch {
            printError("When sharing resources: \(error)")
            return false
        }
    }
    
    // TODO: Complete when implementing pagination
    public func fetchNextSearchResults () {}
}
