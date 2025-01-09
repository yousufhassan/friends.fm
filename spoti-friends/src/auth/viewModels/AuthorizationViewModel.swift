import Foundation
import SwiftUI
import WebKit

/// The viewmodel used for the views involving the authorization code flow.
class AuthorizationViewModel: ObservableObject {
    @Published var user: User?
    @Published var spDcCookie: SpDcCookie?
    @Published var authorizationStatus: AuthorizationStatus = .unauthenticated
    @Published var isFetchingUser = true
    @Published var isReauthenticationRequired = false
    
    init() {}
    
    /// Checks whether or not there is a signed in user stored in the UserDefaults cache.
    /// - Returns: True if there is a user signed in, false otherwise.
    public func isThereASignedInUserInCache() -> Bool {
        return getStringFromUserDefaultsValueForKey("signedInUserId") != ""
    }
    
    /// Returns the signed in user stored in the UserDefaults cache, or `nil` if none were found.
    public func getSignedInUserIdFromCache() -> String? {
        if (!isThereASignedInUserInCache()) {
            return nil
        }
        
        return getStringFromUserDefaultsValueForKey("signedInUserId")
    }
    
    /// Asynchronously fetches the signed-in user from the database and updates the state. If none were found, sets the user as `nil`
    /// and the authorization status as `unauthenticated`.
    @MainActor public func fetchAndUpdateUser() async {
        do {
            guard let signedInUserId = getSignedInUserIdFromCache() else {
                self.isFetchingUser = false
                return
            }
            
            let existingUser = try await UserServiceManager.shared.getUserFromDB(withSpotifyId: signedInUserId)
            self.user = existingUser
            self.authorizationStatus = existingUser.getAuthorizationStatus()
            self.isFetchingUser = false
            self.isReauthenticationRequired = self.isReauthenticationRequired(for: existingUser)
        } catch {
            self.user = nil
            self.authorizationStatus = .error
            self.isFetchingUser = false
        }
    }
    
    
    /// Signs out the currently signed in user.
    @MainActor
    public func signOutUser() -> Void {
        // Clear cookies of Spotify sign in WebKit View (so it forgets previous user's)
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                dataStore.removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
        
        storeInUserDefaults(key: "signedInUserId", value: "")
        storeInUserDefaults(key: "code_verifier", value: "")
        self.user = nil
        self.isReauthenticationRequired = false
        self.authorizationStatus = .unauthenticated
    }
    
    /// Returns a boolean denoting whether or not the user needs to reauthenticate.
    ///
    /// - Parameter user: The user that may need to reauthenticate.
    ///
    /// This is required when the user needs to accept new Spotify app scopes.
    private func isReauthenticationRequired(for user: User?) -> Bool {
        guard let signedInUser = user else { return false }
        
        let appScopesString = AuthorizationConstants.AuthorizationRequest.scopes
        let appScopes: [String] = appScopesString.split(separator: " ").map { String($0) }
        let userScopes: [String] = signedInUser.getSpotifyWebAccessToken().getScopesArray()
        return !Set(appScopes).isSubset(of: Set(userScopes))
    }
    
    /// Returns the Spotify user authorization URL.
    public func getUserAuthorizationUrl() -> URL {
        return SpotifyAuth.shared.constructAuthorizationUrl()!
    }
    
    /// Handler for when the user has completed the Spotify authorization process and is redirected back to the app.
    @MainActor
    public func handleRedirectBackToApp(_ responseUrl: URL) async -> Void {
        Task {
            self.authorizationStatus = await SpotifyAuth.shared
                .handleResponseUrl(url: responseUrl, user: &self.user, spDcCookie: self.spDcCookie)
        }
    }
    
    /// Handles the fetched `sp_dc` cookie.
    ///
    /// This method converts the provided `HTTPCookie` into an `SpDcCookie` and stores it in the ViewModel.
    ///
    /// - Parameter cookie: An optional `HTTPCookie` that contains the `sp_dc` value.
    /// - Throws: `AuthorizationError.cannotConvertSpDcCookie` if the conversion fails.
    @MainActor
    public func handleFetchedSpDcCookie(_ cookie: HTTPCookie?) -> Void {
        do {
            let spDcCookie = try convertToSpDcCookie(cookie)
            self.spDcCookie = spDcCookie
        } catch {
            printError("Error when trying to handle fetching of the sp_dc cookie.")
        }
    }
    
    /// Converts an optional `HTTPCookie` to an `SpDcCookie`.
    ///
    /// This function extracts the value and expiration date from the provided cookie,
    /// throwing an error if the cookie is nil or if either the value or expiration date
    /// cannot be obtained.
    ///
    /// - Parameter cookie: An optional `HTTPCookie` to convert.
    /// - Throws: `AuthorizationError.cannotGetSpdcCookie` if the cookie is nil,
    ///           or if the value or expiration date cannot be retrieved.
    /// - Returns: An `SpDcCookie` object containing the extracted value and expiration date.
    private func convertToSpDcCookie(_ cookie: HTTPCookie?) throws -> SpDcCookie {
        guard let value = cookie?.value, let expiresDate = cookie?.expiresDate else {
            throw AuthorizationError.cannotConvertToSpDcCookie
        }
        return SpDcCookie(value: value, expiresDate: expiresDate)
    }
}
