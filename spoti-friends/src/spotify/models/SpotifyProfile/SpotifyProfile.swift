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
class SpotifyProfile: Codable, Equatable, Identifiable, Hashable {
    var id: String { spotifyId }
    private let spotifyId: String
    private let spotifyUri: String
    private var displayName: String
    private var image: String
    private var currentOrMostRecentTrack: CurrentOrMostRecentTrack?
    
    /// Defining what makes two `SpotifyProfile` objects equal for conformance to the `Equatable` protocol.
    /// Two `SpotifyProfile` objects are considered equal if they have the same `spotifyId` value.
    static func == (lhs: SpotifyProfile, rhs: SpotifyProfile) -> Bool {
        return lhs.spotifyId == rhs.spotifyId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(spotifyId)
    }
    
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
    init(spotifyId: String, spotifyUri: String, displayName: String, image: String, currentOrMostRecentTrack: CurrentOrMostRecentTrack? = nil) {
        self.spotifyId = spotifyId
        self.spotifyUri = spotifyUri
        self.displayName = displayName
        self.image = image
        self.currentOrMostRecentTrack = currentOrMostRecentTrack
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
        let image = try container.decode(String.self, forKey: .image)
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
    
    // Getters and Setters
    public func getSpotifyId() -> String {
        return self.spotifyId
    }
    
    public func getSpotifyUri() -> String {
        return self.spotifyUri
    }
    
    public func getDisplayName() -> String {
        return self.displayName
    }
    
    public func setDisplayName(newName: String) {
        self.displayName = newName
    }
    
    public func getImage() -> String {
        return self.image
    }
    
    public func setImage(newImage: String) {
        self.image = newImage
    }
    
    public func getCurrentOrMostRecentTrack() -> CurrentOrMostRecentTrack? {
        return self.currentOrMostRecentTrack
    }
    
    public func setCurrentOrMostRecentTrack(track: CurrentOrMostRecentTrack) {
        self.currentOrMostRecentTrack = track
    }

    static public func getSpotifyId(fromUri uri: String) -> String {
        return uri.components(separatedBy: ":").last ?? ""
    }
}

enum SpotifyProfileError: Error {
    case failedAppwriteDecode
}
