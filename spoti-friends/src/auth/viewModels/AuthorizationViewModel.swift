import Foundation
import SwiftUI
import RealmSwift
import WebKit

/// The viewmodel used for the views involving the authorization code flow.
class AuthorizationViewModel: ObservableObject {
    @Published var user: User
    @Published var authorizationStatus: AuthorizationStatus
    private var notificationToken: NotificationToken?
    
    init() {
        let realm = RealmDatabase.shared.getRealmInstance()
        
        // If we find a matching user in the database, set that as current user.
        // Otherwise, this is a new user.
        let signedInUser = getStringFromUserDefaultsValueForKey("signedInUser")
        let existingUser: User? = realm.objects(User.self).where { $0.spotifyId == signedInUser }.first
        self.user = existingUser ?? User()
        self.authorizationStatus = existingUser?.authorizationStatus ?? .unauthenticated
        
        self.notificationToken = realm.observe { [weak self] _, _ in
            self?.objectWillChange.send()
        }
    }
    
    deinit {
        notificationToken?.invalidate()
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
        
        storeInUserDefaults(key: "signedInUser", value: "")
        storeInUserDefaults(key: "code_verifier", value: "")
        self.user = User()
        self.authorizationStatus = .unauthenticated
    }
    
    /// Returns the Spotify user authorization URL.
    public func getUserAuthorizationUrl() -> URL {
        return SpotifyAuth.shared.constructAuthorizationUrl()!
    }
    
    /// Handler for when the user has completed the Spotify authorization process and is redirected back to the app.
    public func handleRedirectBackToApp(_ responseUrl: URL) -> Void {
        Task {
            self.authorizationStatus = await SpotifyAuth.shared.handleResponseUrl(user: self.user, url: responseUrl)
        }
    }
    
    /// Handler for when the `sp_dc` cookie is fetched. It stores the cookie value in the user object, but does not save to database yet.
    public func handleFetchedSpDcCookie(_ cookie: HTTPCookie?) -> Void {
        let spDcCookie = convertToSpDcCookie(cookie)
        self.user.spDcCookie = spDcCookie
    }
    
    /// Converts the cookie from Spotify from type `HTTPCookie` to `SpDcCookie`.'
    private func convertToSpDcCookie(_ cookie: HTTPCookie?) -> SpDcCookie {
        let spDcCookie = SpDcCookie()
        spDcCookie.value = cookie?.value ?? ""
        spDcCookie.expiresDate = cookie?.expiresDate
        return spDcCookie
    }
}
