import Foundation

/// Struct containing mock TrackContext objects.
struct TrackContextMock {
    static let playlistAllMySongs = TrackContext(spotifyUri: "spotify:playlist:uri", name: "all my songs")
    static let albumSour = TrackContext(spotifyUri: "spotify:album:uri", name: "SOUR")
    static let artistJonBellion = TrackContext(spotifyUri: "spotify:artist:uri", name: "Jon Bellion")
}
