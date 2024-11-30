import Foundation

/// Struct containing mock Track objects.
struct TrackMock {
    static let iRememberEverything = Track(spotifyUri: "spotify:track:4KULAymBBJcPRpk1yO4dOG",
                                                     name: "I Remember Everything (feat. Kacey Musgraves)",
                                                     artists: [ArtistMock.zachBryan, ArtistMock.kaceyMusgraves],
                                                     album: AlbumMock.zachBryan,
                                                     context: TrackContextMock.playlistAllMySongs)
    
    static let traitor = Track(spotifyUri: "spotify:track:5CZ40GBx1sQ9agT82CLQCT",
                                         name: "traitor", artists: [ArtistMock.oliviaRodrigo],
                                         album: AlbumMock.sour, context: TrackContextMock.albumSour)
    
    static let luxury = Track(spotifyUri: "spotify:track:5CgFGKdTn8R5dXGEPEX6Gm",
                                        name: "Luxury", artists: [ArtistMock.jonBellion],
                                        album: AlbumMock.theDefinition, context: TrackContextMock.artistJonBellion)
}
