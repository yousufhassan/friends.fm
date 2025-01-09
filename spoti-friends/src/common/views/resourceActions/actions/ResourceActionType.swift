import Foundation
import SwiftUI

/// Enum representing different types of actions that can be performed on a `SpotifyResource`.
///
/// Each case corresponds to a specific action, with associated properties such as icon, label, and a closure for the action itself.
/// This enum allows flexible selection of which actions to render in a given view.
///
/// Available actions:
/// - `openInSpotify`: Opens the resource in the Spotify app using the Spotify URI.
/// - `addToQueue`: Adds the resource to the user's queue. Returns the relevant error on failure (e.g. not a Premium subscriber, no active device found).
enum ResourceActionType {
    case openInSpotify(showSheet: Binding<Bool>, resource: SpotifyResource)
    case addToQueue(showSheet: Binding<Bool>, resource: SpotifyResource, user: User, onError: (AddToQueueError) -> Void)
    case goToAlbum(showSheet: Binding<Bool>, resource: Track)
    
    var icon: Image {
        switch self {
        case .openInSpotify:
            return Image(.spotifyIconGreen)
        case .addToQueue:
            return Image(systemName: "plus.circle")
        case .goToAlbum:
            return Image(systemName: "smallcircle.circle")
        }
    }
    
    var label: String {
        switch self {
        case .openInSpotify:
            return "Open in Spotify"
        case .addToQueue:
            return "Add to queue"
        case .goToAlbum:
            return "Go to album"
        }
    }
    
    var action: () -> Void {
        switch self {
        case .openInSpotify(let showSheet, let resource):
            return {
                self.closeActionsSheet(showSheet: showSheet)
                if let url = URL(string: resource.getSpotifyUri()) {
                    UIApplication.shared.open(url)
                }
            }
        case .addToQueue(let showSheet, let resource, let user, let onError):
            return {
                let queryParams = [
                    URLQueryItem(name: "uri", value: resource.getSpotifyUri())
                ]
                let accessToken = user.getSpotifyWebAccessToken()
                Task {
                    do {
                        let _ = try await SpotifyAPI.shared.fetch(method: .POST,
                                                                  endpoint: .addItemToQueue,
                                                                  responseType: SpotifyAPI.VoidResponse.self,
                                                                  accessToken: accessToken.getAccessToken(),
                                                                  queryParams: queryParams)
                        
                        self.closeActionsSheet(showSheet: showSheet)
                    } catch let error as SpotifyAPIError {
                        switch error {
                        case .forbidden:
                            onError(.premiumRequired)
                        case .notFound:
                            onError(.noActiveDevice)
                        default:
                            onError(.unknown)
                        }
                    }
                }
            }
        case .goToAlbum(let showSheet, let track):
            return {
                self.closeActionsSheet(showSheet: showSheet)
                if let url = URL(string: track.album.getSpotifyUri()) {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    
    /// Closes the resource actions sheet.
    func closeActionsSheet(showSheet: Binding<Bool>) {
        DispatchQueue.main.async {
            showSheet.wrappedValue = false
        }
    }
    
    // Preset action arrays for different contexts
    /// The set of actions available for a received resource.
    static func receivedResourceActions(showSheet: Binding<Bool>,
                                        resource: SpotifyResource,
                                        user: User,
                                        onError: @escaping (AddToQueueError) -> Void) -> [ResourceActionType] {
        var actions: [ResourceActionType] = [
            .openInSpotify(showSheet: showSheet, resource: resource),
            .addToQueue(showSheet: showSheet, resource: resource, user: user, onError: onError)
        ]
        
        if (resource is Track) {
            let track = resource as! Track
            actions.append(.goToAlbum(showSheet: showSheet, resource: track))
        }
        
        return actions
    }
}
