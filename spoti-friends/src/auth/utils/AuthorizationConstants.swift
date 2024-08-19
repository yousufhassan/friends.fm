import Foundation

/// Constants related to Spotify Authorization
internal enum AuthorizationConstants {
    static let host = "accounts.spotify.com"
    static let clientId = "c65f0c16a79c47688a0fc72f6eaf1636"
    static let redirectUri = "spoti-friends://spotify-login-callback"
    
    enum AuthorizationRequest {
        static let authorizePath = "/authorize"
        static let responseType = "code"
        static let scopes = "user-read-private user-read-email"
        static let codeChallengeMethod = "S256"
    }
    
    enum AccessToken {
        static let apiTokenPath = "/api/token"
        static let grantType = "authorization_code"
    }
    
    static var authorizationRequestParams = [
        "response_type": AuthorizationRequest.responseType,
        "client_id": clientId,
        "scope": AuthorizationRequest.scopes,
        "code_challenge_method": AuthorizationRequest.codeChallengeMethod,
        "code_challenge": "",  // will set at runtime
        "redirect_uri": redirectUri,
    ]
    
    static var accessTokenRequestParams = [
        "client_id": clientId,
        "grant_type": AccessToken.grantType,
        "code": "",  // will set at runtime
        "redirect_uri": redirectUri,
        "code_verifier": getStringFromUserDefaultsValueForKey("code_verifier"),
    ]
    
    static var refreshTokenRequestParams = [
        "grant_type": "refresh_token",
        "refresh_token": "",  // will be set at runtime
        "client_id": clientId,
        
    ]
}
