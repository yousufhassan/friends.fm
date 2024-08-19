import Foundation

/// This extension adds functionality related to the `/buddylist` endpoint.
extension SpotifyAPI {
    
    /// Converts the `data` object to a list of `SpotifyProfile`s for the user's friends.
    ///
    /// - Parameters:
    ///   - data: Data object returned from `buddylist` endpoint.
    ///
    /// - Returns: A list of the user's friends as `SpotifyProfile` objects.
    internal func convertDataToFriendList(_ data: Data) throws -> [SpotifyProfile] {
        do {
            let buddylistResponseObject = try JSONDecoder().decode(BuddylistResponseObject.self, from: data)
            var friendList: [SpotifyProfile] = []
            for friendObject in buddylistResponseObject.friends {
                friendList.append(friendObjectToSpotifyProfile(friendObject))
            }
            return friendList
        } catch {
            printError("\(error)")
            throw error
        }
    }
    
    /// Converts the `friendObject` from the `/buddylist` response to a `SpotifyProfile`.
    ///
    /// - Parameters:
    ///   - friendObject: The friend object to convert.
    ///
    /// - Returns: The friend as a `SpotifyProfile` object.
    private func friendObjectToSpotifyProfile(_ friendObject: BuddylistFriendObject) -> SpotifyProfile {
        let spotifyProfile = SpotifyProfile()
        spotifyProfile.spotifyId = spotifyProfile.getSpotifyIdFromUri(spotifyUri: friendObject.user.uri)
        spotifyProfile.spotifyUri = friendObject.user.uri
        spotifyProfile.displayName = friendObject.user.name
        spotifyProfile.image = friendObject.user.imageUrl ?? ""
        spotifyProfile.currentOrMostRecentTrack = getCurrentOrMostRecentTrackForFriend(friendObject)
        
        return spotifyProfile
    }
    
    /// Creates and returns the `CurrentOrMostRecentTrack` for the friend from the `/buddylist` endpoint response object.
    ///
    /// - Parameters:
    ///   - friendObject: The friend object to convert.
    ///
    /// - Returns: The `CurrentOrMostRecentTrack` for this friend.
    private func getCurrentOrMostRecentTrackForFriend(_ friendObject: BuddylistFriendObject) -> CurrentOrMostRecentTrack {
        let track = Track()
        track.spotifyUri = friendObject.track.uri
        track.name = friendObject.track.name
        track.artist = friendObject.track.artist.buddylistArtistToSpotifyArist()
        track.album = friendObject.track.album.buddylistArtistToSpotifyAlbum(imageURL: friendObject.track.imageUrl)
        track.context = friendObject.track.context.buddylistArtistToTrackContext()
        
        let currentOrMostRecentTrack = CurrentOrMostRecentTrack()
        let timestampInSeconds = friendObject.timestamp / 1000 // Spotify returns it in milliseconds, we want it in seconds
        currentOrMostRecentTrack.timestamp = timestampInSeconds
        currentOrMostRecentTrack.track = track
        currentOrMostRecentTrack.playedWithinLastFifteenMinutes = currentOrMostRecentTrack.isTrackPlayingNow()
        
        return currentOrMostRecentTrack
    }
}

fileprivate typealias BuddylistFriendObject = BuddylistResponseObject.BuddylistFriendObject

/// The shape of the `data` object returned from the `/buddylist` endpoint.
private struct BuddylistResponseObject: Codable {
    let friends: [BuddylistFriendObject]
    
    struct BuddylistFriendObject: Codable {
        let timestamp: Double
        let user: BuddylistUserObject
        let track: BuddylistTrackObject
    }
    
    struct BuddylistUserObject: Codable {
        let uri: String
        let name: String
        let imageUrl: String?
    }
    
    struct BuddylistTrackObject: Codable {
        let uri: String
        let name: String
        let imageUrl: String
        let artist: BuddylistArtistObject
        let album: BuddylistAlbumObject
        let context: BuddylistContextObject
    }
    
    struct BuddylistArtistObject: Codable {
        let uri: String
        let name: String
        
        func buddylistArtistToSpotifyArist() -> Artist {
            let artist = Artist()
            artist.spotifyUri = self.uri
            artist.name = self.name
            return artist
        }
    }
    
    struct BuddylistAlbumObject: Codable {
        let uri: String
        let name: String
        
        func buddylistArtistToSpotifyAlbum(imageURL: String) -> Album {
            let album = Album()
            album.spotifyUri = self.uri
            album.name = self.name
            album.image = imageURL
            return album
        }
    }
    
    struct BuddylistContextObject: Codable {
        let uri: String
        let name: String
        let index: Int
        
        func buddylistArtistToTrackContext() -> TrackContext {
            let context = TrackContext()
            context.spotifyUri = self.uri
            context.name = self.name
            context.type = context.extractContextTypeFromUri()
            return context
        }
    }
}
