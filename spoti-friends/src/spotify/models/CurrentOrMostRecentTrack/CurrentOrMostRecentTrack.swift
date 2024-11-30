import Foundation
import RealmSwift

/// Object representing a user's current or most recent track that they played.
class CurrentOrMostRecentTrack: Object, Decodable {
    @Persisted var timestamp: TimeInterval
    @Persisted var track: Track?
    @Persisted var playedWithinLastFifteenMinutes: Bool
    
    /// Returns `True` if the track was played within the last 15 minutes, `False` otherwise.
    /// We deem a track to be "playing now" if it was played within the last 15 minutes. That is how Spotify does it.
    func isTrackPlayingNow() -> Bool {
        return !hasFifteenMinutesPassed(since: self.timestamp)
    }
}
