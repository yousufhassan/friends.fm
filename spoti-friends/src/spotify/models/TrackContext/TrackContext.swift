import Foundation

/// Object representing a Spotify Track Content.
class TrackContext: SpotifyResource, Codable {
    let spotifyUri: String
    let spotifyId: String
    let name: String
    let type: ContextType
    
    /// The context which this track is being played in
    enum ContextType: String, Codable {
        case album
        case artist
        case playlist
        case show
    }
    
    init(spotifyUri: String, name: String) {
        self.spotifyUri = spotifyUri
        self.spotifyId = extractSpotifyIdFrom(uri: spotifyUri)
        self.name = name
        self.type = TrackContext.getContextType(fromUri: spotifyUri)
    }
    
    static func getContextType(fromUri uri: String) -> ContextType {
        let uriComponents = uri.split(separator: ":")
        var extractedType = ""
        if uriComponents.count >= 2 {
            extractedType = String(uriComponents[uriComponents.count - 2])
        }
        return ContextType(rawValue: extractedType) ?? .playlist
    }
}
