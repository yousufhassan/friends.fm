import Foundation

class AppwriteUser: Codable {
    let _documentId: String
    let spotifyId: String
    var spotifyProfile: AppwriteSpotifyProfile
//    var friends: [SpotifyProfile]
    var authorizationCode: String
//    var spotifyWebAccessToken: SpotifyWebAccessToken
//    var internalAPIAccessToken: InternalAPIAccessToken
//    var authorizationStatus: AuthorizationStatus
//    var spDcCookie: SpDcCookie
    
    enum CodingKeys: String, CodingKey {
        case _documentId = "$id"
        case spotifyId
        case spotifyProfile
        case authorizationCode
    }
    
    init(spotifyId: String, spotifyProfile: AppwriteSpotifyProfile, authorizationCode: String) {
        self._documentId = spotifyId
        self.spotifyId = spotifyId
        self.spotifyProfile = spotifyProfile
        self.authorizationCode = authorizationCode
    }
}
