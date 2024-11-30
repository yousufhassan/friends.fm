import Foundation
import SwiftUI

/// Struct containing mock Use object(s).
struct UserMock {
    static let userJimHalpert = createMockUser(spotifyId: "Jim Halpert")
    
    static func createMockUser(spotifyId: String) -> User {
        // User
        let user = User()
        user.spotifyId = spotifyId
        user.spotifyProfile = SpotifyProfileMock.jimHalpert
        
        // Friends
        let dwightSchrute = SpotifyProfileMock.dwightSchrute
        let michaelScott = SpotifyProfileMock.michaelScott
        let stanleyHudson = SpotifyProfileMock.stanleyHudson
        user.friends.append(objectsIn: [dwightSchrute, michaelScott, stanleyHudson])

        return user
    }
}
