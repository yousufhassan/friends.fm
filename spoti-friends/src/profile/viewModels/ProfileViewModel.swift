import Foundation

class ProfileViewModel: ObservableObject {
    @Published var user: User
    
    // Cached values are for the logged in user only
    private var cacheClearTimer: Timer?
    @Published var cachedTopArtists: [Artist] = []
    @Published var cachedTopTracks: [Track] = []
    
    init(user: User){
        self.user = user
        startCacheTimer()
    }
    
    // Start the timer to clear cache every 10 minutes
    private func startCacheTimer() {
        cacheClearTimer = Timer.scheduledTimer(withTimeInterval: 600, repeats: true) { [weak self] _ in
            self?.clearCache()
        }
    }
    
    // Clear cached top artists
    private func clearCache() {
        cachedTopArtists.removeAll()
        cachedTopTracks.removeAll()
        print("Cache cleared")
    }
    
    // Function to invalidate the timer when no longer needed
    deinit {
        cacheClearTimer?.invalidate()
    }
    
    /// Fetches and returns the follower count for the logged in user.
    @MainActor func getCurrentUsersFollowerCount() async -> Int {
        do {
            let accessToken = try await self.user.getSpotifyWebAccessToken().access_token
            let response = try await SpotifyAPI.shared.fetch(method: .GET,
                                                             endpoint: .getCurrentUsersProfile,
                                                             responseType: GetCurrentUserProfileResponse.self,
                                                             accessToken: accessToken)
            return response.followers.total
        } catch {
            printError("\(error)")
        }
        return -1
    }
    
    /// Fetches and returns the number of public playlists for the logged in user.
    ///
    /// The endpoint only includes the user's public playlists, not their private playlists.
    @MainActor func getCurrentUsersPlaylistCount() async -> Int {
        do {
            let accessToken = try await self.user.getSpotifyWebAccessToken().access_token
            let response = try await SpotifyAPI.shared.fetch(method: .GET,
                                                             endpoint: .getCurrentUsersPlaylists,
                                                             responseType: GetCurrentUserPlayistsResponse.self,
                                                             accessToken: accessToken)
            return response.total
        } catch {
            printError("\(error)")
        }
        return -1
    }
    
    enum ProfileItems {
        case recentTracks
        case topTracks
        case topArtists
    }
    
    @MainActor func viewMoreForCurrentUser(forItem: ProfileItems, timeRange: TimeRange = .oneMonth) async -> ProfileItemsResponse? {
        let limit = 20
        
        switch forItem {
        case .recentTracks:
            let tracks = await getCurrentUsersRecentTracks(limit: limit)
            return .tracks(tracks)
        case .topTracks:
            let tracks = await getCurrentUsersTopTracks(timeRange: timeRange, limit: limit)
            return .tracks(tracks)
        case .topArtists:
            let artists = await getCurrentUsersTopArtists(timeRange: timeRange, limit: limit)
            return .artists(artists)
        }
    }
    
    /// Fetches and returns the current user's recent tracks.
    ///
    /// - Parameters:
    ///   - limit: The maximum number of items to return. Default: 5. Minimum: 1. Maximum: 50.
    @MainActor func getCurrentUsersRecentTracks(limit: Int)
    async -> TracksWithResponseMetadata? {
        do {
            let accessToken = try await self.user.getSpotifyWebAccessToken().access_token
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
            printError("\(error)")
            return nil
        }
    }
    
    /// Fetches and returns the current user's top tracks.
    ///
    /// - Parameters:
    ///   - timeRange: Over what time frame the data is calculated.
    ///   - limit: The maximum number of items to return. Default: 5. Minimum: 1. Maximum: 50.
    @MainActor func getCurrentUsersTopTracks(timeRange: TimeRange, limit: Int)
    async -> TracksWithResponseMetadata? {
        // The cache should only be used for the "View more" screen – hence the check for limit == 20.
        if (!self.cachedTopTracks.isEmpty && limit == 20) {
            return TracksWithResponseMetadata(tracks: self.cachedTopTracks, isEmpty: self.cachedTopTracks.isEmpty)
        }
        
        do {
            let accessToken = try await self.user.getSpotifyWebAccessToken().access_token
            let queryParams = [
                URLQueryItem(name: "time_range", value: timeRange.rawValue),
                URLQueryItem(name: "limit", value: String(limit))
            ]
            let response = try await SpotifyAPI.shared.fetch(method: .GET,
                                                             endpoint: .getCurrentUsersTopTracks,
                                                             responseType: GetCurrentUserTopTracksResponse.self,
                                                             accessToken: accessToken,
                                                             queryParams: queryParams)
            
            // Only cache data when opening in "View more"
            if (limit == 20) {
                self.cachedTopTracks = response.items
            }
            return TracksWithResponseMetadata(tracks: response.items, isEmpty: response.items.isEmpty)
        }
        catch {
            printError("\(error)")
            return nil
        }
    }
    
