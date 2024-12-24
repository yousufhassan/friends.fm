import Foundation

// TODO: Add docs. Include brief explanation on why resource is stored as a String.
class SharedResource: Codable, Identifiable {
    let id: UUID
    private var resource: SpotifyResource?
    private let resourceId: String
    private let type: ResourceType
    private let sender: User
    private let receiver: SpotifyProfile
    private let sharedTs: TimeInterval
    
    /// Mapping of the Swift object properties to the Appwrite `SharedResource` Collection model.
    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case resourceId
        case type
        case sender
        case receiver
        case sharedTs
    }
    
    /// Regular initializer for creating the object directly.
    init(resource: SpotifyResource, sender: User, receiver: SpotifyProfile) {
        self.id = UUID()
        self.resource = resource
        self.resourceId = resource.getSpotifyId()
        self.type = SharedResource.determineType(for: resource)
        self.sender = sender
        self.receiver = receiver
        self.sharedTs = Date().timeIntervalSince1970 // Set to current timestamp
    }
    
    /// Custom initializer for decoding from Appwrite.
    /// This makes sure to decode the `SharedResource` using the Appwrite CodingKeys.
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(UUID.self, forKey: .id)
        self.resource = nil  // This will be set after the init, when fetched from Spotify
        self.resourceId = try container.decode(String.self, forKey: .resourceId)
        self.type = try container.decode(ResourceType.self, forKey: .type)
        self.sender = try container.decode(User.self, forKey: .sender)

        // Decode spotifyProfile using the Appwrite keys
        let spotifyProfileDecoder = try container.superDecoder(forKey: .receiver)
        self.receiver = try SpotifyProfile(fromAppwrite: spotifyProfileDecoder)
        
        /// Converting from `Integer` to `TimeInterval` since Appwrite only supports the former.
        let sharedTsInt = try container.decode(Int.self, forKey: .sharedTs)
        self.sharedTs = TimeInterval(sharedTsInt)
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
    
    // Getters (no setters since those attributes should be immutable once initialized)
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
    
    
    public func getSender() -> User {
        return self.sender
    }
    
    
    public func getReceiver() -> SpotifyProfile {
        return self.receiver
    }
    
    
    public func getSharedTs() -> TimeInterval {
        return self.sharedTs
    }
    
}

enum ResourceType: String, Codable {
    case album
    case artist
    // case playlist // Uncomment if/when playlists are supported
    case track
}
