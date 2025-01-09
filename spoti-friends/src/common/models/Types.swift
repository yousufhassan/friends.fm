import Foundation
import AppwriteModels

/// Spotify Access Token Response Object
///
/// - Parameters:
///   - access_token: An access token that can be provided in subsequent calls, for example to Spotify Web API services.
///   - token_type: How the access token may be used: always "Bearer".
///   - scope: A space-separated list of scopes which have been granted for this access token.
///   - expires_in: The time period (in seconds) for which the access token is valid.
///   - refresh_token: The refresh token to be used to obtain new access tokens.
///   - accessTokenExpirationTimestampMs: Timestamp for when the access token expires.
class SpotifyWebAccessToken: Codable {
    private var access_token: String
    private var token_type: String
    private var scope: String
    private var expires_in: Int
    private var refresh_token: String
    private var accessTokenExpirationTimestampMs: Int
    
    enum CodingKeys: String, CodingKey {
        case access_token
        case token_type
        case scope
        case expires_in
        case refresh_token
        case accessTokenExpirationTimestampMs
    }
    
    init(access_token: String, token_type: String, scope: String, expires_in: Int,
         refresh_token: String, accessTokenExpirationTimestampMs: Double) {
        self.access_token = access_token
        self.token_type = token_type
        self.scope = scope
        self.expires_in = expires_in
        self.refresh_token = refresh_token
        self.accessTokenExpirationTimestampMs = Int(accessTokenExpirationTimestampMs)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.access_token = try container.decode(String.self, forKey: .access_token)
        self.token_type = try container.decode(String.self, forKey: .token_type)
        self.scope = try container.decode(String.self, forKey: .scope)
        self.expires_in = try container.decode(Int.self, forKey: .expires_in)
        self.refresh_token = try container.decode(String.self, forKey: .refresh_token)
        self.accessTokenExpirationTimestampMs = try container.decodeIfPresent(Int.self, forKey: .accessTokenExpirationTimestampMs) ?? Int(SpotifyWebAccessToken.calculateExpiryTimestamp())
    }
    
    static public func calculateExpiryTimestamp() -> TimeInterval {
        let currentDate = Date()
        let oneHourFromNow = currentDate.addingTimeInterval(3600)
        return oneHourFromNow.timeIntervalSince1970 * 1000
    }
    
    public func getAccessToken() -> String {
        return self.access_token
    }
    
    public func getScopes() -> String {
        return self.scope
    }
    
    public func getScopesArray() -> [String] {
        return self.scope.split(separator: " ").map { String($0) }
    }
    
    public func getRefreshToken() -> String {
        return self.refresh_token
    }
    
    public func getExpiryTimestamp() -> TimeInterval {
        return TimeInterval(self.accessTokenExpirationTimestampMs)
    }
}

/// Representation of the relevant fields for the `sp_dc` cookie.
///
/// - Parameters:
///   - value: The `sp_dc` cookie value.
///   - expiresDate: The expiry date of the `sp_dc` cookie. Note that this is passed in as a `Date`, but stored as a `String`.
class SpDcCookie: Codable {
    var value: String
    var expiresDate: String // Appwrite expects it as a ISO8601-string (stores it in UTC)
    
    init(value: String, expiresDate: Date) {
        self.value = value
        self.expiresDate = expiresDate.ISO8601Format()
    }
}

/// Object representing the Spotify Web Player Access Token used for calling the internal API.
///
/// - Parameters:
///   - clientId: Unknown usage.
///   - accessToken: Access tokem to make internal API calls.
///   - accessTokenExpirationTimestampMs: Timestamp for when the access token expires.
///   - isAnonymous: False if the access token is associated with a valid Spotify user; True otherwise.
class InternalAPIAccessToken: Codable {
    private var clientId: String
    private var accessToken: String
    private var accessTokenExpirationTimestampMs: Int
    private var isAnonymous: Bool
    
    init(clientId: String, accessToken: String, accessTokenExpirationTimestampMs: Double, isAnonymous: Bool) {
        self.clientId = clientId
        self.accessToken = accessToken
        self.accessTokenExpirationTimestampMs = Int(accessTokenExpirationTimestampMs)
        self.isAnonymous = isAnonymous
    }
    
    public func getClientId() -> String {
        return self.clientId
    }
    
    public func getAccessToken() -> String {
        return self.accessToken
    }
    
    public func getExpirationTimestamp() -> Double {
        return Double(self.accessTokenExpirationTimestampMs)
    }
    
    public func getIsAnonymousValue() -> Bool {
        return self.isAnonymous
    }
    
}
