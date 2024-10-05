import Foundation
import JSONCodable

/// Class representing a `SpotifyProfile` object.
///
/// - Parameters:
///   - spotifyId: The Spotify ID associated with this Spotify profile.
///   - spotifyUri: The Spotify unique resource identifier for this Spotify profile.
///   - displayName: The display name associated with this Spotify profile.
///   - image: The profile image for this Spotify profile.
///   - currentOrMostRecentTrack: The track last played (or currently playing)  by this Spotify profile.
class SpotifyProfile: Codable {
    let spotifyId: String
    let spotifyUri: String
    var displayName: String
    var image: String
    //    var currentOrMostRecentTrack: CurrentOrMostRecentTrack?
    
    /// Mapping of the Swift object properties to the Spotify Web API response JSON keys.
    enum SpotifyAPICodingKeys: String, CodingKey {
        case spotifyId = "id"
        case spotifyUri = "uri"
        case displayName = "display_name"
        case image = "images"
    }
    
    /// Mapping of the Swift object properties to the Appwrite Collection model.
    enum AppwriteCodingKeys: String, CodingKey {
        case spotifyId = "$id"
        case spotifyUri
        case displayName
        case image
    }
    
    /// Regular initializer for creating the object directly
    init(spotifyId: String, spotifyUri: String, displayName: String, image: String) {
        self.spotifyId = spotifyId
        self.spotifyUri = spotifyUri
        self.displayName = displayName
        self.image = image
    }
    
    /// Custom initializer for decoding from Spotify API
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SpotifyAPICodingKeys.self)
        self.spotifyId = try container.decode(String.self, forKey: .spotifyId)
        self.spotifyUri = try container.decode(String.self, forKey: .spotifyUri)
        self.displayName = try container.decode(String.self, forKey: .displayName)
        self.image = decodeAndExtractFirstSpotifyImageURL(from: container, forKey: .image)
    }
    
    /// Custom initializer for decoding an Appwrite response from a Decoder
    convenience init(fromAppwrite decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AppwriteCodingKeys.self)
        let spotifyId = try container.decode(String.self, forKey: .spotifyId)
        let spotifyUri = try container.decode(String.self, forKey: .spotifyUri)
        let displayName = try container.decode(String.self, forKey: .displayName)
        let image = decodeAndExtractFirstSpotifyImageURL(from: container, forKey: .image)
        self.init(spotifyId: spotifyId, spotifyUri: spotifyUri, displayName: displayName, image: image)
    }
    
    /// Custom initializer for decoding an Appwrite response from the Appwrite document data
    convenience init(fromAppwrite data: [String:AnyCodable]) throws {
        guard let spotifyId = data[AppwriteCodingKeys.spotifyId.rawValue]?.value as? String,
              let spotifyUri = data[AppwriteCodingKeys.spotifyUri.rawValue]?.value as? String,
              let displayName = data[AppwriteCodingKeys.displayName.rawValue]?.value as? String,
              let image = data[AppwriteCodingKeys.image.rawValue]?.value as? String
        else {
            printError("When trying to decode Appwrite data to SpotifyProfile object.")
            throw SpotifyProfileError.failedAppwriteDecode
        }
        
        self.init(spotifyId: spotifyId, spotifyUri: spotifyUri, displayName: displayName, image: image)
    }
    
    /// Custom encode method for Appwrite
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AppwriteCodingKeys.self)
        try container.encode(spotifyId, forKey: .spotifyId)
        try container.encode(spotifyUri, forKey: .spotifyUri)
        try container.encode(displayName, forKey: .displayName)
        try container.encode(image, forKey: .image)
    }

    static public func getSpotifyId(fromUri uri: String) -> String {
        return uri.components(separatedBy: ":").last ?? ""
    }
}

enum SpotifyProfileError: Error {
    case failedAppwriteDecode
}
