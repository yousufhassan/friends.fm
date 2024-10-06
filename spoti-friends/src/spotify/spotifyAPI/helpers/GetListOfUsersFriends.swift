import Foundation
import RealmSwift

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
        let spotifyId = SpotifyProfile.getSpotifyId(fromUri: friendObject.user.uri)
        let spotifyUri = friendObject.user.uri
        let displayName = friendObject.user.name
        let image = friendObject.user.imageUrl ?? ""
        let currentOrMostRecentTrack = getCurrentOrMostRecentTrackForFriend(friendObject)
        
        return SpotifyProfile(spotifyId: spotifyId, spotifyUri: spotifyUri, displayName: displayName,
                              image: image, currentOrMostRecentTrack: currentOrMostRecentTrack)
    }
    
    /// Creates and returns the `CurrentOrMostRecentTrack` for the friend from the `/buddylist` endpoint response object.
    ///
    /// - Parameters:
    ///   - friendObject: The friend object to convert.
    ///
    /// - Returns: The `CurrentOrMostRecentTrack` for this friend.
    private func getCurrentOrMostRecentTrackForFriend(_ friendObject: BuddylistFriendObject) -> CurrentOrMostRecentTrack {
        let timestampInSeconds = friendObject.timestamp / 1000 // Spotify returns it in milliseconds, we want it in seconds
        let track = Track(spotifyUri: friendObject.track.uri,
                          name: friendObject.track.name,
                          artists: [friendObject.track.artist.buddylistArtistToSpotifyArist()],
                          album: friendObject.track.album.buddylistArtistToSpotifyAlbum(imageURL: friendObject.track.imageUrl),
                          context: friendObject.track.context.buddylistArtistToTrackContext())

        return CurrentOrMostRecentTrack(timestamp: timestampInSeconds, track: track)
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
            return Artist(spotifyUri: self.uri, name: self.name, genres: [], image: "")
        }
    }
    
    struct BuddylistAlbumObject: Codable {
        let uri: String
        let name: String
        
        func buddylistArtistToSpotifyAlbum(imageURL: String) -> Album {
            return Album(spotifyUri: self.uri, name: self.name, image: imageURL)
        }
    }
    
    struct BuddylistContextObject: Codable {
        let uri: String
        let name: String
        let index: Int
        
        func buddylistArtistToTrackContext() -> TrackContext {
            return TrackContext(spotifyUri: self.uri, name: self.name)
        }
    }
}
