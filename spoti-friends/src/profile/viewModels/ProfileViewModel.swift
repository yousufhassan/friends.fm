import Foundation

/// The `ProfileViewModel` class is responsible for managing and providing data related to the `UserProfileView`
/// and subviews. It handles fetching the user's top tracks, top artists, and recent tracks, and
/// caches this data for quicker access.
///
/// The class includes a cache for the top tracks and top artists, which is periodically cleared
/// to avoid stale data. Additionally, it manages asynchronous API calls to fetch the user's
/// follower count, public playlist count, and profile items.
///
/// - Parameters:
///   - user: The `User` object representing the currently logged-in user.
///   - topTracksCache: A dictionary that caches the user's top tracks based on the time range.
///   - topArtistsCache: A dictionary that caches the user's top artists based on the time range.
///   - usersCache: A dictionary that caches User objects that have been queried for in the database. They are mapped by the spotifyId.
///   - cacheClearTimer: A timer used to automatically clear the cache every 12 hours.
///
class ProfileViewModel: ObservableObject {
    @Published var user: User?
    private var topTracksCache: [TimeRange: [Track]] = [:]
    private var topArtistsCache: [TimeRange: [Artist]] = [:]
    private var usersCache: [String : User] = [:]
    private var cacheClearTimer: Timer?
    
    /// Initializes the `ProfileViewModel` with the specified `User` and starts the cache timer.
    ///
    /// - Parameter user: The currently logged-in `User` object.
    init(user: User?) {
        self.user = user
        startCacheTimer()
    }
    
    /// Starts a timer that clears the cache every 12 hours.
    private func startCacheTimer() {
        let twelveHoursinSeconds: TimeInterval = 43200
        cacheClearTimer = Timer.scheduledTimer(withTimeInterval: twelveHoursinSeconds, repeats: true) { [weak self] _ in
            self?.clearCache()
        }
    }
    
    /// Clears both the top tracks and top artists caches.
    private func clearCache() {
        topTracksCache.removeAll()
        topArtistsCache.removeAll()
        printInfo("Cleared Top Tracks and Artists cache.")
    }
    
    /// Invalidates the cache timer when the `ProfileViewModel` is deallocated.
    deinit {
        cacheClearTimer?.invalidate()
    }
    
    /// Retrieves the cached user matching the spotifyId, if it exists.
    ///
    /// - Parameter spotifyId: The spotifyId of the user's Spotify profile.
    /// - Returns: An optional `User` object if cached data is available.
    private func getUserFromCacheIfExists(spotifyId: String) -> User? {
        return usersCache[spotifyId]
    }
    
    /// Caches the specified user for the associated `spotifyId`.
    ///
    /// - Parameters:
    ///   - user: A `User` object to cache.
    ///   - spotifyId: The spotifyId associated with the user's Spotify profile.
    private func cache(user: User, withSpotifyId spotifyId: String) -> Void {
        self.usersCache[spotifyId] = user
    }
    
    /// Fetches the follower count for this profile.
    ///
    /// - Parameters:
    ///   - profile: The Spotify profile to fetch the follower count for.
    ///
    /// - Returns: The number of followers the profile has, or `-1` if the fetch fails.
    func getFollowerCount(forProfile profile: SpotifyProfile) async -> Int {
        do {
            guard let signedInUser = user else { throw AuthorizationError.missingUser }
            let accessToken = try await UserServiceManager.shared
                .getSpotifyWebAccessToken(forUser: signedInUser)
                .getAccessToken()
            
            let pathParams: [String:String] = ["user_id": profile.getSpotifyId()]
            let response = try await SpotifyAPI.shared.fetch(method: .GET,
                                                             endpoint: .getUsersProfile,
                                                             responseType: GetUsersProfileResponse.self,
                                                             accessToken: accessToken,
                                                             pathParams: pathParams)
            
            return response.followers.total
        }
        catch {
            printError("When getting the follower count for the profile (id=\(profile.getSpotifyId())): \(error)")
            return -1
        }
        
    }
    
    /// Fetches the number of public playlists for this profile.
    ///
    /// This count only includes public playlists.
    ///
    /// - Returns: The number of public playlists, or `-1` if the fetch fails.
    func getPlaylistCount(forProfile profile: SpotifyProfile) async -> Int {
        do {
            guard let signedInUser = user else { throw AuthorizationError.missingUser }
            let accessToken = try await UserServiceManager.shared
                .getSpotifyWebAccessToken(forUser: signedInUser)
                .getAccessToken()
            
            let pathParams: [String:String] = ["user_id": profile.getSpotifyId()]
            let response = try await SpotifyAPI.shared.fetch(method: .GET,
                                                             endpoint: .getUsersPlaylists,
                                                             responseType: GetCurrentUserPlayistsResponse.self,
                                                             accessToken: accessToken,
                                                             pathParams: pathParams)
            return response.total
        } catch {
            printError("When getting the current user's playlist count: \(error)")
            return -1
        }
    }
    
