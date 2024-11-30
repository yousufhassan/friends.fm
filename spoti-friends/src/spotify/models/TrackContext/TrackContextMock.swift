import Foundation

/// Struct containing mock TrackContext objects.
struct TrackContextMock {
    static let playlistAllMySongs = createMockTrackContext(spotifyUri: "spotify:playlist:uri", name: "all my songs")
    static let albumSour = createMockTrackContext(spotifyUri: "spotify:album:uri", name: "SOUR")
    static let artistJonBellion = createMockTrackContext(spotifyUri: "spotify:artist:uri", name: "Jon Bellion")
   
    static func createMockTrackContext(spotifyUri: String = "spotify:playlist:uri", name: String) -> TrackContext {
        let context = TrackContext()
        context.spotifyUri = spotifyUri
        context.name = name
        context.type = context.extractContextTypeFromUri()
        return context
    }
}
