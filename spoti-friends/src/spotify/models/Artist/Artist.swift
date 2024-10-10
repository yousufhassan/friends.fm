import Foundation

/// Object representing a Spotify Artist.
class Artist: SpotifyResource, Codable {
    let spotifyUri: String
    let name: String
    let genres: [String]
    let image: String
    
    /// Mapping of the Swift object properties to the Spotify Web API response JSON keys.
    enum CodingKeys: String, CodingKey {
        case spotifyUri = "uri"
        case name
        case genres
        case image = "images"
    }
    
    init(spotifyUri: String, name: String, genres: [String], image: String) {
        self.spotifyUri = spotifyUri
        self.name = name
        self.genres = genres
        self.image = image
    }
    
    /// Custom initializer for decoding from Spotify API
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.spotifyUri = try container.decode(String.self, forKey: .spotifyUri)
        self.name = try container.decode(String.self, forKey: .name)
        self.genres = try container.decodeIfPresent([String].self, forKey: .genres) ?? []
        self.image = decodeAndExtractFirstSpotifyImageURL(from: container, forKey: .image)
    }
}
