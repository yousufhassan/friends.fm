import Foundation

/// Struct containing mock Artist objects.
struct ArtistMock {
    static let zachBryan = createMockArtist(spotifyUri: "spotify:artist:40ZNYROS4zLfyyBSs2PGe2", name: "Zach Bryan")
    static let kaceyMusgraves = createMockArtist(spotifyUri: "spotify:artist:70kkdajctXSbqSMJbQO424", name: "Kacey Musgraves")
    static let oliviaRodrigo = createMockArtist(spotifyUri: "spotify:artist:1McMsnEElThX1knmY4oliG", name: "Olivia Rodrigo")
    static let jonBellion = createMockArtist(spotifyUri: "spotify:artist:50JJSqHUf2RQ9xsHs0KMHg", name: "Jon Bellion")
    
    static func createMockArtist(spotifyUri: String, name: String) -> Artist {
        let artist = Artist()
        artist.spotifyUri = spotifyUri
        artist.name = name
        return artist
    }
}