    /// Fetches and returns the current user's top artists.
    ///
    /// - Parameters:
    ///   - timeRange: Over what time frame the data is calculated.
    ///   - limit: The maximum number of items to return. Default: 5. Minimum: 1. Maximum: 50.
    @MainActor func getCurrentUsersTopArtists(timeRange: TimeRange, limit: Int)
    async -> ArtistsWithResponseMetadata? {
        // The cache should only be used for the "View more" screen – hence the check for limit == 20.
        if (!self.cachedTopArtists.isEmpty && limit == 20) {
            return ArtistsWithResponseMetadata(artists: self.cachedTopArtists, isEmpty: self.cachedTopArtists.isEmpty)
        }
        
        do {
            let accessToken = try await self.user.getSpotifyWebAccessToken().access_token
            let queryParams = [
                URLQueryItem(name: "time_range", value: timeRange.rawValue),
                URLQueryItem(name: "limit", value: String(limit))
            ]
            let response = try await SpotifyAPI.shared.fetch(method: .GET,
                                                             endpoint: .getCurrentUsersTopArtists,
                                                             responseType: GetCurrentUserTopArtistsResponse.self,
                                                             accessToken: accessToken,
                                                             queryParams: queryParams)
            
            // Only cache data when opening in "View more"
            if (limit == 20) {
                self.cachedTopArtists = response.items
            }
            return ArtistsWithResponseMetadata(artists: response.items, isEmpty: response.items.isEmpty)
        }
        catch {
            printError("\(error)")
            return nil
        }
    }
}

/// Contains the structs relevant to the ProfileViewModel.
///
/// Add the response objects for the relevant API endpoints. Only add fields we are interested in.
extension ProfileViewModel {
    private struct GetCurrentUserProfileResponse: Decodable {
        let followers: Followers
        
        struct Followers: Decodable {
            let total: Int
        }
    }
    
    private struct GetCurrentUserPlayistsResponse: Decodable {
        let total: Int
    }
    
    private struct GetCurrentUserRecentTracksResponse: Decodable {
        let items: [Items]
        
        struct Items: Decodable {
            let track: Track
        }
        
        /// Combines all nested `track` objects within `items` and returns it as an array.
        func extractTracksFromItems() -> [Track] {
            var tracks: [Track] = []
            items.forEach { item in
                tracks.append(item.track)
            }
            return tracks
        }
    }
    
    enum ProfileItemsResponse {
        case tracks(TracksWithResponseMetadata?)
        case artists(ArtistsWithResponseMetadata?)
    }
    
    /// The valid values for the `time_range` parameter for the `topTracks` and `topArtists` API endpoints.
    enum TimeRange: String {
        case oneMonth = "short_term"
        case sixMonths = "medium_term"
        case oneYear = "long_term"
    }
    
    public class GetCurrentUserTopTracksResponse: Decodable {
        let items: [Track]
    }
    
    /// A struct containing a list of `Track`s and some metadata about the response.
    ///
    /// The reason that there is an `isEmpty` attribute is for the purposes of differentiating between a request that
    /// is still fetching data versus a request that has completed and returned no data (i.e. `tracks = []`). In the
    /// `ProfileView`, we cannot simply call `tracks.isEmpty` (referring to the `tracks` array itself) because
    /// it will return `true` even if the request has not completed. Therefore, by using this struct, we check for the
    /// `TracksWithResponseMetadata.isEmpty` value, which will default to `false`, unless we specify
    /// otherwise (which we do once the request has actually completed).
    ///
    /// - Parameters:
    ///   - tracks: An array of `Track` objects, potentially empty.
    ///   - isEmpty: Boolean denoting whether or not the `tracks` array is empty or not.
    struct TracksWithResponseMetadata {
        let tracks: [Track]
        let isEmpty: Bool
        
        init (tracks: [Track], isEmpty: Bool = false) {
            self.tracks = tracks
            self.isEmpty = isEmpty
        }
    }
    
    public class GetCurrentUserTopArtistsResponse: Decodable {
        let items: [Artist]
    }
    
    /// A struct containing a list of `Artist`s and some metadata about the response.
    ///
    /// The reason that there is an `isEmpty` attribute is for the purposes of differentiating between a request that
    /// is still fetching data versus a request that has completed and returned no data (i.e. `artists = []`). In the
    /// `ProfileView`, we cannot simply call `artists.isEmpty` (referring to the `artists` array itself) because
    /// it will return `true` even if the request has not completed. Therefore, by using this struct, we check for the
    /// `ArtistsWithResponseMetadata.isEmpty` value, which will default to `false`, unless we specify
    /// otherwise (which we do once the request has actually completed).
    ///
    /// - Parameters:
    ///   - artists: An array of `Artist` objects, potentially empty.
    ///   - isEmpty: Boolean denoting whether or not the `artists` array is empty or not.
    struct ArtistsWithResponseMetadata {
        let artists: [Artist]
        let isEmpty: Bool
        
        init (artists: [Artist], isEmpty: Bool = false) {
            self.artists = artists
            self.isEmpty = isEmpty
        }
    }
}
