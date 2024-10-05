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
    
    
    // TODO: This should ideally be in a Service class as well. If there are enough functions that require
    // a service class then create one. Otherwise, perhaps it can stay here.
    static public func getSpotifyIdFromUri(spotifyUri: String) -> String {
        return spotifyUri.components(separatedBy: ":").last ?? ""
    }
    
    // TODO: Same as above. These should go into a Service class.
    /// Stores the profile picture on disk using the Spotify ID as the image name.
    public func storeProfilePictureLocally() async -> Void {
        do {
            let imageName = self.spotifyId
            let link = self.image
            
            // Return early if the user does not have a profile picture
            if link == "" { return }
            
            // Fetch the image data
            guard let imageURL = URL(string: link) else { return }
            let request = URLRequest(url: imageURL)
            let (data, _) = try await URLSession.shared.data(for: request)
            
            // Store image data on disk
            let fileURL = URL.documentsDirectory.appending(path: "images/profile_pictures/\(imageName)")
            try createDirectoryIfNotExists(at: fileURL)
            try data.write(to: fileURL)
        } catch {
            printError("\(error)")
        }
    }
}

enum SpotifyProfileError: Error {
    case failedAppwriteDecode
}
