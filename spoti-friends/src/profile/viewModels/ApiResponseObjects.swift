import Foundation

/// Contains the structs relevant to the ProfileViewModel.
///
/// Add the response objects for the relevant API endpoints. Only add fields we are interested in.
extension ProfileViewModel {
    internal struct GetUsersProfileResponse: Decodable {
        let followers: Followers
        
        struct Followers: Decodable {
            let total: Int
        }
    }
    
    internal struct GetCurrentUserPlayistsResponse: Decodable {
        let total: Int
    }
    
    internal struct GetCurrentUserRecentTracksResponse: Decodable {
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
    enum TimeRange: String, CaseIterable {
        // These are values that are passed to the API call
        case oneMonth = "short_term"
        case sixMonths = "medium_term"
        case oneYear = "long_term"
        
        // These are values that are displayed on screen
        var displayLabel: String {
            switch self {
            case .oneMonth:
                return "4 weeks"
            case .sixMonths:
                return "6 months"
            case .oneYear:
                return "1 year"
            }
        }
    }
    
    public class GetCurrentUserTopTracksResponse: Decodable {
        let items: [Track]
    }
    
    /// A struct containing a list of `Track`s and some metadata about the response.
    ///
    /// The reason that there is an `isEmpty` attribute is for the purposes of differentiating between a request that
    /// is still fetching data versus a request that has completed and returned no data (i.e. `tracks = []`). In the
    /// `UserProfileView`, we cannot simply call `tracks.isEmpty` (referring to the `tracks` array itself) because
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
    /// `UserProfileView`, we cannot simply call `artists.isEmpty` (referring to the `artists` array itself) because
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
