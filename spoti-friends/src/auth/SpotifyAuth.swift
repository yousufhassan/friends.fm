import Foundation
import CryptoKit
import RealmSwift

/// Class that handles the Spotify Authorization Singleton.
class SpotifyAuth {
    /// Shared instance of the SpotifyAuth Singleton class.
    static let shared = SpotifyAuth()
    
    /// Constructs the authorization URL that is used to get user authorization.
    func constructAuthorizationUrl() -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = AuthorizationConstants.host
        components.path = AuthorizationConstants.AuthorizationRequest.authorizePath
        
        var params = AuthorizationConstants.authorizationRequestParams
        let codeChallenge = CodeChallenge.shared.generateCodeChallenge()
        params["code_challenge"] = codeChallenge
        components.queryItems = params.map({URLQueryItem(name: $0.key, value: $0.value)})
        
        guard let url = components.url else { return nil }
        return url
    }
    
    /// Handles the response from the Spotify authorization flow depending on whether the user granted authorization or denied authorization.
    func handleResponseUrl(user: User, url: URL, authorizationStatus: inout AuthorizationStatus) async -> Void {
        do {
            guard let responseUrlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
                  let queryItems = responseUrlComponents.queryItems
            else { throw URLError(.badURL) }
            
            if (user.isEmpty()) {
                await populateUserWithData(user, queryItems: queryItems);
            }
            
            if (await userExistsInDatabase(user)) {
                storeSignedInUser(user)
                authorizationStatus = .granted
            } else {
                if (userGrantedAuthorization(queryItems)) {
                    user.setAuthorizationStatusAs(.granted)
                    await user.spotifyProfile?.storeProfilePictureLocally()
                    storeSignedInUser(user)
                    await RealmDatabase.shared.addToRealm(object: user);
                    authorizationStatus = .granted
                }
                else {
                    // Handle authorization denied flow
                    authorizationStatus = .denied
                }
            }
        } catch {
            printError("\(error)")
        }
    }
    
    /// Populates the `user` fields with their data.
    private func populateUserWithData(_ user: User, queryItems: [URLQueryItem]) async -> Void {
        do {
            let authorizationCode = try getAuthorizationCodeFromQueryItems(queryItems)
            user.setAuthorizationCode(authorizationCode)
            
            let spotifyWebAccessToken = try await requestAccessTokenObject(authorizationCode: authorizationCode)
            user.setSpotifyWebAccessToken(spotifyWebAccessToken!)
            
            let internalAPIAccessToken = try await fetchInternalAPIAccessToken(spDcCookieValue: user.spDcCookie!.value, existingToken: user.internalAPIAccessToken)
            user.setInternalAPIAccessToken(internalAPIAccessToken)
            
            let spotifyProfile: SpotifyProfile = try await SpotifyAPI.shared.fetch(endpoint: .getCurrentUsersProfile,
                                                                                   responseType: SpotifyProfile.self,
                                                                                   accessToken: spotifyWebAccessToken?.access_token ?? "")
            user.setSpotifyProfile(spotifyProfile)
            user.setSpotifyId(spotifyProfile.spotifyId)
            
            let friends = try await SpotifyAPI.shared.getListOfUsersFriends(internalAPIAccessToken: internalAPIAccessToken.accessToken)
            user.setFriends(friends)
        } catch {
            printError("\(error)")
        }
    }
    
    /// Returns `true` if the `user` already exists in the database and `false` otherwise.
    private func userExistsInDatabase(_ user: User) async -> Bool {
        var userExists: Bool = false
        DispatchQueue.main.sync {
            let realm = RealmDatabase.shared.getRealmInstance()
            userExists = realm.objects(User.self).where { $0.spotifyId == user.spotifyId }.count != 0
        }
        
        return userExists
    }
    
    /// Stores the user as the signed in user in `UserDefaults`.
    private func storeSignedInUser(_ user: User) -> Void {
        storeInUserDefaults(key: "signedInUser", value: user.spotifyId)
    }
    
    /// Returns `true` if user granted authorization to the application and response included the "code" value; `false`, otherwise.
    private func userGrantedAuthorization(_ queryItems: [URLQueryItem]) -> Bool {
        return queryItems.contains(where: {$0.name == "code"})
    }
    
    /// Parses the `queryItems` and returns the authorization code.
    private func getAuthorizationCodeFromQueryItems(_ queryItems: [URLQueryItem]) throws -> String {
        guard let code = queryItems.first(where: { $0.name == "code" })?.value else { throw AuthorizationError.cannotExtractCode }
        return code
    }
    
    /// Constructs and returns the URLComponents object to request a Spotify API access token.
    private func constructAccessTokenUrlRequest(authorizationCode: String) throws -> URLRequest {
        // Construct URL Components
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = AuthorizationConstants.host
        urlComponents.path = AuthorizationConstants.AccessToken.apiTokenPath
        
        var params = AuthorizationConstants.accessTokenRequestParams
        params["code"] = authorizationCode
        urlComponents.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = urlComponents.url else { throw URLError(.badURL) }
        
        // Construct URL Request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = urlComponents.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        return request
        
    }
    
    /// Requests and returns a Spotify Web Access Ttoken object.
    private func requestAccessTokenObject(authorizationCode: String) async throws -> SpotifyWebAccessToken? {
        do {
            let request = try constructAccessTokenUrlRequest(authorizationCode: authorizationCode)
            let (data, _) = try await URLSession.shared.data(for: request)
            let accessToken = try JSONDecoder().decode(SpotifyWebAccessToken.self, from: data)
            return accessToken
        } catch {
            printError("\(error)")
            throw error
        }
        
    }
    
    /// Constructs and returns the `URLRequest` for refreshing a Spotify Web API Access Token.
    private func constructRefreshAccessTokenRequest(refreshToken: String) throws -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = AuthorizationConstants.host
        urlComponents.path = AuthorizationConstants.AccessToken.apiTokenPath
        
        var params = AuthorizationConstants.refreshTokenRequestParams
        params["refresh_token"] = refreshToken
        urlComponents.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = urlComponents.url else { throw URLError(.badURL) }
        
        // Construct URL Request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = urlComponents.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    /// Requests abd returns a refreshed Spotify Web Access Token object.
    ///
    /// - Parameters:
    ///   - refreshToken: The refresh token returned from the authoriztion token request.
    ///
    /// - Returns: A new `SpotifyWebAccessToken`.
    public func refreshAccessToken(refreshToken: String) async throws -> SpotifyWebAccessToken {
        do {
            let request = try constructRefreshAccessTokenRequest(refreshToken: refreshToken)
            let (data, _) = try await URLSession.shared.data(for: request)
            let accessToken = try JSONDecoder().decode(SpotifyWebAccessToken.self, from: data)
            return accessToken
        } catch {
            printError("\(error)")
            throw error
        }
    }
    
    /// Fetches and returns the Spotify Web Player Access Token needed for calling the `/buddylist` internal API endpoint.
    /// This is different than the Access Token for the Web API.
    ///
    /// - Parameters:
    ///   - spDcCookieValue: The user's `sp_dc` cookie value.
    ///   - existingToken: An optional token if it already exists.
    ///
    /// - Returns: The **internal** Spotify Web Player Access Token .
    @MainActor public func fetchInternalAPIAccessToken(spDcCookieValue: String, existingToken: InternalAPIAccessToken?) async throws -> InternalAPIAccessToken {
        // If there as an existing token that is still valid, return that. Otherwise return a new token.
        if existingToken != nil && !accessTokenIsExpired(existingToken!.accessTokenExpirationTimestampMs) {
            return existingToken!
        }
        
        guard let endpointURL = URL(string: "https://open.spotify.com/get_access_token?reason=transport&productType=web_player") else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: endpointURL)
        request.setValue("sp_dc=\(spDcCookieValue)", forHTTPHeaderField: "Cookie")
        let (data, _) = try await URLSession.shared.data(for: request)
        let internalAPIAccessToken = try JSONDecoder().decode(InternalAPIAccessToken.self, from: data)
        return internalAPIAccessToken
    }
    
    /// Returns `true` if the access token is expired; false otherwise.
    ///
    /// - Parameters:
    ///   - expiry: When the token expires.
    ///
    ///   - Returns: If the access token is expired or not.
    public func accessTokenIsExpired(_ expiry: Double) -> Bool {
        let expiryInSeconds = expiry / 1000
        if Date() >= Date(timeIntervalSince1970: expiryInSeconds) {
            return true
        }
        
        return false
    }
}
