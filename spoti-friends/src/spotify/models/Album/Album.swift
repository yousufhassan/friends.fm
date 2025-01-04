import Foundation

/// Object representing a Spotify Album.
class Album: SpotifyResource, Codable {
    let spotifyUri: String
    let spotifyId: String
    let name: String
    let image: String
    
    /// Mapping of the Swift object properties to the Spotify Web API response JSON keys.
    enum SpotifyCodingKeys: String, CodingKey {
        case spotifyUri = "uri"
        case name
        case image = "images"
    }
    
    /// Mapping of the Swift object properties to the Appwrite Collection model.
    enum AppwriteCodingKeys: String, CodingKey {
        case spotifyUri
        case name
        case image
    }
    
    init(spotifyUri: String, name: String, image: String) {
        self.spotifyUri = spotifyUri
        self.spotifyId = extractSpotifyIdFrom(uri: spotifyUri)
        self.name = name
        self.image = image
    }
    
    /// Custom initializer for decoding from Spotify API
    required init(from decoder: any Decoder) throws {
        let spotifyContainer = try decoder.container(keyedBy: SpotifyCodingKeys.self)
        let appwriteContainer = try decoder.container(keyedBy: AppwriteCodingKeys.self)
        
        self.spotifyUri = try spotifyContainer.decodeIfPresent(String.self, forKey: .spotifyUri) ??
        appwriteContainer.decode(String.self, forKey: .spotifyUri)
        self.spotifyId = extractSpotifyIdFrom(uri: spotifyUri)
        
        self.name = try spotifyContainer.decode(String.self, forKey: .name)
        
        var image: String = decodeAndExtractFirstSpotifyImageURL(from: spotifyContainer, forKey: .image)
        
        // If the image is an empty string, then this is likely being decoded from Appwrite.
        if (image.isEmpty) {
            image = try appwriteContainer.decode(String.self, forKey: .image)
        }
        
        self.image = image
        
        
    }
    
    /// Custom initializer for decoding an Appwrite response from a Decoder
    //    convenience init(fromAppwrite decoder: Decoder) throws {
    //        let container = try decoder.container(keyedBy: AppwriteCodingKeys.self)
    //        let spotifyUri = try container.decode(String.self, forKey: .spotifyUri)
    //        let name = try container.decode(String.self, forKey: .name)
    //        let image = try container.decode(String.self, forKey: .image)
    //        self.init(spotifyUri: spotifyUri, name: name, image: image)
    //    }
}