    enum ProfileItems {
        case recentTracks
        case topTracks
        case topArtists
    }
    
    /// Fetches the specified profile item (recent tracks, top tracks, or top artists) based on the time range for the specified Spotify profile.
    ///
    /// - Parameters:
    ///   - profile: The Spotify profile to view more data for.
    ///   - forItem: The profile item to fetch (recent tracks, top tracks, or top artists).
    ///   - timeRange: The time range over which to calculate the data. Default is `.oneMonth`.
    /// - Returns: A `ProfileItemsResponse?` that contains either tracks or artists.
    func viewMore(forProfile profile: SpotifyProfile, forItem: ProfileItems, timeRange: TimeRange = .oneMonth) async -> ProfileItemsResponse? {
        let limit = 20
        
        switch forItem {
        case .recentTracks:
            let tracks = await getRecentTracks(forProfile: profile, limit: limit)
            return .tracks(tracks)
        case .topTracks:
            let tracks = await getTopTracks(forProfile: profile, timeRange: timeRange, limit: limit)
            return .tracks(tracks)
        case .topArtists:
            let artists = await getTopArtists(forProfile: profile, timeRange: timeRange, limit: limit)
            return .artists(artists)
        }
    }
    
    /// Fetches the provided profile's recent tracks.
    ///
    /// - Parameters:
    ///   - profile: The Spotify profile to return the data for.
    ///   - limit: The maximum number of items to return. Default: 5. Minimum: 1. Maximum: 50.
    /// - Returns: A `TracksWithResponseMetadata?` containing the profile's recent tracks.
    func getRecentTracks(forProfile profile: SpotifyProfile, limit: Int) async -> TracksWithResponseMetadata? {
        do {
            var associatedUser: User
            
            if let cachedUser = getUserFromCacheIfExists(spotifyId: profile.getSpotifyId()) {
                associatedUser = cachedUser
            } else {
                associatedUser = try await UserServiceManager.shared.getUserFromDB(withSpotifyId: profile.getSpotifyId())
                cache(user: associatedUser, withSpotifyId: profile.getSpotifyId())
            }
            
            let accessToken = try await UserServiceManager.shared
                .getSpotifyWebAccessToken(forUser: associatedUser)
                .getAccessToken()
            let queryParams = [
                URLQueryItem(name: "limit", value: String(limit))
            ]
            let response = try await SpotifyAPI.shared.fetch(method: .GET,
                                                             endpoint: .getCurrentUsersRecentTracks,
                                                             responseType: GetCurrentUserRecentTracksResponse.self,
                                                             accessToken: accessToken,
                                                             queryParams: queryParams)
            
            return TracksWithResponseMetadata(tracks: response.extractTracksFromItems(), isEmpty: response.items.isEmpty)
        }
        catch {
            printError("When getting the current user's recent tracks: \(error)")
            return nil
        }
    }
    
    /// Fetches the top tracks over the specified time range for the specified Spotify profile.
    ///
    /// - Parameters:
    ///   - profile: The Spotify profile to return the data for.
    ///   - timeRange: The time range over which to calculate the data.
    ///   - limit: The maximum number of items to return. Default: 5. Minimum: 1. Maximum: 50.
    /// - Returns: A `TracksWithResponseMetadata?` containing the user's top tracks.
    func getTopTracks(forProfile profile: SpotifyProfile, timeRange: TimeRange, limit: Int)
    async -> TracksWithResponseMetadata? {
        // The cache should only be used for the logged in user's "View more" screen – hence the
        // check for limit == 20 and correct profile.
        if (limit == 20 && user?.spotifyProfile == profile) {
            if let tracks = getTopTracksFromCacheIfExists(timeRange: timeRange) {
                printInfo("Found top tracks in cache for time range: \(timeRange)")
                return TracksWithResponseMetadata(tracks: tracks, isEmpty: tracks.isEmpty)
            }
        }
        
        do {
            var associatedUser: User
            
            if let cachedUser = getUserFromCacheIfExists(spotifyId: profile.getSpotifyId()) {
                associatedUser = cachedUser
            } else {
                associatedUser = try await UserServiceManager.shared.getUserFromDB(withSpotifyId: profile.getSpotifyId())
                cache(user: associatedUser, withSpotifyId: profile.getSpotifyId())
            }
            
            let accessToken = try await UserServiceManager.shared
                .getSpotifyWebAccessToken(forUser: associatedUser)
                .getAccessToken()
            let queryParams = [
                URLQueryItem(name: "time_range", value: timeRange.rawValue),
                URLQueryItem(name: "limit", value: String(limit))
            ]
            let response = try await SpotifyAPI.shared.fetch(method: .GET,
                                                             endpoint: .getCurrentUsersTopTracks,
                                                             responseType: GetCurrentUserTopTracksResponse.self,
                                                             accessToken: accessToken,
                                                             queryParams: queryParams)
            
            // Only cache data when opening in "View more" for the logged in user
            if (limit == 20 && user?.spotifyProfile == profile) {
                printInfo("Fetched top tracks from Spotify for time range: \(timeRange). Saved to cache.")
                cache(topTracks: response.items, forTimeRange: timeRange)
            }
            return TracksWithResponseMetadata(tracks: response.items, isEmpty: response.items.isEmpty)
        }
        catch {
            printError("When getting the current user's top tracks: \(error)")
            return nil
        }
    }
    
    
    
