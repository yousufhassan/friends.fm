import Foundation

/// Struct containing mock CurrentOrMostRecentTrack objects.
struct CurrentOrMostRecentTrackMock {
    static let iRememberEverything = createMockCurrentOrMostRecentTrack(timestamp: 1720151150,
                                                                        track: TrackMock.iRememberEverything)
    static let traitor = createMockCurrentOrMostRecentTrack(timestamp: 1720151150,
                                                            track: TrackMock.traitor)
    
    static let luxury = createMockCurrentOrMostRecentTrack(timestamp: 1720074752,
                                                           track: TrackMock.luxury)
     
    static func createMockCurrentOrMostRecentTrack(timestamp: TimeInterval, track: Track) -> CurrentOrMostRecentTrack {
        let currTrack = CurrentOrMostRecentTrack()
        currTrack.timestamp = timestamp
        currTrack.track = track
        currTrack.playedWithinLastFifteenMinutes = currTrack.isTrackPlayingNow()
        return currTrack
    }
}
