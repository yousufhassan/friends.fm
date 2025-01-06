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
                    spDcCookie: self.createMockSpDcCookie(),
                    email: "jim@dundermifflin.com"
        )
    }
    
    static private func createMockSpotifyWebAccessToken() -> SpotifyWebAccessToken {
        return SpotifyWebAccessToken(access_token: "",
                                     token_type: "",
                                     scope: "",
                                     expires_in: 3600,
                                     refresh_token: "",
                                     accessTokenExpirationTimestampMs: 1000000000)
    }
    
    static private func createMockInternalAPIAccessToken() -> InternalAPIAccessToken {
        return InternalAPIAccessToken(clientId: "",
                                      accessToken: "",
                                      accessTokenExpirationTimestampMs: 1000000000,
                                      isAnonymous: false)
    }
    
    static private func createMockSpDcCookie() -> SpDcCookie {
        return SpDcCookie(value: "", expiresDate: Date())
    }
}
