import Foundation

class AppwriteUser: Codable {
    let spotifyId: String
    var spotifyProfile: AppwriteSpotifyProfile
    var friends: [AppwriteSpotifyProfile]
    var authorizationCode: String
    var spotifyWebAccessToken: AppwriteSpotifyWebAccessToken
    var internalAPIAccessToken: AppwriteInternalAPIAccessToken
    var authorizationStatus: AppwriteAuthorizationStatus
    var spDcCookie: AppwriteSpDcCookie
    
    enum CodingKeys: String, CodingKey {
        case spotifyId = "$id"
        case spotifyProfile
        case friends
        case authorizationCode
        case spotifyWebAccessToken
        case internalAPIAccessToken
        case authorizationStatus
        case spDcCookie
    }
    
    init(spotifyId: String, spotifyProfile: AppwriteSpotifyProfile, friends: [AppwriteSpotifyProfile],
         authorizationCode: String, spotifyWebAcessToken: AppwriteSpotifyWebAccessToken,
         internalAPIAccessToken: AppwriteInternalAPIAccessToken,
         authorizationStatus: AppwriteAuthorizationStatus = .unauthenticated,
         spDcCookie: AppwriteSpDcCookie) {
        self.spotifyId = spotifyId
        self.spotifyProfile = spotifyProfile
        self.friends = friends
        self.authorizationCode = authorizationCode
        self.spotifyWebAccessToken = spotifyWebAcessToken
        self.internalAPIAccessToken = internalAPIAccessToken
        self.authorizationStatus = authorizationStatus
        self.spDcCookie = spDcCookie
    }
}

enum AppwriteAuthorizationStatus: String, Codable {
    case unauthenticated
    case granted
    case denied
    case error
}
