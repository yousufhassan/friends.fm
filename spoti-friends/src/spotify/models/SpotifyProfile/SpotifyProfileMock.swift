import Foundation


/// Struct containing mock Spotify Profile objects.
struct SpotifyProfileMock {
    static let jimHalpert = createMockSpotifyProfile(spotifyId: "Jim Halpert",
                                                     track: CurrentOrMostRecentTrackMock.iRememberEverything)
    static let michaelScott = createMockSpotifyProfile(spotifyId: "michael",
                                                       track: CurrentOrMostRecentTrackMock.iRememberEverything)
    static let dwightSchrute = createMockSpotifyProfile(spotifyId: "Dwight Schrute",
                                                        track: CurrentOrMostRecentTrackMock.traitor)
    static let stanleyHudson = createMockSpotifyProfile(spotifyId: "stanleythemanly",
                                                        track: CurrentOrMostRecentTrackMock.luxury)
    
    static func createMockSpotifyProfile(spotifyId: String, image: String = "", track: CurrentOrMostRecentTrack) -> SpotifyProfile {
        let mockSpotifyProfile = SpotifyProfile()
        mockSpotifyProfile.spotifyId = spotifyId
        mockSpotifyProfile.spotifyUri = "spotify:user:\(spotifyId)"
        mockSpotifyProfile.displayName = spotifyId
        mockSpotifyProfile.image = image
        mockSpotifyProfile.currentOrMostRecentTrack = track
        return mockSpotifyProfile
    }
}
