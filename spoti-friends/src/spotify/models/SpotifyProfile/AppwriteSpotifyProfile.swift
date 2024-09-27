import Foundation

class AppwriteSpotifyProfile: Codable {
    let _documentId: String
    let spotifyId: String
    let spotifyUri: String
    var displayName: String
    var image: String?
//    var currentOrMostRecentTrack: CurrentOrMostRecentTrack?
    
    enum CodingKeys: String, CodingKey {
        case _documentId = "$id"
        case spotifyId
        case spotifyUri
        case displayName
        case image
    }
    
    init(spotifyId: String, spotifyUri: String, displayName: String, image: String? = nil) {
        self._documentId = spotifyId
        self.spotifyId = spotifyId
        self.spotifyUri = spotifyUri
        self.displayName = displayName
        self.image = image
    }
}