    /// Retrieves the cached top tracks for the specified time range if they exist.
    ///
    /// - Parameter timeRange: The time range for the cached data.
    /// - Returns: An optional array of `Track` objects if cached data is available.
    private func getTopTracksFromCacheIfExists(timeRange: TimeRange) -> [Track]? {
        return topTracksCache[timeRange]
    }
    
    /// Caches the specified top tracks for the given time range.
    ///
    /// - Parameters:
    ///   - topTracks: An array of `Track` objects to cache.
    ///   - timeRange: The time range for the cached data.
    private func cache(topTracks: [Track], forTimeRange timeRange: TimeRange) -> Void {
        self.topTracksCache[timeRange] = topTracks
    }
    
    /// Fetches the top artists over the specified time range for the specified Spotify profile.
    ///
    /// - Parameters:
    ///   - profile: The Spotify profile to return the data for.
    ///   - timeRange: The time range over which to calculate the data.
    ///   - limit: The maximum number of items to return. Default: 5. Minimum: 1. Maximum: 50.
    /// - Returns: An `ArtistsWithResponseMetadata?` containing the profile's top artists.
    func getTopArtists(forProfile profile: SpotifyProfile, timeRange: TimeRange, limit: Int)
    async -> ArtistsWithResponseMetadata? {
        // The cache should only be used for the logged in user's "View more" screen – hence the
        // check for limit == 20 and correct profile.
        if (limit == 20 && user?.spotifyProfile == profile) {
            if let artists = getTopArtistsFromCacheIfExists(timeRange: timeRange) {
                printInfo("Found top artists in cache for time range: \(timeRange)")
                return ArtistsWithResponseMetadata(artists: artists, isEmpty: artists.isEmpty)
            }
        }
        
        do {
            var associatedUser: User
            
            if let cachedUser = getUserFromCacheIfExists(spotifyId: profile.getSpotifyId()) {
                associatedUser = cachedUser
            } else {
                associatedUser = try await UserServiceManager.shared.getUserFromDB(withSpotifyId: profile.getSpotifyId())
                cache(user: associatedUser, withSpotifyId: profile.getSpotifyId())
            }
            
            let accessToken = try await UserServiceManager.shared
                .getSpotifyWebAccessToken(forUser: associatedUser)
                .getAccessToken()
            let queryParams = [
                URLQueryItem(name: "time_range", value: timeRange.rawValue),
                URLQueryItem(name: "limit", value: String(limit))
            ]
            let response = try await SpotifyAPI.shared.fetch(method: .GET,
                                                             endpoint: .getCurrentUsersTopArtists,
                                                             responseType: GetCurrentUserTopArtistsResponse.self,
                                                             accessToken: accessToken,
                                                             queryParams: queryParams)
            
            // Only cache data when opening in "View more" for the logged in user.
            if (limit == 20 && user?.spotifyProfile == profile) {
                printInfo("Fetched top artists from Spotify for time range: \(timeRange). Saved to cache.")
                cache(topArtists: response.items, forTimeRange: timeRange)
            }
            return ArtistsWithResponseMetadata(artists: response.items, isEmpty: response.items.isEmpty)
        }
        catch {
            printError("When getting the current user's top artists: \(error)")
            return nil
        }
    }
    
    /// Retrieves the cached top artists for the specified time range if they exist.
    ///
    /// - Parameter timeRange: The time range for the cached data.
    /// - Returns: An optional array of `Artist` objects if cached data is available.
    private func getTopArtistsFromCacheIfExists(timeRange: TimeRange) -> [Artist]? {
        return topArtistsCache[timeRange]
    }
    
    /// Caches the specified top artists for the given time range.
    ///
    /// - Parameters:
    ///   - topArtists: An array of `Artist` objects to cache.
    ///   - timeRange: The time range for the cached data.
    private func cache(topArtists: [Artist], forTimeRange timeRange: TimeRange) -> Void {
        self.topArtistsCache[timeRange] = topArtists
    }
    
}
