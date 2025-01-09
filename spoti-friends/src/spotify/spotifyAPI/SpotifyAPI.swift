import Foundation

/// Singleton class for interacting with the Spotify Web API.
class SpotifyAPI {
    static let shared: SpotifyAPI = SpotifyAPI()
    
    /// The response object from Spotify containing response data and a URL response (status codes and such).
    public struct Response<T: Decodable> {
        let data: T
        let response: HTTPURLResponse
        
        init(data: T, response: HTTPURLResponse) {
            self.data = data
            self.response = response
        }
    }
    
    /// A struct for when the Spotify API call does not return data as part of its response.
    public struct VoidResponse: Decodable {}
    
    /// A function that abstracts the Spotify API calls and returns the response data to the calling function.
    ///
    /// - Parameters:
    ///   - method: The HTTP method to use for this request.
    ///   - endpoint: The Spotify Web API endpoint to fetch data from.
    ///   - responseType: The type the response data should conform to.
    ///   - accessToken: The Spotify Web Access Token string.
    ///   - queryParams: An optional array of query parmeters to add to the URL request.
    ///   - pathParams: An optional array of URL path parameters to add to the URL request.
    ///
    /// - Returns: The response data from the `endpoint` in the form of `responseType`.
    public func fetch<T: Decodable>(method: RequestMethod, endpoint: APIEndpoint, responseType: T.Type,
                                    accessToken: String, queryParams: [URLQueryItem] = [],
                                    pathParams: [String:String] = [:]) async throws -> Response<T> {
        let request = try createRequestTo(endpoint: endpoint, accessToken: accessToken,
                                          method: method, queryParams: queryParams, pathParams: pathParams)
        let (data, response) = try await URLSession.shared.data(for: request)
        let httpResponse = response as! HTTPURLResponse
        if (requestFailed(httpResponse)) { throw try throwSpotifyAPIError(httpResponse) }
        
        let decodedData = isSuccesssfulAddToQueueResponse(endpoint: endpoint, response: httpResponse)
        ? VoidResponse() as! T
        : try JSONDecoder().decode(T.self, from: data)
//        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return Response(data: decodedData, response: httpResponse)
    }
    
    public func fetchNextResults<T: Decodable>(url urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        let request = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        if (requestFailed(response as! HTTPURLResponse)) { throw try throwSpotifyAPIError(response as! HTTPURLResponse) }
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
        if (requestFailed(response as! HTTPURLResponse)) { throw try throwSpotifyAPIError(response as! HTTPURLResponse) }
        return data
    }
    
    /// Returns a boolean on whether the API call was to the `addToQueue` endpoint and it was successful.
    ///
    /// Unfortunately, this is needed because Spotify does not return any meaningful data in a successful `addToQueue` response.
    /// We aren't able to decode the response data, and therefore need this workaround to check if the response was successful.
    ///
    /// - Parameters:
    ///   - endpoint: The Spotify Web API endpoint to fetch data from.
    ///   - response: The HTTP Response returned from the Spotify API call.
    private func isSuccesssfulAddToQueueResponse(endpoint: APIEndpoint, response: HTTPURLResponse) -> Bool {
        return endpoint == .addItemToQueue && self.requestSucceeded(response)
    }
}


extension SpotifyAPI {
    /// Creates and returns the URLRequest object to corresponding Spotify API `endpoint`
    ///
    /// `endpoint` should be prepended with a "/".
    private func createRequestTo(endpoint: APIEndpoint, accessToken: String, method: RequestMethod,
                                 queryParams: [URLQueryItem], pathParams: [String:String]) throws -> URLRequest {
        var endpointPath = endpoint.rawValue
        
        // Add path parameters to the URL, if any
        if (!pathParams.isEmpty) {
            for (paramName, paramValue) in pathParams {
                // Replace placeholders in the format {paramName} with the corresponding paramValue
                endpointPath = endpointPath.replacingOccurrences(of: "{\(paramName)}", with: paramValue)
            }
        }
        
        guard var urlComponents = URLComponents(string: APIConstants.host + endpointPath) else { throw URLError(.badURL) }

        // Add query parameters to the URL, if any
        if (!queryParams.isEmpty) {
            urlComponents.queryItems = queryParams
        }
        
        guard let url = urlComponents.url else { throw URLError(.badURL) }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    /// Returns `true` if the response status code is in the 200s and `false` otherwise.
    private func requestSucceeded(_ response: HTTPURLResponse) -> Bool {
        return (200...299).contains(response.statusCode)
    }
    
    /// Returns `true` if the response status code is not in the 200s and `false` otherwise.
    private func requestFailed(_ response: HTTPURLResponse) -> Bool {
        return !self.requestSucceeded(response)
    }
    
}


/// Different types of request methods that the Spotify API supports.
enum RequestMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}
