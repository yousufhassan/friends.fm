import Foundation
import RealmSwift

/// Struct containing mock Track objects.
struct TrackMock {
    static let iRememberEverything = createMockTrack(spotifyUri: "spotify:track:4KULAymBBJcPRpk1yO4dOG",
                                                     name: "I Remember Everything (feat. Kacey Musgraves)",
                                                     artists: [ArtistMock.zachBryan, ArtistMock.kaceyMusgraves],
                                                     album: AlbumMock.zachBryan,
                                                     context: TrackContextMock.playlistAllMySongs)
    
    static let traitor = createMockTrack(spotifyUri: "spotify:track:5CZ40GBx1sQ9agT82CLQCT",
                                         name: "traitor", artists: [ArtistMock.oliviaRodrigo],
                                         album: AlbumMock.sour, context: TrackContextMock.albumSour)
    
    static let luxury = createMockTrack(spotifyUri: "spotify:track:5CgFGKdTn8R5dXGEPEX6Gm",
                                        name: "Luxury", artists: [ArtistMock.jonBellion],
                                        album: AlbumMock.theDefinition, context: TrackContextMock.artistJonBellion)
    
    static func createMockTrack(spotifyUri: String = "", name: String, artists: [Artist], album: Album, context: TrackContext) -> Track {
        let track = Track()
        let artistList = List<Artist>()
        artists.forEach { artist in
            artistList.append(artist)
        }
        
        track.spotifyUri = spotifyUri
        track.name = name
        track.artists = artistList
        track.album = album
        track.context = context
        return track
    }

}
