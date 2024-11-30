import Foundation

/// Object representing a user's current or most recent track that they played.
class CurrentOrMostRecentTrack: Codable {
    var timestamp: TimeInterval
    var track: Track
    var playedWithinLastFifteenMinutes: Bool
    
    init(timestamp: TimeInterval, track: Track) {
        self.timestamp = timestamp
        self.track = track
        self.playedWithinLastFifteenMinutes = !hasFifteenMinutesPassed(since: timestamp)
    }
    
    /// Returns `True` if the track was played within the last 15 minutes, `False` otherwise.
    /// We deem a track to be "playing now" if it was played within the last 15 minutes. That is how Spotify does it.
    func isTrackPlayingNow() -> Bool {
        return !hasFifteenMinutesPassed(since: self.timestamp)
    }
}
