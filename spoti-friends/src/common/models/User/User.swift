import Foundation
import RealmSwift

/// Class representing a User of the application.
class User: Object {
    @Persisted(primaryKey: true) var spotifyId: String
    @Persisted var spotifyProfile: SpotifyProfile?
    @Persisted var friends: List<SpotifyProfile>
    @Persisted var authorizationCode: String?
    @Persisted var spotifyWebAccessToken: SpotifyWebAccessToken?
    @Persisted var internalAPIAccessToken: InternalAPIAccessToken?
    @Persisted var authorizationStatus: AuthorizationStatus
    @Persisted var spDcCookie: SpDcCookie?
    
    override init() {
        super.init()
        self.spotifyId = ""
        self.spotifyProfile = nil
        self.friends = List()
        self.authorizationCode = nil
        self.spotifyWebAccessToken = nil
        self.internalAPIAccessToken = nil
        self.authorizationStatus = .unauthenticated
        self.spDcCookie = nil
    }
    
    /// Returns `true` if the user object is not set and is empty, `false` otherwise.
    public func isEmpty() -> Bool {
        return self.spotifyId == ""
    }
    
    /// Returns `true` if the `User` exists in the database and `false` otherwise.
    public func existsInDatabase() -> Bool {
        let realm = RealmDatabase.shared.getRealmInstance()
        if realm.object(ofType: User.self, forPrimaryKey: self.spotifyId) == nil {
            return false
        }
        return true
    }
    
    /// Sets the user's `spotifyId` to their Spotify Account ID.
    public func setSpotifyId(_ spotifyId: String) -> Void {
        self.spotifyId = spotifyId
    }
    
    /// Sets the user's `spotifyProfile`.
    public func setSpotifyProfile(_ spotifyProfile: SpotifyProfile) -> Void {
        self.spotifyProfile = spotifyProfile
    }
    
    /// Sets the user's `friends`.
    public func setFriends(_ friendsAsSpotifyProfiles: [SpotifyProfile]) -> Void {
        let friends = List<SpotifyProfile>()
        friends.append(objectsIn: friendsAsSpotifyProfiles)
        self.friends = friends
    }
    
    /// Adds `friend` as a friend for the user.
    public func addFriend(_ friend: SpotifyProfile) -> Void {
        let realm = RealmDatabase.shared.getRealmInstance()
        try! realm.write {
            self.friends.append(friend)
        }
    }
    
    /// Sets the user's `authorizationCode`.
    public func setAuthorizationCode(_ code: String) -> Void {
        self.authorizationCode = code
    }
    
    /// Gets the user's `spotifyWebAccessToken`.
    @MainActor public func getSpotifyWebAccessToken() async throws -> SpotifyWebAccessToken {
        do {
            // If the token is not expired
            if !SpotifyAuth.shared.accessTokenIsExpired(self.spotifyWebAccessToken!.accessTokenExpirationTimestampMs) {
                return self.spotifyWebAccessToken!
            }
            
            // Otherwise, refresh token, save to database, and return
            let token = try await SpotifyAuth.shared.refreshAccessToken(refreshToken: self.spotifyWebAccessToken!.refresh_token)
            RealmDatabase.shared.updateObjectInRealm {
                self.setSpotifyWebAccessToken(token)
            }
            
            return token
        } catch {
            printError("\(error)")
            throw error
        }
    }
    
    /// Sets the user's `spotifyWebAccessToken`.
    public func setSpotifyWebAccessToken(_ spotifyWebAccessToken: SpotifyWebAccessToken) -> Void {
        self.spotifyWebAccessToken = spotifyWebAccessToken
        self.spotifyWebAccessToken?.setExpiryTimestamp()
    }
    
    /// Sets the user's `internalAPIAccessToken`.
    public func setInternalAPIAccessToken(_ internalAPIAccessToken: InternalAPIAccessToken) -> Void {
        self.internalAPIAccessToken = internalAPIAccessToken
    }
    
    /// Gets the user's `internalAPIAccessToken`.
    @MainActor public func getInternalAPIAccessToken() async throws -> InternalAPIAccessToken {
        do {
            guard let cookie: String = self.spDcCookie?.value else { throw AppError(.valueNotFound) }
            let token = try await SpotifyAuth.shared.fetchInternalAPIAccessToken(spDcCookieValue: cookie, existingToken: self.internalAPIAccessToken)
            
            // Store the new token since the existing one expired
            if token != self.internalAPIAccessToken {
                RealmDatabase.shared.updateObjectInRealm {
                    self.setInternalAPIAccessToken(token)
                }
            }
            
            return token
        } catch {
            printError("\(error)")
            throw error
        }
    }
    
    /// Sets the user's `authorizationStatus` as `status`.
    public func setAuthorizationStatusAs(_ status: AuthorizationStatus) -> Void {
        self.authorizationStatus = status
    }
    
//    public func getSpDcCookie() -> SpDcCookie {
//        let realm = RealmDatabase.shared.getRealmInstance()
//        let user = realm.obje
//    }
    
    /// Sets the spDcCookie.
    public func setSpDcCookie(_ cookie: SpDcCookie) {
        let realm = try! Realm()
        try! realm.write {
            self.spDcCookie = cookie
        }
    }
    
    // List of methods to implement when the time comes
    //    getSpotifyProfile()
    //
    //    getFriendList()
    //    setFriendList()
    //
    //    isSpDcValid()
    //    setSpDcAsValid()
    //    setSpDcAsExpired()
}


/// The user's status for granting the application authorization.
///
/// `unauthenticated` when the user has not granted nor denied authorization and will need to make a choice.
///
/// `granted` when the user has granted authorization and can use the application normally.
///
/// `denied` when the user has denied authorization and will not be able to use the application.
enum AuthorizationStatus: String, PersistableEnum {
    /// The user has not granted nor denied authorization and will need to make a choice.
    case unauthenticated
    /// The user has granted authorization and can use the application normally.
    case granted
    /// The user has denied authorization and will not be able to use the application.
    case denied
}

