import Foundation

/// Object representing a Spotify Track.
class Track: SpotifyResource, Codable {
    let spotifyUri: String
    let name: String
    let artists: [Artist]
    let album: Album
    let context: TrackContext
    
    /// Mapping of the Swift object properties to the Spotify Web API response JSON keys.
    enum CodingKeys: String, CodingKey {
        case spotifyUri = "uri"
        case name
        case artists
        case album
        case context
    }
    
    init(spotifyUri: String, name: String, artists: [Artist], album: Album, context: TrackContext) {
        self.spotifyUri = spotifyUri
        self.name = name
        self.artists = artists
        self.album = album
        self.context = context
    }
    
//    convenience required init(from decoder: any Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        
//        let spotifyUri = try container.decodeIfPresent(String.self, forKey: .spotifyUri) ?? ""
//        let name = try container.decode(String.self, forKey: .name)
//        let artists = try container.decode([Artist].self, forKey: .artists)
//        let album = try container.decode(Album.self, forKey: .album)
//        
//        self.init(spotifyUri: spotifyUri, name: name, artists: artists, album: album, context: context)
//    }
}
