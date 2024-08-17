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
    
    private struct SpotifyImage: Decodable {
        let url: String
        let height: Int
        let width: Int
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
    
    // List of methods
    //    getSpotifyId()
    //    getUsersProfileFromSpotifyId(spotifyId)  // Spotify Web API call
    //
    //    getSpotifyUri()
    //    getDisplayName()
    //    getImage()
    //
    //    getCurrentOrMostRecentTrack()
    //    refreshCurrentOrMostRecentTrack() // API call
}


/// The `SpotifyResource` protocol ensures each abiding object has a well-defined spotifyUri attribute.
protocol SpotifyResource {
    var spotifyUri: String { get }
    var name: String { get }
}

/// This extensions defines the function that returns the `spotifyUri` for all `spotifyResource` objects.
extension SpotifyResource {
    /// Returns the `spotifyUri` for this `spotifyResource`.
    func getSpotifyUri() -> String {
        return self.spotifyUri  // might need to omit the 'self' if it binds itself to the `SpotifyProfile` object
    }
}

/// Object representing a user's current or most recent track that they played.
class CurrentOrMostRecentTrack: Object, Decodable {
    @Persisted var timestamp: TimeInterval
    @Persisted var track: Track?
    @Persisted var playedWithinLastFifteenMinutes: Bool
    
    /// Returns `True` if the track was played within the last 15 minutes, `False` otherwise.
    /// We deem a track to be "playing now" if it was played within the last 15 minutes. That is how Spotify does it.
    func isTrackPlayingNow() -> Bool {
        return !hasFifteenMinutesPassed(since: self.timestamp)
    }
}

/// Object representing a Spotify Track.
class Track: Object, SpotifyResource, Decodable {
    @Persisted var spotifyUri: String
    @Persisted var name: String
    @Persisted var artist: Artist?
    @Persisted var album: Album?
    @Persisted var context: TrackContext?
}

/// Object representing a Spotify Artist.
class Artist: Object, SpotifyResource, Decodable {
    @Persisted var spotifyUri: String
    @Persisted var name: String
}

/// Object representing a Spotify Album.
class Album: Object, SpotifyResource, Decodable {
    @Persisted var spotifyUri: String
    @Persisted var name: String
    @Persisted var image: String
}

/// Object representing a Spotify Track Content.
class TrackContext: Object, SpotifyResource, Decodable {
    @Persisted var spotifyUri: String
    @Persisted var name: String
    @Persisted var type: ContextType
    
    /// The context which this track is being played in
    enum ContextType: String, PersistableEnum, Decodable {
        case album
        case artist
        case playlist
        case show
    }
    
    func extractContextTypeFromUri() -> ContextType {
        let uriComponents = self.spotifyUri.split(separator: ":")
        var extractedType = ""
        if uriComponents.count >= 2 {
            extractedType = String(uriComponents[uriComponents.count - 2])
        }
        return ContextType(rawValue: extractedType) ?? .playlist
    }
}
