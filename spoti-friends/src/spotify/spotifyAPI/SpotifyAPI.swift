import Foundation

/// Singleton class for interacting with the Spotify Web API.
class SpotifyAPI {
    static let shared: SpotifyAPI = SpotifyAPI()
    
    /// A function that abstracts the Spotify API calls and returns the response data to the calling function.
    ///
    /// - Parameters:
    ///   - endpoint: The Spotify Web API endpoint to fetch data from.
    ///   - responseType: The type the response data should conform to.
    ///   - accessToken: The Spotify Web Access Token string.
    ///
    /// - Returns: The response data from the `endpoint` in the form of `responseType`.
    public func fetch<T: Decodable>(endpoint: APIEndpoint, responseType: T.Type, accessToken: String) async throws -> T {
        let request = try createRequestTo(endpoint: endpoint.rawValue, accessToken: accessToken, method: RequestMethod.GET)
        let (data, response) = try await URLSession.shared.data(for: request)
        if (requestFailed(response as! HTTPURLResponse)) { try throwSpotifyAPIError(response as! HTTPURLResponse) }
        let decodedResponse = try JSONDecoder().decode(T.self, from: data)
        return decodedResponse
    }
    
    /// Returns a list of the user's friends as `SpotifyProfile`s.
    ///
    /// - Parameters:
    ///   - internalAPIAccessToken: Access token for the internal Spotify API.
    public func getListOfUsersFriends(internalAPIAccessToken: String) async throws -> [SpotifyProfile] {
        let data = try await fetchBuddylistEndpoint(internalAPIAccessToken: internalAPIAccessToken)
        let friends = try convertDataToFriendList(data)
        return friends
    }
    
    /// Fetches and returns the data from the `/buddylist` internal API endpoint.
    ///
    /// - Parameters:
    ///   - internalAPIAccessToken: Access token for the internal Spotify API.
    private func fetchBuddylistEndpoint(internalAPIAccessToken: String) async throws -> Data {
        guard let endpointURL = URL(string: "https://spclient.wg.spotify.com/presence-view/v1/buddylist") else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: endpointURL)
        request.setValue("Bearer \(internalAPIAccessToken)", forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for: request)
        if (requestFailed(response as! HTTPURLResponse)) { throw SpotifyAPIError.unsuccessfulRequest }
        return data
    }
}


extension SpotifyAPI {
    /// Creates and returns the URLRequest object to corresponding Spotify API `endpoint`
    ///
    /// `endpoint` should be prepended with a "/".
    private func createRequestTo(endpoint: String, accessToken: String, method: String) throws -> URLRequest {
        guard let url = URL(string: APIConstants.host + endpoint) else { throw URLError(.badURL)}
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    /// Returns `true` if the response status code is not in the 200s and `false` otherwise.
    private func requestFailed(_ response: HTTPURLResponse) -> Bool {
        return !(200...299).contains(response.statusCode)
    }
    
}


/// Different types of request methods that the Spotify API supports.
enum RequestMethod {
    static let GET = "GET"
    static let POST = "POST"
    static let PUT = "PUT"
    static let DELETE = "DELETE"
}
