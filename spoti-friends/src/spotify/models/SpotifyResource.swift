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
public func decodeAndExtractFirstSpotifyImageURL<K: CodingKey>(from container: KeyedDecodingContainer<K>, forKey key: K) -> String {
    if let images = try? container.decode([SpotifyImage].self, forKey: key) {
        return images.first?.url ?? ""
    } else {
        return ""
    }
}
