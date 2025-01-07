import Foundation

/// A representation of a resource shared between Spotify users.
///
/// The `SharedResource` class encapsulates information about a Spotify resource (track, artist, or album)
/// shared between a sender and a receiver. It includes details such as the resource's type, IDs,
/// sender and receiver profiles, timestamp of sharing, and whether the resource has been marked as listened.
///
/// ### Properties:
/// - `id`: A unique identifier for the shared resource.
/// - `resource`: The shared `SpotifyResource` object (optional, initialized later when fetched from Spotify).
/// - `resourceId`: The Spotify ID of the resource.
/// - `type`: The type of resource (e.g., track, artist, album).
/// - `sender`: The Spotify profile of the sender.
/// - `receiver`: The Spotify profile of the receiver.
/// - `sharedTs`: The timestamp when the resource was shared.
/// - `listened`: A flag indicating whether the resource has been listened to.
/// 
class SharedResource: Codable, Identifiable, Equatable {
    let id: UUID
    private var resource: SpotifyResource?
    private let resourceId: String
    private let type: ResourceType
    private let sender: SpotifyProfile
    private let receiver: SpotifyProfile
    private let sharedTs: TimeInterval
    private var listened: Bool
    
    /// Implement Equatable protocol
    static func == (lhs: SharedResource, rhs: SharedResource) -> Bool {
            return lhs.id == rhs.id
        }
    
    /// Mapping of the Swift object properties to the Appwrite `SharedResource` Collection model.
    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case resourceId
        case type
        case sender
        case receiver
        case sharedTs
        case listened
    }
    
    /// Regular initializer for creating the object directly.
    init(resource: SpotifyResource, sender: SpotifyProfile, receiver: SpotifyProfile, sharedTs: TimeInterval = Date().timeIntervalSince1970) {
        self.id = UUID()
        self.resource = resource
        self.resourceId = resource.getSpotifyId()
        self.type = SharedResource.determineType(for: resource)
        self.sender = sender
        self.receiver = receiver
        self.sharedTs = sharedTs // Defaults to current timestamp
        self.listened = false
    }
    
    /// Custom initializer for decoding from Appwrite.
    /// This makes sure to decode the `SharedResource` using the Appwrite CodingKeys.
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(UUID.self, forKey: .id)
        self.resource = nil  // This will be set after the init, when fetched from Spotify
        self.resourceId = try container.decode(String.self, forKey: .resourceId)
        self.type = try container.decode(ResourceType.self, forKey: .type)

        // Decode sender and receiver using the Appwrite keys for `SpotifyProfile`
        let senderDecoder = try container.superDecoder(forKey: .sender)
        self.sender = try SpotifyProfile(fromAppwrite: senderDecoder)
        let receiverDecoder = try container.superDecoder(forKey: .receiver)
        self.receiver = try SpotifyProfile(fromAppwrite: receiverDecoder)
        
        /// Converting from `Integer` to `TimeInterval` since Appwrite only supports the former.
        let sharedTsInt = try container.decode(Int.self, forKey: .sharedTs)
        self.sharedTs = TimeInterval(sharedTsInt)
        self.listened = try container.decode(Bool.self, forKey: .listened)
    }
    
    /// Custom encode method for Appwrite
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(resourceId, forKey: .resourceId)
        try container.encode(type, forKey: .type)
        try container.encode(sender, forKey: .sender)
        try container.encode(receiver, forKey: .receiver)
        try container.encode(Int(sharedTs), forKey: .sharedTs)
        try container.encode(listened, forKey: .listened)
    }
    
    /// Returns the type of the given resource.
    static private func determineType(for resource: SpotifyResource) -> ResourceType {
        switch resource {
        case is Album:
            return .album
        case is Artist:
            return .artist
        default:
            return .track
        }
    }
    
    // Getters and setters
    public func getId() -> UUID {
        return self.id
    }
    
    public func getIdString() -> String {
        return self.id.uuidString
    }
    
    public func getResource() -> SpotifyResource? {
        return self.resource
    }
    
    public func setResource(resource: SpotifyResource) {
        self.resource = resource
    }
    
    public func getResourceId() -> String {
        return self.resourceId
    }
    
    public func getType() -> ResourceType {
        return self.type
    }
    
    
    public func getSender() -> SpotifyProfile {
        return self.sender
    }
    
    
    public func getReceiver() -> SpotifyProfile {
        return self.receiver
    }
    
    
    public func getSharedTs() -> TimeInterval {
        return self.sharedTs
    }
    
    public func isListened() -> Bool {
        return self.listened
    }
    
    public func markAsListened() {
        self.listened = true
    }
    
    public func markAsNotListened() {
        self.listened = false
    }
    
}

enum ResourceType: String, Codable {
    case album
    case artist
    // case playlist // Uncomment if/when playlists are supported
    case track
}
