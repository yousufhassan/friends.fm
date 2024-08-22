import Foundation
import RealmSwift

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
