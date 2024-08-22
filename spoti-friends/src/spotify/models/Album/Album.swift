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

        // TODO: Move this logic into a helper as it is reused
        // Extract the first image URL from the `images` array
        if let images = try? container.decode([SpotifyImage].self, forKey: .image) {
            self.image = images.first?.url ?? ""
        } else {
            self.image = ""
        }
    }
}
