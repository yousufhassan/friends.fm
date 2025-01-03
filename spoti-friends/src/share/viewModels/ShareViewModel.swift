import Foundation

/// The `ShareViewModel` class is responsible for managing and providing data related to the `SongShareView` and its subviews.
/// It handles song sharing related functionality, including search functionality.
///
/// - Parameters:
///   - user: The `User` object representing the currently logged-in user.
///
class ShareViewModel: ObservableObject {
    @Published var user: User?
    @Published var showSharedToNonUserAlert: Bool = false
    @Published var sharedToNonUserAlertText: String = ""
    
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
    public func share(resource: SpotifyResource,
                      to receivers: Set<SpotifyProfile>,
                      optimisticUpdate: (([SharedResource]) -> Void)? = nil)
    async -> [SharedResource]? {
        do {
            guard let signedInUser = self.user else { throw AuthorizationError.missingUser }
            let sender = signedInUser.spotifyProfile
            var sharedResources: [SharedResource] = []
            
            for receiver in receivers {
                let sharedResource = SharedResource(resource: resource, sender: sender, receiver: receiver)
                sharedResources.append(sharedResource)
            }
            
            Cache.shared.appendToSentResources(spotifyId: signedInUser.spotifyId, newResources: sharedResources)
            optimisticUpdate?(sharedResources)
            
            var nonUsers: [SpotifyProfile] = []
            for resource in sharedResources {
                try await ShareServiceManager.shared.share(resource: resource)
                
                // If the resource was sent to a non-user, mark them as such
                let receiver = resource.getReceiver()
                if !(await UserServiceManager.shared.userExists(withSpotifyId: receiver.getSpotifyId())) {
                    nonUsers.append(receiver)
                }
            }
            
            // Alert user if they are sharing to friends who are not app users
            if (!nonUsers.isEmpty) {
                DispatchQueue.main.async {
                    self.sharedToNonUserAlertText = self.getAlertText(for: nonUsers)
                    self.showSharedToNonUserAlert = true
                }
            }
            
            return sharedResources
        } catch {
            printError("When sharing resources: \(error)")
            return nil
        }
    }
    
    /// Returns an alert message informing the user that some of the friends they shared a song to are not using the app.
    ///
    /// - Parameter users: An array of `SpotifyProfile` objects representing the friends who are not app users.
    /// - Returns: A string containing an alert message tailored to the number of non-app users.
    private func getAlertText(for users: [SpotifyProfile]) -> String {
        let invitationCallToAction = "Invite them so they can receive your songs!"
        
        if (users.count == 1) {
            return "\(users[0].getDisplayName()) has not joined the app yet. \(invitationCallToAction)"
        }
        
        if (users.count == 2) {
            return "\(users[0].getDisplayName()) and \(users[1].getDisplayName()) have not joined the app yet. \(invitationCallToAction)"
        }
        
        // 3 or more users
        let names = users.map { $0.getDisplayName() }
        let message = "\(names.dropLast().joined(separator: ", ")), and \(names.last ?? "") have not joined the app yet. \(invitationCallToAction)"
        
        return message
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
            let receiver = signedInUser.spotifyProfile
            return await self.getReceivedResources(receiver: receiver)
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
    public func getReceivedResources(receiver: SpotifyProfile) async -> [SharedResource]? {
        do {
            if let resources = Cache.shared.getReceivedResources(spotifyId: receiver.getSpotifyId()) {
                printInfo("Retrieved received resources from cache for user (id=\(receiver.getSpotifyId()))")
                return resources
            }
            
            let resources: [SharedResource] = try await ShareServiceManager.shared.fetchReceivedResources(receiver: receiver)
            Cache.shared.cacheReceivedResources(resources, spotifyId: receiver.getSpotifyId())
            printInfo("Cached received resources for user (id=\(receiver.getSpotifyId()))")
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
            let sender = signedInUser.spotifyProfile
            return await self.getSentResources(sender: sender)
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
    public func getSentResources(sender: SpotifyProfile) async -> [SharedResource]? {
        do {
            if let resources = Cache.shared.getSentResources(spotifyId: sender.getSpotifyId()) {
                printInfo("Retrieved sent resources from cache for user (id=\(sender.getSpotifyId()))")
                return resources
            }
            
            let resources: [SharedResource] = try await ShareServiceManager.shared.fetchSentResources(sender: sender)
            Cache.shared.cacheSentResources(resources, spotifyId: sender.getSpotifyId())
            printInfo("Cached sent resources for user (id=\(sender.getSpotifyId()))")
            return resources
        } catch {
            printError("When getting resources sent: \(error).")
            return nil
        }
    }
    
    // TODO: Complete when implementing pagination
    public func fetchNextSearchResults () {}
}
