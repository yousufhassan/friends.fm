import Foundation

class Cache {
    static let shared = Cache()
    private init() {}
    
    // Cached items
    private let signedInUser = NSCache<NSString, User>()
    private let signedInUserKey: NSString = "signedInUser"
    
    private let receivedResources = NSCache<NSString, NSArray>()
    private let sentResources = NSCache<NSString, NSArray>()
    
    func cacheUser(_ user: User) {
        signedInUser.setObject(user, forKey: signedInUserKey)
    }
    
    func getSignedInUser() -> User? {
        return self.signedInUser.object(forKey: signedInUserKey)
    }
    
    /// Caches an array of received `SharedResource` objects.
    func cacheReceivedResources(_ resources: [SharedResource], spotifyId key: String) {
        self.receivedResources.setObject(resources as NSArray, forKey: key as NSString)
    }

    /// Retrieves the cached array of received `SharedResource` objects.
    func getReceivedResources(spotifyId key: String) -> [SharedResource]? {
        return self.receivedResources.object(forKey: key as NSString) as? [SharedResource]
    }
    
    /// Caches an array of sent `SharedResource` objects.
    func cacheSentResources(_ resources: [SharedResource], spotifyId key: String) {
        self.sentResources.setObject(resources as NSArray, forKey: key as NSString)
    }

    /// Retrieves the cached array of sent `SharedResource` objects.
    func getSentResources(spotifyId key: String) -> [SharedResource]? {
        return self.sentResources.object(forKey: key as NSString) as? [SharedResource]
    }
    
    func appendToSentResources(spotifyId key: String, newResources: [SharedResource]) {
        if var resources = self.getSentResources(spotifyId: key) {
            resources.append(contentsOf: newResources)
            self.cacheSentResources(resources, spotifyId: key)
        } else {
            printError("Could not append to cached sent resources.")
        }
    }
//
//    /// Clears a specific cached array.
//    func clearCache(forKey key: String) {
//        sentResources.removeObject(forKey: key as NSString)
//    }
//
//    /// Clears all cached arrays.
//    func clearAllCache() {
//        sentResources.removeAllObjects()
//    }
    
}
