import Foundation
import RealmSwift

/// Spotify Access Token Response Object
///
/// - Parameters:
///   - access_token: An access token that can be provided in subsequent calls, for example to Spotify Web API services.
///   - token_type: How the access token may be used: always "Bearer".
///   - scope: A space-separated list of scopes which have been granted for this access token.
///   - expires_in: The time period (in seconds) for which the access token is valid.
///   - refresh_token: The refresh token to be used to obtain new access tokens.
///   - accessTokenExpirationTimestampMs: Timestamp for when the access token expires.
class SpotifyWebAccessToken: Object, Codable {
    @Persisted var access_token: String
    @Persisted var token_type: String
    @Persisted var scope: String
    @Persisted var expires_in: Int
    @Persisted var refresh_token: String
    @Persisted var accessTokenExpirationTimestampMs: Double
    
    enum CodingKeys: String, CodingKey {
        case access_token
        case token_type
        case scope
        case expires_in
        case refresh_token
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        access_token = try container.decode(String.self, forKey: .access_token)
        token_type = try container.decode(String.self, forKey: .token_type)
        scope = try container.decode(String.self, forKey: .scope)
        expires_in = try container.decode(Int.self, forKey: .expires_in)
        refresh_token = try container.decode(String.self, forKey: .refresh_token)
        super.init()
    }
    
    required override init() {
        super.init()
    }
    
    public func setExpiryTimestamp() {
        let currentDate = Date()
        let oneHourFromNow = currentDate.addingTimeInterval(3600)
        self.accessTokenExpirationTimestampMs = oneHourFromNow.timeIntervalSince1970 * 1000
    }
}


/// Representation of the relevant fields for the `sp_dc` cookie.
///
/// - Parameters:
///   - value: The `sp_dc` cookie value.
///   - expiresDate: The expiry date of the `sp_dc` cookie.
class SpDcCookie: Object, Codable {
    @Persisted var value: String
    @Persisted var expiresDate: Date?
}


/// Object representing the Spotify Web Player Access Token used for calling the internal API.
///
/// - Parameters:
///   - clientId: Unknown usage.
///   - accessToken: Access tokem to make internal API calls.
///   - accessTokenExpirationTimestampMs: Timestamp for when the access token expires.
///   - isAnonymous: False if the access token is associated with a valid Spotify user; True otherwise.
class InternalAPIAccessToken: Object, Codable {
    @Persisted var clientId: String
    @Persisted var accessToken: String
    @Persisted var accessTokenExpirationTimestampMs: Double
    @Persisted var isAnonymous: Bool
}
