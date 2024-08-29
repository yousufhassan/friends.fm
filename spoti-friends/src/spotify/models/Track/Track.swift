import Foundation
import RealmSwift

/// Object representing a Spotify Track.
class Track: Object, SpotifyResource, Decodable, Identifiable {
    @Persisted var spotifyUri: String
    @Persisted var name: String
    @Persisted var artists: List<Artist>
    @Persisted var album: Album?
    @Persisted var context: TrackContext?
    var id: String { spotifyUri }
    
    // Map the JSON keys to your object properties
    private enum CodingKeys: String, CodingKey {
        case spotifyUri = "uri"
        case name
        case artists
        case album
    }
    
    convenience required init(from decoder: any Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.spotifyUri = try container.decodeIfPresent(String.self, forKey: .spotifyUri) ?? ""
        self.name = try container.decode(String.self, forKey: .name)
        self.artists = try container.decode(List<Artist>.self, forKey: .artists)
        self.album = try container.decode(Album.self, forKey: .album)
    }
}
