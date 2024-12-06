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
    private var friends: [SpotifyProfile]
    private var authorizationCode: String
    private var spotifyWebAccessToken: SpotifyWebAccessToken
    private var internalAPIAccessToken: InternalAPIAccessToken
    private var authorizationStatus: AuthorizationStatus
    private var spDcCookie: SpDcCookie
    
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
         authorizationCode: String, spotifyWebAcessToken: SpotifyWebAccessToken,
         internalAPIAccessToken: InternalAPIAccessToken,
         authorizationStatus: AuthorizationStatus = .unauthenticated,
         spDcCookie: SpDcCookie) {
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
            .decode(SpotifyWebAccessToken.self, forKey: .spotifyWebAccessToken)
        self.internalAPIAccessToken = try container
            .decode(InternalAPIAccessToken.self, forKey: .internalAPIAccessToken)
        self.authorizationStatus = try container
            .decode(AuthorizationStatus.self, forKey: .authorizationStatus)
        self.spDcCookie = try container.decode(SpDcCookie.self, forKey: .spDcCookie)
        
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
    
    public func getFriends() -> [SpotifyProfile] {
        return self.friends
    }
    
    public func addFriend(_ friend: SpotifyProfile) -> Void {
        self.friends.append(friend)
    }
    
    public func isFriendsWith(_ friend: SpotifyProfile) -> Bool {
        return self.friends.contains(friend)
    }
    
    public func getSpotifyWebAccessToken() -> SpotifyWebAccessToken {
        return self.spotifyWebAccessToken
    }
    
    public func setSpotifyWebAccessToken(_ token: SpotifyWebAccessToken) -> Void {
        self.spotifyWebAccessToken = token
    }
    
    public func getInternalAPIAccessToken() -> InternalAPIAccessToken {
        return self.internalAPIAccessToken
    }
    
    public func getAuthorizationStatus() -> AuthorizationStatus {
        return self.authorizationStatus
    }
    
    public func getSpDcCookie() -> SpDcCookie {
        return self.spDcCookie
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
