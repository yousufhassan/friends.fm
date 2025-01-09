import Foundation

class PersistedStorage {
    static let shared = PersistedStorage()
    private init() {}
    
    // Persisted items
    private var signedInUser: User? = nil
    
    public func persistUser(_ user: User) {
        self.signedInUser = user
    }
    
    public func getSignedInUser() -> User? {
        return self.signedInUser
    }
}
