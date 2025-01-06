import Foundation

/// Object representing a Spotify Track.
class Track: SpotifyResource, Codable, Identifiable, Equatable {
    var id: String { spotifyUri }
    let spotifyUri: String
    let spotifyId: String
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
    enum SpotifyCodingKeys: String, CodingKey {
        case spotifyUri = "uri"
        case name
        case artists
        case album
        case context
    }
    
    /// Mapping of the Swift object properties to the Appwrite Collection model.
    enum AppwriteCodingKeys: String, CodingKey {
        case spotifyUri
        case name
        case artists
        case album
    }
    
    init(spotifyUri: String, name: String, artists: [Artist], album: Album, context: TrackContext? = nil) {
        self.spotifyUri = spotifyUri
        self.spotifyId = extractSpotifyIdFrom(uri: spotifyUri)
        self.name = name
        self.artists = artists
        self.album = album
        self.context = context
    }
    
    /// Custom initializer for decoding from Spotify API
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: SpotifyCodingKeys.self)
        
        self.spotifyUri = try container.decodeIfPresent(String.self, forKey: .spotifyUri) ?? ""
        self.spotifyId = extractSpotifyIdFrom(uri: spotifyUri)
        self.name = try container.decode(String.self, forKey: .name)
        self.artists = try container.decode([Artist].self, forKey: .artists)
        self.album = try container.decode(Album.self, forKey: .album)
        self.context = try container.decodeIfPresent(TrackContext.self, forKey: .context)
    }
    
    /// Custom initializer for decoding an Appwrite response from the Appwrite document data
    convenience init(fromAppwrite decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AppwriteCodingKeys.self)
        let spotifyUri = try container.decodeIfPresent(String.self, forKey: .spotifyUri) ?? ""
        let name = try container.decode(String.self, forKey: .name)
        let artists = try container.decode([Artist].self, forKey: .artists)
        let album = try container.decode(Album.self, forKey: .album)
        
        self.init(spotifyUri: spotifyUri, name: name, artists: artists, album: album)
    }
}
