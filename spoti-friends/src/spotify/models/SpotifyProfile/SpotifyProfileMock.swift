import Foundation


/// Struct containing mock Spotify Profile objects.
struct SpotifyProfileMock {
    static let jimHalpert = createMockSpotifyProfile(spotifyId: "Jim Halpert", image: "https://ih1.redbubble.net/image.169639383.9915/st,small,845x845-pad,1000x1000,f8f8f8.u7.jpg",
                                                     track: CurrentOrMostRecentTrackMock.iRememberEverything)
    static let michaelScott = createMockSpotifyProfile(spotifyId: "michael", image: "https://ih1.redbubble.net/image.1569839435.9227/st,small,845x845-pad,1000x1000,f8f8f8.jpg",
                                                       track: CurrentOrMostRecentTrackMock.iRememberEverything)
    static let dwightSchrute = createMockSpotifyProfile(spotifyId: "Dwight Schrute", image: "https://ih1.redbubble.net/image.1565063982.8461/st,small,845x845-pad,1000x1000,f8f8f8.jpg",
                                                        track: CurrentOrMostRecentTrackMock.traitor)
    static let stanleyHudson = createMockSpotifyProfile(spotifyId: "stanleythemanly", image: "https://ih1.redbubble.net/image.702402897.9761/flat,750x,075,f-pad,750x1000,f8f8f8.u1.jpg",
                                                        track: CurrentOrMostRecentTrackMock.luxury)
    
    static func createMockSpotifyProfile
    (spotifyId: String, image: String, track: CurrentOrMostRecentTrack? = nil) -> SpotifyProfile {
        return SpotifyProfile(spotifyId: spotifyId,
                              spotifyUri: "spotify:user:\(spotifyId)",
                              displayName: spotifyId,
                              image: image,
                              currentOrMostRecentTrack: track)
    }
}
