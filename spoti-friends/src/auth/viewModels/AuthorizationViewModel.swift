import Foundation
import SwiftUI
//import RealmSwift
import WebKit

/// The viewmodel used for the views involving the authorization code flow.
class AuthorizationViewModel: ObservableObject {
    @Published var user: AppwriteUser?
    @Published var spDcCookie: AppwriteSpDcCookie?
    @Published var authorizationStatus: AppwriteAuthorizationStatus = .unauthenticated
    @Published var isFetchingUser = true
    
    init() {}
    
    /// Asynchronously fetches the signed-in user from the database and updates the state.
    ///
    /// This method retrieves the signed-in user's Spotify ID from UserDefaults and
    /// attempts to fetch the corresponding user from the database. If a user is found,
    /// it updates the `user` and `authorizationStatus` properties accordingly.
    ///
    /// - Note: The method updates the properties on the main thread to ensure UI consistency.
    func fetchAndUpdateUser() async {
        do {
            let signedInUserId = getStringFromUserDefaultsValueForKey("signedInUserId")
            let existingUser =  try await UserServiceManager.shared.getUserFromDB(withSpotifyId: signedInUserId)
            
            // TODO: Test what happens when I remove the `main.async` code. Can I remove it?
            DispatchQueue.main.async {
                self.user = existingUser
                self.authorizationStatus = existingUser?.authorizationStatus ?? .unauthenticated
                self.isFetchingUser = false
            }
        } catch {
            self.user = nil
            self.authorizationStatus = .error
            self.isFetchingUser = false
        }
    }
    
    
    /// Signs out the currently signed in user.
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
        self.authorizationStatus = .unauthenticated
    }
    
    /// Returns the Spotify user authorization URL.
    public func getUserAuthorizationUrl() -> URL {
        return SpotifyAuth.shared.constructAuthorizationUrl()!
    }
    
    /// Handler for when the user has completed the Spotify authorization process and is redirected back to the app.
    public func handleRedirectBackToApp(_ responseUrl: URL) async -> Void {
        Task {
            self.authorizationStatus = await SpotifyAuth.shared
                .handleResponseUrl(url: responseUrl, user: &self.user, spDcCookie: self.spDcCookie)
        }
    }
    
    /// Handles the fetched `sp_dc` cookie.
    ///
    /// This method converts the provided `HTTPCookie` into an `AppwriteSpDcCookie` and stores it in the ViewModel.
    ///
    /// - Parameter cookie: An optional `HTTPCookie` that contains the `sp_dc` value.
    /// - Throws: `AuthorizationError.cannotConvertSpDcCookie` if the conversion fails.
    public func handleFetchedSpDcCookie(_ cookie: HTTPCookie?) -> Void {
        do {
            let spDcCookie = try convertToSpDcCookie(cookie)
            self.spDcCookie = spDcCookie
        } catch {
            printError("Error when trying to handle fetching of the sp_dc cookie.")
        }
    }
    
    /// Converts an optional `HTTPCookie` to an `AppwriteSpDcCookie`.
    ///
    /// This function extracts the value and expiration date from the provided cookie,
    /// throwing an error if the cookie is nil or if either the value or expiration date
    /// cannot be obtained.
    ///
    /// - Parameter cookie: An optional `HTTPCookie` to convert.
    /// - Throws: `AuthorizationError.cannotGetSpdcCookie` if the cookie is nil,
    ///           or if the value or expiration date cannot be retrieved.
    /// - Returns: An `AppwriteSpDcCookie` object containing the extracted value and expiration date.
    private func convertToSpDcCookie(_ cookie: HTTPCookie?) throws -> AppwriteSpDcCookie {
        guard let value = cookie?.value, let expiresDate = cookie?.expiresDate else {
            throw AuthorizationError.cannotConvertSpDcCookie
        }
        return AppwriteSpDcCookie(value: value, expiresDate: expiresDate)
    }
}
