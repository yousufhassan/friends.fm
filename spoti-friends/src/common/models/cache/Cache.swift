import Foundation

/// A singleton class responsible for caching user and shared resource data in memory.
/// This class uses `NSCache` to store objects temporarily for efficient retrieval.
///
/// The following data is being cached:
///   - `receivedResources`
///   - `sentResources`
///
/// - Note: The `Cache` class is designed to store lightweight data that is safe to evict when memory pressure occurs.
///   It is not persistent storage and should not be relied upon for long-term data retention.
///
class Cache {
    static let shared = Cache()
    private init() {}
    
    // Cached items
    private let receivedResources = NSCache<NSString, NSArray>()
    private let sentResources = NSCache<NSString, NSArray>()
    
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
    
    /// Appends new sent `SharedResource` objects to the existing cache for a specific Spotify user.
    /// - Note: If no existing sent resources are cached, the method logs an error and performs no action.
    func appendToSentResources(spotifyId key: String, newResources: [SharedResource]) {
        if var resources = self.getSentResources(spotifyId: key) {
            resources.append(contentsOf: newResources)
            self.cacheSentResources(resources, spotifyId: key)
            printInfo("Added \(newResources.count) resources to cached sent resources")
        } else {
            printError("Could not append to cached sent resources.")
        }
    }
    
    /// Removes specific sent `SharedResource` objects from the cache for a specific Spotify user.
    /// - Note: If no existing sent resources are cached, the method logs an error and performs no action.
    func removeFromSentResources(spotifyId key: String, resourcesToRemove: [SharedResource]) {
        if var resources = self.getSentResources(spotifyId: key) {
            resources.removeAll { resource in
                resourcesToRemove.contains { $0.id == resource.id }
            }
            self.cacheSentResources(resources, spotifyId: key)
            printInfo("Removed \(resourcesToRemove.count) resources to cached sent resources")
        } else {
            printError("Could not remove from cached sent resources.")
        }
    }
}
