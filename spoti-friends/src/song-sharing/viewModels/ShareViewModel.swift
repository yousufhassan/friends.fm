import Foundation

class ShareViewModel: ObservableObject {
    @Published var user: User?
    
    init(user: User?) {
        self.user = user
    }
    
    enum SearchableResource: String, CaseIterable {
        case album
        case artist
        // case playlist  // TODO: Maybe add functionality in the future.
        case track
    }
    
    
    public func searchSpotify(for resourceTypes: [SearchableResource]? = nil, text: String) async -> [Track]? {
        do {
            guard let signedInUser = user else { throw AuthorizationError.missingUser }
            let accessToken = try await UserServiceManager.shared
                .getSpotifyWebAccessToken(forUser: signedInUser)
                .getAccessToken()
            
            // Stringify array elements for the API call.
            // If no types were specified, then search for all types (i.e. no filtering).
            let resourceTypesAsStrings = (resourceTypes ?? SearchableResource.allCases)
                .map { $0.rawValue }
                .joined(separator: ",")
            let queryParams = [
                URLQueryItem(name: "q", value: text),
                URLQueryItem(name: "type", value: resourceTypesAsStrings)
            ]
            let response = try await SpotifyAPI.shared.fetch(method: .GET,
                                                             endpoint: .search,
                                                             responseType: SearchResponse.self,
                                                             accessToken: accessToken,
                                                             queryParams: queryParams)
            
            printInfo("Searching Spotify for query: \(text), types: [\(resourceTypesAsStrings)]")
            return response.tracks.items
            
        } catch {
            printError("When performing Spotify search: \(error)")
            return nil
        }
    }
    
    public func fetchNextSearchResults () {
        printInfo("Fetching more results")
    }
}
