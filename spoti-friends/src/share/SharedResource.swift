import Foundation

class SharedResource<T: SpotifyResource>: Codable, Identifiable {
    let id: UUID
    private let type: ResourceType
    private let sender: User
    private let receiver: SpotifyProfile
    private let sharedTs: TimeInterval
    private let resource: T  // The resource could be any type conforming to SpotifyResource
    
    /// Mapping of the Swift object properties to the Appwrite `SharedResource` Collection model.
    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case type
        case sender
        case receiver
        case sharedTs
        case resource
    }
    
    /// Regular initializer for creating the object directly.
    init(sender: User, receiver: SpotifyProfile, sharedTs: TimeInterval, resource: T) {
        self.id = UUID()
        self.type = SharedResource.determineType(for: resource)
        self.sender = sender
        self.receiver = receiver
        self.sharedTs = sharedTs
        self.resource = resource
    }
    
    /// Custom initializer for decoding from Appwrite.
    /// This makes sure to decode the `SharedResource` using the Appwrite CodingKeys.
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(UUID.self, forKey: .id)
        self.type = try container.decode(ResourceType.self, forKey: .type)
        self.sender = try container.decode(User.self, forKey: .sender)
        self.receiver = try container.decode(SpotifyProfile.self, forKey: .receiver)
        self.sharedTs = try container.decode(TimeInterval.self, forKey: .sharedTs)
        
        // Decode the resource dynamically based on the resource type
        switch type {
        case .album:
            self.resource = try container.decode(Album.self, forKey: .resource) as! T
        case .artist:
            self.resource = try container.decode(Artist.self, forKey: .resource) as! T
        case .track:
            self.resource = try container.decode(Track.self, forKey: .resource) as! T
        }
    }
    
    /// Custom encode method for Appwrite
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(sender, forKey: .sender)
        try container.encode(receiver, forKey: .receiver)
        try container.encode(sharedTs, forKey: .sharedTs)
        
        // Encode the resource dynamically based on its type
        switch type {
        case .album:
            try container.encode(resource as! Album, forKey: .resource)
        case .artist:
            try container.encode(resource as! Artist, forKey: .resource)
        case .track:
            try container.encode(resource as! Track, forKey: .resource)
        }
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
    
    
    public func getResource() -> T {
        return self.resource
    }
    
}

enum ResourceType: Codable {
    case album
    case artist
    // case playlist // Uncomment if/when playlists are supported
    case track
}
