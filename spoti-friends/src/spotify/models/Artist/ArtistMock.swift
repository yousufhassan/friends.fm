import Foundation
import RealmSwift

/// Struct containing mock Artist objects.
struct ArtistMock {
    static let zachBryan = createMockArtist(spotifyUri: "spotify:artist:40ZNYROS4zLfyyBSs2PGe2", name: "Zach Bryan", genres: ["classic oklahoma country"],
                                            image: "https://i.scdn.co/image/ab6761610000e5eb4fd54df35bfcfa0fc9fc2da7")
    static let kaceyMusgraves = createMockArtist(spotifyUri: "spotify:artist:70kkdajctXSbqSMJbQO424", name: "Kacey Musgraves", genres: ["classic texas country", "country dawn"],
                                                 image: "https://i.scdn.co/image/ab6761610000e5ebc548c7ff983f25641dc71ffe")
    static let oliviaRodrigo = createMockArtist(spotifyUri: "spotify:artist:1McMsnEElThX1knmY4oliG", name: "Olivia Rodrigo", genres: ["pop"],
                                                image: "https://i.scdn.co/image/ab6761610000e5ebe03a98785f3658f0b6461ec4")
    static let jonBellion = createMockArtist(spotifyUri: "spotify:artist:50JJSqHUf2RQ9xsHs0KMHg", name: "Jon Bellion", genres: ["indie pop rap"],
                                             image: "https://i.scdn.co/image/ab6761610000e5ebe0c2c39a5bc940f905aa02f3")
    
    static func createMockArtist(spotifyUri: String, name: String, genres: [String], image: String) -> Artist {
        let artist = Artist()
        let genreList = List<String>()
        genres.forEach { genre in
            genreList.append(genre)
        }
        
        artist.spotifyUri = spotifyUri
        artist.name = name
        artist.genres = genreList
        artist.image = image
        return artist
    }
}

