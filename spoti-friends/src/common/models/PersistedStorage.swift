import Foundation

/// A singleton class responsible for persisting data in memory.
///
/// The following data is being cached:
///   - `signedInUser`
///
class PersistedStorage {
    static let shared = PersistedStorage()
    private init() {}
    
    // Persisted items
    private var signedInUser: User? = nil
    
    /// Persists the signed in user.
    public func persistUser(_ user: User) {
        self.signedInUser = user
    }
    
    /// Returns the signed in user.
    public func getSignedInUser() -> User? {
        return self.signedInUser
    }
    
    /// Clears the persisted signed in user.
    public func clearPersistedUser() {
        self.signedInUser = nil
    }
}
