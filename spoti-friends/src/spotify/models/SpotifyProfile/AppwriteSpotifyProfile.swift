import Foundation

class AppwriteSpotifyProfile: Codable {
    let spotifyId: String
    let spotifyUri: String
    var displayName: String
    var image: String?
//    var currentOrMostRecentTrack: CurrentOrMostRecentTrack?
    
    enum CodingKeys: String, CodingKey {
        case spotifyId = "$id"
        case spotifyUri
        case displayName
        case image
    }
    
    init(spotifyId: String, spotifyUri: String, displayName: String, image: String? = nil) {
        self.spotifyId = spotifyId
        self.spotifyUri = spotifyUri
        self.displayName = displayName
        self.image = image
    }
}
