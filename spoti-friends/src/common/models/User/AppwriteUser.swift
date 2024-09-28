import Foundation

class AppwriteUser: Codable {
    let _documentId: String
    let spotifyId: String
    var spotifyProfile: AppwriteSpotifyProfile
    var friends: [AppwriteSpotifyProfile]
    var authorizationCode: String
//    var spotifyWebAccessToken: SpotifyWebAccessToken
//    var internalAPIAccessToken: InternalAPIAccessToken
//    var authorizationStatus: AuthorizationStatus
    var spDcCookie: AppwriteSpDcCookie
    
    enum CodingKeys: String, CodingKey {
        case _documentId = "$id"
        case spotifyId
        case spotifyProfile
        case friends
        case authorizationCode
        case spDcCookie
    }
    
    init(spotifyId: String, spotifyProfile: AppwriteSpotifyProfile, friends: [AppwriteSpotifyProfile], authorizationCode: String, spDcCookie: AppwriteSpDcCookie) {
        self._documentId = spotifyId
        self.spotifyId = spotifyId
        self.spotifyProfile = spotifyProfile
        self.friends = friends
        self.authorizationCode = authorizationCode
        self.spDcCookie = spDcCookie
    }
}
