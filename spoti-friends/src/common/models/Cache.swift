import Foundation

class Cache {
    static let shared = Cache()
    private init() {}
    
    // Cached items
    private let receivedResources = NSCache<NSString, NSArray>()
    private let sentResources = NSCache<NSString, NSArray>()
    
    /// Caches an array of received `SharedResource` objects.
    func cacheReceivedResources(_ resources: [SharedResource], forKey key: String) {
        receivedResources.setObject(resources as NSArray, forKey: key as NSString)
    }

    /// Retrieves the cached array of received `SharedResource` objects.
    func getCachedReceivedResources(forKey key: String) -> [SharedResource]? {
        return receivedResources.object(forKey: key as NSString) as? [SharedResource]
    }
    
    /// Caches an array of sent `SharedResource` objects.
    func cacheSentResources(_ resources: [SharedResource], forKey key: String) {
        sentResources.setObject(resources as NSArray, forKey: key as NSString)
    }

    /// Retrieves the cached array of sent `SharedResource` objects.
    func getCachedSentResources(forKey key: String) -> [SharedResource]? {
        return sentResources.object(forKey: key as NSString) as? [SharedResource]
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
