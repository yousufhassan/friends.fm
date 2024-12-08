import Foundation

/// The `SpotifyResource` protocol ensures each abiding object has a well-defined spotifyUri attribute.
protocol SpotifyResource: Codable {
    var spotifyUri: String { get }
    var name: String { get }
}

/// This extensions defines the function that returns the `spotifyUri` for all `spotifyResource` objects.
extension SpotifyResource {
    /// Returns the `spotifyUri` for this `spotifyResource`.
    func getSpotifyUri() -> String {
        return self.spotifyUri  // might need to omit the 'self' if it binds itself to the `SpotifyProfile` object
    }
}

/// A struct representing the structure of an image object from Spotify.
struct SpotifyImage: Decodable {
    let url: String
    let height: Int
    let width: Int
}

/// Decodes an array of `SpotifyImage` objects from a `KeyedDecodingContainer` and extracts the URL of the first image.
///
/// - Parameters:
///   - container: The `KeyedDecodingContainer` from which to decode the images.
///   - key: The key used to decode the array of `SpotifyImage` objects.
/// - Returns: The URL of the first image if available; otherwise, an empty string.
///
/// IMPORTANT NOTE: This function has been extended to decode from Appwrite as well, which stores a single image as a `String`.
/// I did not create new decoders for tracks, albums, artists, and more because we are not storing them in the database as of writing this/
/// We don't want to persist or manage the data; Spotify is responsible for that. However, the decoders for these tracks, artists, albums
/// are still specific to the Spotify API response objects and they use this function to decode the images. I have added the `else if`
/// branch which the code will fall into if it cannot decode it as a `[SpotifyImage]`. That would indicate we are decoding from
/// Appwrite and not Spotify.
/// I know. I don't like it either. But I thought it was better than writing new decoders for each Spotify resource type, considering they won't
/// even be stored in the database.
public func decodeAndExtractFirstSpotifyImageURL<K: CodingKey>(from container: KeyedDecodingContainer<K>, forKey key: K) -> String {    
    if let images = try? container.decode([SpotifyImage].self, forKey: key),
              let firstImage = images.first {
        return firstImage.url
    } else {
        return "" // Default to empty string if no image is found
    }
}
