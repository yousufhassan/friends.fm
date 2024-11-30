import Foundation
import RealmSwift

/// Object representing a Spotify Album.
class Album: Object, SpotifyResource, Decodable {
    @Persisted var spotifyUri: String
    @Persisted var name: String
    @Persisted var image: String
    
    // Map the JSON keys to your object properties
    private enum CodingKeys: String, CodingKey {
        case spotifyUri = "uri"
        case name
        case image = "images"
    }
    
    convenience required init(from decoder: any Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.spotifyUri = try container.decode(String.self, forKey: .spotifyUri)
        self.name = try container.decode(String.self, forKey: .name)
        self.image = decodeAndExtractFirstSpotifyImageURL(from: container, forKey: .image)
    }
}
