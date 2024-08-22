import Foundation
import RealmSwift

/// Class representing a `SpotifyProfile` object.
///
/// - Parameters:
///   - spotifyId: The Spotify ID associated with this Spotify profile.
///   - spotifyUri: The Spotify unique resource identifier for this Spotify profile.
///   - displayName: The display name associated with this Spotify profile.
///   - image: The profile image for this Spotify profile.
///   - currentOrMostRecentTrack: The track last played (or currently playing)  by this Spotify profile.
class SpotifyProfile: Object, Decodable {
    @Persisted(primaryKey: true) var spotifyId: String
    @Persisted var spotifyUri: String
    @Persisted var displayName: String
    @Persisted var image: String
    @Persisted var currentOrMostRecentTrack: CurrentOrMostRecentTrack?
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.spotifyId = try container.decode(String.self, forKey: .spotifyId)
        self.spotifyUri = try container.decode(String.self, forKey: .spotifyUri)
        self.displayName = try container.decode(String.self, forKey: .displayName)
        
        // Extract the first image URL from the `images` array
        if let images = try? container.decode([SpotifyImage].self, forKey: .image) {
            self.image = images.first?.url ?? ""
        } else {
            self.image = ""
        }
    }
    
    /// Mapping of the Swift object properties to the Spotify Web API response JSON keys.
    private enum CodingKeys: String, CodingKey {
        case spotifyId = "id"
        case spotifyUri = "uri"
        case displayName = "display_name"
        case image = "images"
    }
    
    public func getSpotifyIdFromUri(spotifyUri: String) -> String {
        return spotifyUri.components(separatedBy: ":").last ?? ""
    }
    
    /// Returns `true` if the `SpotifyProfile` exists in the database and `false` otherwise.
    public func existsInDatabase() -> Bool {
        let realm = RealmDatabase.shared.getRealmInstance()
        if realm.object(ofType: SpotifyProfile.self, forPrimaryKey: self.spotifyId) == nil {
            return false
        }
        return true
    }
    
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

struct SpotifyImage: Decodable {
    let url: String
    let height: Int
    let width: Int
}
