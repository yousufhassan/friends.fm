import Foundation

/// Object representing a Spotify Track.
class Track: SpotifyResource, Codable, Identifiable, Equatable {
    var id: String { spotifyUri }
    let spotifyUri: String
    let name: String
    let artists: [Artist]
    let album: Album
    let context: TrackContext?
    
    
    /// Defining what makes two `Track` objects equal for conformance to the `Equatable` protocol.
    /// Two `Track` objects are considered equal if they have the same `spotifyUri` value.
    static func == (lhs: Track, rhs: Track) -> Bool {
        return lhs.spotifyUri == rhs.spotifyUri
    }
    
    
    /// Mapping of the Swift object properties to the Spotify Web API response JSON keys.
    enum CodingKeys: String, CodingKey {
        case spotifyUri = "uri"
        case name
        case artists
        case album
        case context
    }
    
    init(spotifyUri: String, name: String, artists: [Artist], album: Album, context: TrackContext? = nil) {
        self.spotifyUri = spotifyUri
        self.name = name
        self.artists = artists
        self.album = album
        self.context = context
    }
    
    /// Custom initializer for decoding from Spotify API
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.spotifyUri = try container.decodeIfPresent(String.self, forKey: .spotifyUri) ?? ""
        self.name = try container.decode(String.self, forKey: .name)
        self.artists = try container.decode([Artist].self, forKey: .artists)
        self.album = try container.decode(Album.self, forKey: .album)
        self.context = try container.decodeIfPresent(TrackContext.self, forKey: .context)
    }
}
