import Foundation

struct SharedResourceMock {
    static let receivedResources = [resource2, resource1, resource4, resource3]
    static let sentResources = [resource1, resource2, resource3, resource4]
    
    static let resource1 = SharedResource(resource: TrackMock.iRememberEverything,
                                          sender: SpotifyProfileMock.jimHalpert,
                                          receiver: SpotifyProfileMock.dwightSchrute,
                                          sharedTs: 999)
    
    static let resource2 = SharedResource(resource: TrackMock.iRememberEverything,
                                          sender: SpotifyProfileMock.jimHalpert,
                                          receiver: SpotifyProfileMock.michaelScott,
                                          sharedTs: 999)
    
    static let resource3 = SharedResource(resource: TrackMock.luxury,
                                          sender: SpotifyProfileMock.jimHalpert,
                                          receiver: SpotifyProfileMock.dwightSchrute)
    
    static let resource4 = SharedResource(resource: TrackMock.traitor,
                                          sender: SpotifyProfileMock.jimHalpert,
                                          receiver: SpotifyProfileMock.stanleyHudson)
}
