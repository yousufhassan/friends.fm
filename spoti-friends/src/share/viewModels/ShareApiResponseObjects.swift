import Foundation

/// Contains the structs relevant to the ShareViewModel.
///
/// Add the response objects for the relevant API endpoints. Only add fields we are interested in.
extension ShareViewModel {
    /// Response object for the `/search` API endpoint.
    ///
    /// Currently, it only supports getting tracks from the response, but it can be extended in the future to support
    /// artists, albums, etc.
    internal struct SearchResponse: Decodable {
        let tracks: TracksResponse
        
        struct TracksResponse: Decodable {
            let href: String
            let limit: Int
            let next: String?
            let offset: Int
            let previous: String?
            let total: Int
            let items: [Track]
        }
    }
}
