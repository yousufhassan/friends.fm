import Foundation

/// The `ProfileViewModel` class is responsible for managing and providing data related to the `ProfileView`
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
///   - cacheClearTimer: A timer used to automatically clear the cache every 12 hours.
///
class ProfileViewModel: ObservableObject {
    @Published var user: AppwriteUser
    @Published private var topTracksCache: [TimeRange: [Track]] = [:]
    @Published private var topArtistsCache: [TimeRange: [Artist]] = [:]
    private var cacheClearTimer: Timer?
    
    /// Initializes the `ProfileViewModel` with the specified `User` and starts the cache timer.
    ///
    /// - Parameter user: The currently logged-in `User` object.
    init(user: AppwriteUser){
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
    
    /// Fetches the current user's follower count from Spotify.
    ///
    /// - Returns: The number of followers the current user has, or `-1` if the fetch fails.
//    @MainActor func getCurrentUsersFollowerCount() async -> Int {
//        do {
//            let accessToken = try await self.user.getSpotifyWebAccessToken().access_token
//            let response = try await SpotifyAPI.shared.fetch(method: .GET,
//                                                             endpoint: .getCurrentUsersProfile,
//                                                             responseType: GetCurrentUserProfileResponse.self,
//                                                             accessToken: accessToken)
//            return response.followers.total
//        } catch {
//            printError("\(error)")
//        }
//        return -1
//    }
//    
//    /// Fetches the current user's public playlist count from Spotify.
//    ///
//    /// This count only includes public playlists.
//    ///
//    /// - Returns: The number of public playlists, or `-1` if the fetch fails.
//    @MainActor func getCurrentUsersPlaylistCount() async -> Int {
//        do {
//            let accessToken = try await self.user.getSpotifyWebAccessToken().access_token
//            let response = try await SpotifyAPI.shared.fetch(method: .GET,
//                                                             endpoint: .getCurrentUsersPlaylists,
//                                                             responseType: GetCurrentUserPlayistsResponse.self,
//                                                             accessToken: accessToken)
//            return response.total
//        } catch {
//            printError("\(error)")
//        }
//        return -1
//    }
//    
//    enum ProfileItems {
//        case recentTracks
//        case topTracks
//        case topArtists
//    }
//    
//    /// Fetches the specified profile item (recent tracks, top tracks, or top artists) based on the time range.
//    ///
//    /// - Parameters:
//    ///   - forItem: The profile item to fetch (recent tracks, top tracks, or top artists).
//    ///   - timeRange: The time range over which to calculate the data. Default is `.oneMonth`.
//    /// - Returns: A `ProfileItemsResponse?` that contains either tracks or artists.
//    @MainActor func viewMoreForCurrentUser(forItem: ProfileItems, timeRange: TimeRange = .oneMonth) async -> ProfileItemsResponse? {
//        let limit = 20
//        
//        switch forItem {
//        case .recentTracks:
//            let tracks = await getCurrentUsersRecentTracks(limit: limit)
//            return .tracks(tracks)
//        case .topTracks:
//            let tracks = await getCurrentUsersTopTracks(timeRange: timeRange, limit: limit)
//            return .tracks(tracks)
//        case .topArtists:
//            let artists = await getCurrentUsersTopArtists(timeRange: timeRange, limit: limit)
//            return .artists(artists)
//        }
//    }
//    
//    /// Fetches the current user's recent tracks.
//    ///
//    /// - Parameter limit: The maximum number of items to return. Default: 5. Minimum: 1. Maximum: 50.
//    /// - Returns: A `TracksWithResponseMetadata?` containing the user's recent tracks.
//    @MainActor func getCurrentUsersRecentTracks(limit: Int)
//    async -> TracksWithResponseMetadata? {
//        do {
//            let accessToken = try await self.user.getSpotifyWebAccessToken().access_token
//            let queryParams = [
//                URLQueryItem(name: "limit", value: String(limit))
//            ]
//            let response = try await SpotifyAPI.shared.fetch(method: .GET,
//                                                             endpoint: .getCurrentUsersRecentTracks,
//                                                             responseType: GetCurrentUserRecentTracksResponse.self,
//                                                             accessToken: accessToken,
//                                                             queryParams: queryParams)
//            
//            return TracksWithResponseMetadata(tracks: response.extractTracksFromItems(), isEmpty: response.items.isEmpty)
//        }
//        catch {
//            printError("\(error)")
//            return nil
//        }
//    }
//    
//    /// Fetches the current user's top tracks over the specified time range.
//    ///
//    /// - Parameters:
//    ///   - timeRange: The time range over which to calculate the data.
//    ///   - limit: The maximum number of items to return. Default: 5. Minimum: 1. Maximum: 50.
//    /// - Returns: A `TracksWithResponseMetadata?` containing the user's top tracks.
//    @MainActor func getCurrentUsersTopTracks(timeRange: TimeRange, limit: Int)
//    async -> TracksWithResponseMetadata? {
//        // The cache should only be used for the "View more" screen – hence the check for limit == 20.
//        if (limit == 20) {
//            if let tracks = getTopTracksFromCacheIfExists(timeRange: timeRange) {
//                printInfo("Found top tracks in cache for time range: \(timeRange)")
//                return TracksWithResponseMetadata(tracks: tracks, isEmpty: tracks.isEmpty)
//            }
//        }
//        
//        do {
//            let accessToken = try await self.user.getSpotifyWebAccessToken().access_token
//            let queryParams = [
//                URLQueryItem(name: "time_range", value: timeRange.rawValue),
//                URLQueryItem(name: "limit", value: String(limit))
//            ]
//            let response = try await SpotifyAPI.shared.fetch(method: .GET,
//                                                             endpoint: .getCurrentUsersTopTracks,
//                                                             responseType: GetCurrentUserTopTracksResponse.self,
//                                                             accessToken: accessToken,
//                                                             queryParams: queryParams)
//            
//            // Only cache data when opening in "View more"
//            if (limit == 20) {
//                printInfo("Fetched top tracks from Spotify for time range: \(timeRange). Saved to cache.")
//                cacheThese(topTracks: response.items, forTimeRange: timeRange)
//            }
//            return TracksWithResponseMetadata(tracks: response.items, isEmpty: response.items.isEmpty)
//        }
//        catch {
//            printError("\(error)")
//            return nil
//        }
//    }
//    
//    /// Retrieves the cached top tracks for the specified time range if they exist.
//    ///
//    /// - Parameter timeRange: The time range for the cached data.
//    /// - Returns: An optional array of `Track` objects if cached data is available.
//    private func getTopTracksFromCacheIfExists(timeRange: TimeRange) -> [Track]? {
//        return topTracksCache[timeRange]
//    }
//    
//    /// Caches the specified top tracks for the given time range.
//    ///
//    /// - Parameters:
//    ///   - topTracks: An array of `Track` objects to cache.
//    ///   - timeRange: The time range for the cached data.
//    private func cacheThese(topTracks: [Track], forTimeRange timeRange: TimeRange) -> Void {
//        self.topTracksCache[timeRange] = topTracks
//    }
//    
//    /// Fetches the current user's top artists over the specified time range.
//    ///
//    /// - Parameters:
//    ///   - timeRange: The time range over which to calculate the data.
//    ///   - limit: The maximum number of items to return. Default: 5. Minimum: 1. Maximum: 50.
//    /// - Returns: An `ArtistsWithResponseMetadata?` containing the user's top artists.
//    @MainActor func getCurrentUsersTopArtists(timeRange: TimeRange, limit: Int)
//    async -> ArtistsWithResponseMetadata? {
//        // The cache should only be used for the "View more" screen – hence the check for limit == 20.
//        if (limit == 20) {
//            if let artists = getTopArtistsFromCacheIfExists(timeRange: timeRange) {
//                printInfo("Found top artists in cache for time range: \(timeRange)")
//                return ArtistsWithResponseMetadata(artists: artists, isEmpty: artists.isEmpty)
//            }
//        }
//        
//        do {
//            let accessToken = try await self.user.getSpotifyWebAccessToken().access_token
//            let queryParams = [
//                URLQueryItem(name: "time_range", value: timeRange.rawValue),
//                URLQueryItem(name: "limit", value: String(limit))
//            ]
//            let response = try await SpotifyAPI.shared.fetch(method: .GET,
//                                                             endpoint: .getCurrentUsersTopArtists,
//                                                             responseType: GetCurrentUserTopArtistsResponse.self,
//                                                             accessToken: accessToken,
//                                                             queryParams: queryParams)
//            
//            // Only cache data when opening in "View more"
//            if (limit == 20) {
//                printInfo("Fetched top artists from Spotify for time range: \(timeRange). Saved to cache.")
//                cacheThese(topArtists: response.items, forTimeRange: timeRange)
//            }
//            return ArtistsWithResponseMetadata(artists: response.items, isEmpty: response.items.isEmpty)
//        }
//        catch {
//            printError("\(error)")
//            return nil
//        }
//    }
//    
//    /// Retrieves the cached top artists for the specified time range if they exist.
//    ///
//    /// - Parameter timeRange: The time range for the cached data.
//    /// - Returns: An optional array of `Artist` objects if cached data is available.
//    private func getTopArtistsFromCacheIfExists(timeRange: TimeRange) -> [Artist]? {
//        return topArtistsCache[timeRange]
//    }
//    
//    /// Caches the specified top artists for the given time range.
//    ///
//    /// - Parameters:
//    ///   - topArtists: An array of `Artist` objects to cache.
//    ///   - timeRange: The time range for the cached data.
//    private func cacheThese(topArtists: [Artist], forTimeRange timeRange: TimeRange) -> Void {
//        self.topArtistsCache[timeRange] = topArtists
//    }
    
}
