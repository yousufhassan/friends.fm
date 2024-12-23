import Foundation

struct SharedResourceMock {
    static let sentResources = [resource1, resource2, resource3, resource4]
    static let receivedResources = [resource1, resource2, resource3, resource4]
    
    static let resource1 = SharedResource(resource: TrackMock.iRememberEverything,
                                          sender: UserMock.userJimHalpert,
                                          receiver: SpotifyProfileMock.dwightSchrute)
    
    static let resource2 = SharedResource(resource: TrackMock.iRememberEverything,
                                          sender: UserMock.userJimHalpert,
                                          receiver: SpotifyProfileMock.michaelScott)
    
    static let resource3 = SharedResource(resource: TrackMock.luxury,
                                          sender: UserMock.userJimHalpert,
                                          receiver: SpotifyProfileMock.dwightSchrute)
    
    static let resource4 = SharedResource(resource: TrackMock.traitor,
                                          sender: UserMock.userJimHalpert,
                                          receiver: SpotifyProfileMock.stanleyHudson)
}
