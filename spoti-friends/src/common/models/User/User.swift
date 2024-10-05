import Foundation

/// Class representing a User of the application.
///
/// - Parameters:
///   - spotifyId: The Spotify ID of the user.
///   - spotifyProfile: The user's associated Spotify Profile.
///   - friends: A list of `SpotifyProfile`s for the user's friends.
///   - authorizationCode: The OAuth authorization code for Spotify.
///   - spotifyWebAcessToken: The Spotify web access token used to interact with the Web API.
///   - internalAPIAccessToken: The Spotify Internal API access token used to interact with the internal `/buddylist` endpoint.
///   - authorizationStatus: The status of if the user authorized the app to have access to the Spotify scopes.
///   - spDcCookie: The `sp_dc` cookie used for getting the internal API token.
class User: Codable {
    let spotifyId: String
    var spotifyProfile: SpotifyProfile
    var friends: [SpotifyProfile]
    var authorizationCode: String
    var spotifyWebAccessToken: AppwriteSpotifyWebAccessToken
    var internalAPIAccessToken: AppwriteInternalAPIAccessToken
    var authorizationStatus: AuthorizationStatus
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
    
    /// Regular initializer for creating the object directly.
    init(spotifyId: String, spotifyProfile: SpotifyProfile, friends: [SpotifyProfile],
         authorizationCode: String, spotifyWebAcessToken: AppwriteSpotifyWebAccessToken,
         internalAPIAccessToken: AppwriteInternalAPIAccessToken,
         authorizationStatus: AuthorizationStatus = .unauthenticated,
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
    
    /// Custom initializer for decoding from Appwrite.
    /// This makes sure to decode the `SpotifyProfile` using the Appwrite CodingKeys.
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode normally for other properties
        self.spotifyId = try container.decode(String.self, forKey: .spotifyId)
        self.authorizationCode = try container.decode(String.self, forKey: .authorizationCode)
        self.spotifyWebAccessToken = try container
            .decode(AppwriteSpotifyWebAccessToken.self, forKey: .spotifyWebAccessToken)
        self.internalAPIAccessToken = try container
            .decode(AppwriteInternalAPIAccessToken.self, forKey: .internalAPIAccessToken)
        self.authorizationStatus = try container
            .decode(AuthorizationStatus.self, forKey: .authorizationStatus)
        self.spDcCookie = try container.decode(AppwriteSpDcCookie.self, forKey: .spDcCookie)
        
        // Decode spotifyProfile using the Appwrite keys
        let spotifyProfileDecoder = try container.superDecoder(forKey: .spotifyProfile)
        self.spotifyProfile = try SpotifyProfile(fromAppwrite: spotifyProfileDecoder)
        
        // Decoding friends using the Appwrite keys
        var friendsContainer = try container.nestedUnkeyedContainer(forKey: .friends)
        var friends: [SpotifyProfile] = []
        while !friendsContainer.isAtEnd {
            let friendDecoder = try friendsContainer.superDecoder()
            let friendProfile = try SpotifyProfile(fromAppwrite: friendDecoder)
            friends.append(friendProfile)
        }
        self.friends = friends
    }
}

/// The status of if the user authorized the app to have access to the Spotify scopes.
enum AuthorizationStatus: String, Codable {
    /// The user has not yet been authenticated.
    case unauthenticated
    /// The user accepted the app scopes.
    case granted
    /// The user denied the app scopes.
    case denied
    /// There was an error during the authentication process.
    case error
}
