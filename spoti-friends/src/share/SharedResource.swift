import Foundation

// TODO: Add docs. Include brief explanation on why resource is stored as a String.
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
    init(resource: T, sender: User, receiver: SpotifyProfile) {
        self.id = UUID()
        self.type = SharedResource.determineType(for: resource)
        self.resource = resource
        self.sender = sender
        self.receiver = receiver
        self.sharedTs = Date().timeIntervalSince1970 // Set to current timestamp
    }
    
    /// Custom initializer for decoding from Appwrite.
    /// This makes sure to decode the `SharedResource` using the Appwrite CodingKeys.
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(UUID.self, forKey: .id)
        self.type = try container.decode(ResourceType.self, forKey: .type)
        self.sender = try container.decode(User.self, forKey: .sender)

        // Decode spotifyProfile using the Appwrite keys
        let spotifyProfileDecoder = try container.superDecoder(forKey: .receiver)
        self.receiver = try SpotifyProfile(fromAppwrite: spotifyProfileDecoder)
        
        /// Converting from `Integer` to `TimeInterval` since Appwrite only supports the former.
        let sharedTsInt = try container.decode(Int.self, forKey: .sharedTs)
        self.sharedTs = TimeInterval(sharedTsInt)
        
        // Decode the resource JSON string and convert it back to the resource object.
        // View comments about why it is stored as a String below in the encode() function.
        let resourceAsString = try container.decode(String.self, forKey: .resource)
        let resourceData = Data(resourceAsString.utf8)
        
        // Decode the resource dynamically based on the resource type.
        switch type {
        case .album:
            self.resource = try JSONDecoder().decode(Album.self, from: resourceData) as! T
        case .artist:
            self.resource = try JSONDecoder().decode(Artist.self, from: resourceData) as! T
        case .track:
            self.resource = try JSONDecoder().decode(Track.self, from: resourceData) as! T
        }
    }
    
    /// Custom encode method for Appwrite
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(sender, forKey: .sender)
        try container.encode(receiver, forKey: .receiver)
        try container.encode(Int(sharedTs), forKey: .sharedTs)
        
        // Encode the resource dynamically based on its type and then store as a String.
        // We are storing the resource object as a String for two main reasons:
        //   1. It is simpler. The alternative is to create a collection for each resource type
        //      (album, artist, etc). This is added database schema complexity. It also means we
        //      we will be persisting this data, which we don't want or need. It should be managed
        //      by Spotify.
        //   2. Another alternative was to only store the resourceId (i.e. albumId, trackId, etc).
        //      However, this would mean on each fetch from the database, we would need to make
        //      a Spotify API call to fetch the rest of the resource object. This would make the
        //      fetching calls more complex and make performance slower. This is especially not
        //      ideal since we will be accessing this data frequently.
        switch type {
        case .album:
            let jsonData = try JSONEncoder().encode(resource as! Album)
            let jsonString = String(data: jsonData, encoding: .utf8)
            try container.encode(jsonString, forKey: .resource)
        case .artist:
            let jsonData = try JSONEncoder().encode(resource as! Artist)
            let jsonString = String(data: jsonData, encoding: .utf8)
            try container.encode(jsonString, forKey: .resource)
        case .track:
            let jsonData = try JSONEncoder().encode(resource as! Track)
            let jsonString = String(data: jsonData, encoding: .utf8)
            try container.encode(jsonString, forKey: .resource)
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
    
    public func getIdString() -> String {
        return self.id.uuidString
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

enum ResourceType: String, Codable {
    case album
    case artist
    // case playlist // Uncomment if/when playlists are supported
    case track
}
