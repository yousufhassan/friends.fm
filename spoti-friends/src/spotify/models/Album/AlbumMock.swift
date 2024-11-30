import Foundation

/// Struct containing mock Album objects.
struct AlbumMock {
    static let zachBryan = createMockAlbum(spotifyUri: "spotify:album:6PbnGueEO6LGodPfvNldYf", name: "Zach Bryan",
                                           image: "https://i.scdn.co/image/ab67616d0000b273e5a25ed08d1e7e0fbb440cef")
    
    static let sour = createMockAlbum(spotifyUri: "spotify:album:6s84u2TUpR3wdUv4NgKA2j", name: "SOUR",
                                      image: "https://i.scdn.co/image/ab67616d0000b273a91c10fe9472d9bd89802e5a")
    
    static let theDefinition = createMockAlbum(spotifyUri: "spotify:album:7EOvtHDxbltA0GNC4mvLAC", name: "The Definition",
                                               image: "https://i.scdn.co/image/ab67616d0000b27312388a3d3a11600641476f89")
    
    static func createMockAlbum(spotifyUri: String, name: String, image: String) -> Album {
        let album = Album()
        album.spotifyUri = spotifyUri
        album.name = name
        album.image = image
        return album
    }
}
