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
    /// - Returns: The list of `SharedResource` created and shared, or `nil` on error.
    ///
    /// The signed in user is the sender.
    public func share(resource: SpotifyResource, to receivers: Set<SpotifyProfile>)
    async -> [SharedResource]? {
        do {
            guard let sender = self.user else { throw AuthorizationError.missingUser }
            var sharedResources: [SharedResource] = []
            
            for receiver in receivers {
                let sharedResource = SharedResource(resource: resource, sender: sender, receiver: receiver)
                try await ShareServiceManager.shared.share(resource: sharedResource)
                sharedResources.append(sharedResource)
            }
            return sharedResources
        } catch {
            printError("When sharing resources: \(error)")
            return nil
        }
    }
    
    /// Retrieves the resources received by the currently signed-in user.
    ///
    /// - Returns: An array of `SharedResource` objects if successful, or `nil` if an error occurs.
    ///
    /// This function fetches the resources shared with the currently signed-in user.
    /// It first validates that a user is signed in and then delegates the fetching to `getReceivedResources(receiver:)`.
    public func getCurrentUsersReceivedResources() async -> [SharedResource]? {
        do {
            guard let signedInUser = self.user else { throw AuthorizationError.missingUser }
            return await self.getReceivedResources(receiver: signedInUser)
        } catch {
            printError("When getting resources received: \(error).")
            return nil
        }
    }
    
    /// Retrieves the resources received by a specific user.
    ///
    /// - Parameter receiver: The `User` object representing the recipient of the shared resources.
    /// - Returns: An array of `SharedResource` objects if successful, or `nil` if an error occurs.
    ///
    /// This function fetches the shared resources received by the specified user from the `ShareServiceManager`.
    public func getReceivedResources(receiver: User) async -> [SharedResource]? {
        do {
            let resources: [SharedResource] = try await ShareServiceManager.shared.fetchReceivedResources(receiver: receiver)
            return resources
        } catch {
            printError("When getting resources received: \(error).")
            return nil
        }
    }
    
    /// Retrieves the resources sent by the currently signed-in user.
    ///
    /// - Returns: An array of `SharedResource` objects if successful, or `nil` if an error occurs.
    ///
    /// This function fetches the resources shared by the currently signed-in user.
    /// It first validates that a user is signed in and then delegates the fetching to `getSentResources(sender:)`.
    public func getCurrentUsersSentResources() async -> [SharedResource]? {
        do {
            guard let signedInUser = self.user else { throw AuthorizationError.missingUser }
            return await self.getSentResources(sender: signedInUser)
        } catch {
            printError("When getting resources sent: \(error).")
            return nil
        }
    }
    
    /// Retrieves the resources sent by a specific user.
    ///
    /// - Parameter sender: The `User` object representing the sender of the shared resources.
    /// - Returns: An array of `SharedResource` objects if successful, or `nil` if an error occurs.
    ///
    /// This function fetches the shared resources sent by the specified user from the `ShareServiceManager`.
    public func getSentResources(sender: User) async -> [SharedResource]? {
        do {
            let resources: [SharedResource] = try await ShareServiceManager.shared.fetchSentResources(sender: sender)
            return resources
        } catch {
            printError("When getting resources sent: \(error).")
            return nil
        }
    }
    
    // TODO: Complete when implementing pagination
    public func fetchNextSearchResults () {}
}
