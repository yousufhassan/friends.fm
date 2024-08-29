import Foundation
import RealmSwift

/// Object representing a Spotify Artist.
class Artist: Object, SpotifyResource, Decodable, Identifiable {
    @Persisted var spotifyUri: String
    @Persisted var name: String
    var id: String { spotifyUri }
    
    // Map the JSON keys to your object properties
    private enum CodingKeys: String, CodingKey {
        case spotifyUri = "uri"
        case name
    }
}
