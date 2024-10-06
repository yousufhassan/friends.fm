import Foundation

/// Object representing a Spotify Album.
class Album: SpotifyResource, Codable {
    let spotifyUri: String
    let name: String
    let image: String
    
    /// Mapping of the Swift object properties to the Spotify Web API response JSON keys.
    enum CodingKeys: String, CodingKey {
        case spotifyUri = "uri"
        case name
        case image = "images"
    }
    
    init(spotifyUri: String, name: String, image: String) {
        self.spotifyUri = spotifyUri
        self.name = name
        self.image = image
    }
    
//    convenience required init(from decoder: any Decoder) throws {
//        self.init()
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.spotifyUri = try container.decode(String.self, forKey: .spotifyUri)
//        self.name = try container.decode(String.self, forKey: .name)
//        self.image = decodeAndExtractFirstSpotifyImageURL(from: container, forKey: .image)
//    }
}
