import Foundation
import SwiftUI

/// Struct containing mock User object(s).
struct UserMock {
    static let userJimHalpert = createMockUser(spotifyId: "Jim Halpert")
    
    static func createMockUser(spotifyId: String) -> User {
        let friends = [SpotifyProfileMock.dwightSchrute,
                       SpotifyProfileMock.michaelScott,
                       SpotifyProfileMock.stanleyHudson]
        
        return User(spotifyId: spotifyId,
                                spotifyProfile: SpotifyProfileMock.jimHalpert,
                                friends: friends,
                                authorizationCode: "",
                                spotifyWebAcessToken: self.createMockSpotifyWebAccessToken(),
                                internalAPIAccessToken: self.createMockInternalAPIAccessToken(),
                                spDcCookie: self.createMockSpDcCookie())
    }
    
    static private func createMockSpotifyWebAccessToken() -> AppwriteSpotifyWebAccessToken {
        return AppwriteSpotifyWebAccessToken(access_token: "",
                                             token_type: "",
                                             scope: "",
                                             expires_in: 3600,
                                             refresh_token: "",
                                             accessTokenExpirationTimestampMs: 1000000000)
    }
    
    static private func createMockInternalAPIAccessToken() -> AppwriteInternalAPIAccessToken {
        return AppwriteInternalAPIAccessToken(clientId: "",
                                              accessToken: "",
                                              accessTokenExpirationTimestampMs: 1000000000,
                                              isAnonymous: false)
    }
    
    static private func createMockSpDcCookie() -> AppwriteSpDcCookie {
        return AppwriteSpDcCookie(value: "", expiresDate: Date())
    }
}
